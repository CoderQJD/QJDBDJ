//
//  QJDRecommendTagController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/11.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDRecommendTagController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "QJDRecommendTag.h"
#import "QJDRecommendTagCell.h"

@interface QJDRecommendTagController ()
/** 模型数组 */
@property (nonatomic, strong) NSArray *recmdTags;
@end

static NSString * const QJDTagID = @"tag";

@implementation QJDRecommendTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    // 显示HUD
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏HUD
        [SVProgressHUD dismiss];
        
        // 字典数组转模型数组
        self.recmdTags = [QJDRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QJDLog(@"%@", error);
    }];
    
}

- (void)setupTableView {

    self.navigationItem.title = @"推荐关注";
    self.tableView.backgroundColor = QJDGlobalColor;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJDRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:QJDTagID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recmdTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QJDRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:QJDTagID];
    
    cell.recmdTag = self.recmdTags[indexPath.row];
    
    return cell;
}


@end
