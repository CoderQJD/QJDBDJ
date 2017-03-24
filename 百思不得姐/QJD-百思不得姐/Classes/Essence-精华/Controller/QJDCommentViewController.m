//
//  QJDCommentViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/18.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDCommentViewController.h"
#import "QJDTopic.h"
#import <MJRefresh.h>
#import "QJDTopicCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "QJDComment.h"
#import "QJDCommentHeaderView.h"
#import "QJDCommentCell.h"

static NSString * const QJDCommentID = @"comment";

@interface QJDCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
/** 工具条的bottom间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** AFN管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 最热评论 */
@property (nonatomic, strong) NSMutableArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *newestComments;
/** 保存当前的最热评论 */
@property (nonatomic, strong) QJDComment *saved_top_cmt;
/** 当前的页码 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation QJDCommentViewController

- (NSMutableArray *)hotComments {

    if (!_hotComments) {
        _hotComments = [NSMutableArray array];
    }
    return _hotComments;
}

- (AFHTTPSessionManager *)manager {

    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setupBasic];
    
    // 设置Header
    [self setupHeaderView];
    
    // 添加刷新控件
    [self setupRefresh];
}

/** 基本设置 */
- (void)setupBasic {
    
    self.navigationItem.title = @"评论";
    
    // 设置右边按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:@"comment_nav_item_share_icon" lightImageName:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:item];
    
    // 监听键盘frame的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJDCommentCell class]) bundle:nil] forCellReuseIdentifier:QJDCommentID];
 
    self.tableView.backgroundColor = QJDGlobalColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // cell自动调整高度
    self.tableView.estimatedRowHeight = 44; // cell的估计高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // header的估计高度(没有估计高度不会去调用-(UIView *)tableView:viewForHeaderInSection:
    self.tableView.estimatedSectionHeaderHeight = 30;
}

/** 设置Hearder */
- (void)setupHeaderView {
    
    // 创建头部视图
    UIView *headerView = [[UIView alloc] init];
    
    // 清空top_cmt(隐藏topicCell最热评论)
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 添加cell
    QJDTopicCell *cell = [QJDTopicCell cell];
    
    cell.topic = self.topic;
    
    cell.size = CGSizeMake(QJDScreenW, self.topic.cellHeight);
    
    [headerView addSubview:cell];
    
    headerView.height = cell.size.height + 2*QJDTopicCellMargin;
    
    self.tableView.tableHeaderView = headerView;
}

/** 添加刷新控件 */
- (void)setupRefresh {

    // 添加下拉刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    
    // 自动调整透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 开始刷新
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
    self.tableView.mj_footer.hidden = YES;
}

/** 监听键盘frame的改变 */
- (void)keyboardWillChangeFrame:(NSNotification *)not {
    
    // 清除自定义menuitems
    [UIMenuController sharedMenuController].menuItems = nil;

    // 键盘显示或隐藏完毕的frame
    CGRect frame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 修改底部间距
    self.bottomSpace.constant = QJDScreenH - frame.origin.y;
    
    // 动画时间
    CGFloat duration = [not.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** 
 返回第section的数组 
 */
- (NSArray *)commentsInSection:(NSInteger)section {

    if (section == 0) return self.hotComments.count? self.hotComments : self.newestComments;
    
    return self.newestComments;
}

/** 
 返回indexPath对应的模型
 */
- (QJDComment *)commentsIndexPath:(NSIndexPath *)indexPath{

    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (void)dealloc {

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复top_cmt(显示topicCell最热评论)
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 取消所有任务
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];
}

#pragma mark - 数据处理
/** 加载最新评论数据 */
- (void)loadNewComments {
    
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"host"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        } // 说明没有评论数据
        
        [self.tableView.mj_header endRefreshing];
        
        // 最热评论
        self.hotComments = [QJDComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        self.newestComments = [QJDComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.page = 1;
        
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.newestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        QJDLog(@"%@", error);
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreComments {
    
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(self.page);
    QJDComment *cmt = [self.newestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        } // 说明没有评论数据
        
        NSArray *cmts = [QJDComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.newestComments addObjectsFromArray:cmts];
        
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.newestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        QJDLog(@"%@", error);
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSInteger hotCount = self.hotComments.count;
    NSInteger newCount = self.newestComments.count;
    
    if (hotCount) return 2; // 有热评,就显示2组数据
    if (newCount) return 1; // 没热评,有新评,显示1组数据
    return 0;               // 没热评,没新评,显示0组数据
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger hotCount = self.hotComments.count;
    NSInteger newCount = self.newestComments.count;
    
    self.tableView.mj_footer.hidden = (newCount == 0);
    
    if (section == 0) return hotCount? hotCount : newCount;
    
    return newCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QJDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:QJDCommentID];
    
    QJDComment *cmt = [self commentsIndexPath:indexPath];
    
    cell.comment = cmt;
    
    return cell;
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
    // 键盘弹出,取消自定义menuitem
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if (menu.isMenuVisible) {
    
        [menu setMenuVisible:NO animated:YES];
        return;
    }
    
    QJDCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // cell成为第一响应者
    [cell becomeFirstResponder];
    
    // 自定义菜单按钮
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    
    menu.menuItems = @[ding, replay, report];
    CGRect rect = CGRectMake(0, cell.height / 2, cell.width, cell.height / 2);
    [menu setTargetRect:rect inView:cell];
    [menu setMenuVisible:YES animated:YES];
}

/** 
 header有高度才会调用 -(UIview *)ableView:viewForHeaderInSection:
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 30;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QJDCommentHeaderView *header = [QJDCommentHeaderView headerViewWithTableView:tableView];
    
    if (section == 0) {
        header.title = self.hotComments.count? @"最热评论" : @"最新评论";
    } else{
        header.title = @"最新评论";
    }
    return header;
}

#pragma mark - UIMenuController处理
- (void)ding:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    QJDLog(@"顶-------%@",[self commentsIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    QJDLog(@"收藏------%@",[self commentsIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    QJDLog(@"举报------%@",[self commentsIndexPath:indexPath].content);
}
@end
