//
//  QJDMeViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDMeViewController.h"
#import "QJDMeCell.h"
#import "QJDMeFooterView.h"
#import "QJDSettingController.h"

static NSString * const XMGMeId = @"me";

@interface QJDMeViewController ()

@end

@implementation QJDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [self setupTableView];
}

- (void)setupTableView {
    // 背景颜色
    self.tableView.backgroundColor = QJDGlobalColor;
    
    // 设置背景色
    self.tableView.backgroundColor = QJDGlobalColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QJDMeCell class] forCellReuseIdentifier:XMGMeId];
    
    // 调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = QJDTopicCellMargin;
    
    // 调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(QJDTopicCellMargin - 35, 0, 0, 0);
    
    // 设置footerView
    self.tableView.tableFooterView = [[QJDMeFooterView alloc] init];
}

- (void)setNav {
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    // 设置有右边按钮
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImageName:@"mine-setting-icon" lightImageName:@"mine-setting-icon-click" target:self action:@selector(setClick)];
    
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImageName:@"mine-moon-icon" lightImageName:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems = @[item1, item2];
}

- (void)setClick {
    QJDSettingController *setVc = [[QJDSettingController alloc] init];
    
    [self.navigationController pushViewController:setVc animated:YES];
}

- (void)moonClick {
    QJDFunc;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJDMeCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}


@end
