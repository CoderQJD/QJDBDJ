//
//  QJDRecommendViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "QJDCategoryCell.h"
#import "QJDCategory.h"
#import "QJDUserCell.h"
#import "QJDUser.h"
#import <MJRefresh.h>

#define QJDSelectedCategory self.categores[self.categoryTableView.indexPathForSelectedRow.row]

@interface QJDRecommendViewController () <UITableViewDataSource, UITableViewDelegate>

/** 左边类别列表 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边用户列表 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 左边列表数据 */
@property (nonatomic, strong) NSArray *categores;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *parameters;
/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation QJDRecommendViewController

- (AFHTTPSessionManager *)manager {

    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化控件
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
    
    // 显示指示器
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    [self loadCategores];
}

- (void)setupTableView {
    
    // 背景颜色和标题
    self.view.backgroundColor = QJDGlobalColor;
    self.navigationItem.title = @"我的关注";
    
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
}

- (void)setupRefresh {
    
    // 下拉刷新
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    // 上拉刷新
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark - 加载左边的数据
- (void)loadCategores{

    // 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    self.parameters = parameters;
    
    // 发送请求
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功
        [SVProgressHUD dismiss];
        
        // json -> model
        self.categores = [QJDCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 当前的请求参数不等于上一次的请求参数(不是最后一次请求的参数)就retrun(保证是最后一次请求才执行后面操作)
        if (self.parameters != parameters) return;
        
        // 刷新表视图
        [self.categoryTableView reloadData];
        
        // 默认选择首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 用户列表进入下拉刷新状态(保证第一次进入右边显示内容)
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.parameters != parameters) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载失败!"];
    }];
}

#pragma mark - 加载最新用户数据
- (void)loadNewUsers {
    
    QJDCategory *category = QJDSelectedCategory;
    
    // 发送请求 加载右边数据
    category.currentPage = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(category.ID);
    parameters[@"page"] = @(category.currentPage);
    self.parameters = parameters;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // json->model
        NSArray *users = [QJDUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 删除以前的全部数据
        [category.users removeAllObjects];
        
        [category.users addObjectsFromArray:users];
        
        // 保存数据总数
        category.total = [responseObject[@"total"] integerValue];
        
        // 不是最后一次请求的参数
        if (self.parameters != parameters) return;
        
        // 刷新右边的列表
        [self.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        // 检查footer状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.parameters != parameters) return;
        
        QJDLog(@"%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败!"];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];

}

#pragma mark - 加载更多用户数据
- (void)loadMoreUsers {
    
    // 请求参数
    QJDCategory *category = QJDSelectedCategory;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(category.ID);
    parameters[@"page"] = @(++category.currentPage);
    self.parameters = parameters;
    
    // 发送请求
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // json->model
        NSArray *users = [QJDUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求的参数
        if (self.parameters != parameters) return;
        
        // 刷新表格
        [self.userTableView reloadData];
        
        // 停止刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.parameters != parameters) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败!"];
        
        [self.userTableView.mj_footer endRefreshing];
    }];
}

/**
 检查下拉控件的状态
 */
- (void)checkFooterState {
    
    // 当前选中cell对应的类别模型
    QJDCategory *category = QJDSelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = category.users.count == 0;
    
    // 停止上拉刷新
    if (category.users.count == category.total) { // 加载完全部数据
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 未加载完全部数据
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // 左边类别列表
    if (tableView == self.categoryTableView) return self.categores.count;
    
    // 右边用户列表
    // 监测footer的状态
    [self checkFooterState];
    
    return [QJDSelectedCategory users].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.categoryTableView) {
        
        QJDCategoryCell *cell = [QJDCategoryCell cellWithTableView:tableView];
        
        cell.category = self.categores[indexPath.row];
        
        return cell;
        
    } else {
        QJDUserCell *cell = [QJDUserCell cellWithTableView:tableView];
        
        QJDCategory *c = QJDSelectedCategory;
        
        cell.user = c.users[indexPath.row];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.categoryTableView) { // 点击左边的cell
        QJDCategory *category = self.categores[indexPath.row];
        
        if (category.users.count) { // 右边有数据
            
            // 显示已有的数据
            [self.userTableView reloadData];
            
        } else {
            
            // 目的:显示当前页面用户数据,不让前一个页面用户的数据有所残留
            [self.userTableView reloadData];
            
            // 进入下拉刷新状态
            [self.userTableView.mj_header beginRefreshing];
        }
    
    } else { // 右边的cell
    
        return;
    }
}

#pragma mark - 控制器的销毁
- (void)dealloc {

    [self.manager.operationQueue cancelAllOperations];
}

@end
