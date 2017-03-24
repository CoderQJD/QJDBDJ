//
//  QJDTopicViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopicViewController.h"
#import <AFNetworking.h>
#import "QJDTopic.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "QJDTopicCell.h"
#import "QJDCommentViewController.h"
#import "QJDNewViewController.h"

@interface QJDTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 加载下一页所用的参数 */
@property (nonatomic, copy) NSString *maxtime;

/** 选中的索引 */
@property (nonatomic, assign) NSInteger selectedIndex;
@end

static NSString * const TopicCellID = @"topic";

@implementation QJDTopicViewController

- (NSMutableArray *)topics {

    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

- (void)setupTableView {
    
    // 设置内边距
    CGFloat top = QJDTitlesViewY + QJDTitlesViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJDTopicCell class]) bundle:nil] forCellReuseIdentifier:TopicCellID];
    
    // 监听tabar的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:QJDTabBarDidSelectNotification object:nil];
}

/** 监听tabar的通知 */
- (void)tabBarSelect {

    if (self.selectedIndex == self.tabBarController.selectedIndex
        && self.view.isShowingOnKeyWindow) { // 2次点击同一个tabBarButton且显示在窗口上
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    self.selectedIndex = self.tabBarController.selectedIndex;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加刷新控件
 */
- (void)setupRefresh {
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    // 根据拖拽比例自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 立即刷新
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - a参数
- (NSString *)a {

    return [self.parentViewController isKindOfClass:[QJDNewViewController class]]? @"newlist" : @"list";
}

#pragma mark - 数据处理
/**
 加载新的帖子数据
 */
- (void)loadNewTopics {
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将responseObject写成plist
        //[responseObject writeToFile:@"/users/yaoye/Desktop/duanzi.plist" atomically:YES];
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组转模型数组
        self.topics = [QJDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 初始化page
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
 
        QJDLog(@"%@", error);
    }];
}

/**
 加载更多的帖子数据
 */
- (void)loadMoreTopics {
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] =self.maxtime;
    params[@"page"] = @(self.page + 1);
    
    // 发请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组->模型数组
        NSArray *moreTopics = [QJDTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 确保成功后page+1
        self.page ++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        QJDLog(@"%@", error);
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = self.topics.count == 0;
    
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJDTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellID];
    
    cell.topic = self.topics[indexPath.row];

    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJDTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJDCommentViewController *vc = [[QJDCommentViewController alloc] init];
    vc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
