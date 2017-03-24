//
//  QJDNewViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDNewViewController.h"

@interface QJDNewViewController ()

@end

@implementation QJDNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = QJDGlobalColor;
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:@"MainTagSubIcon" lightImageName:@"MainTagSubIconClick" target:self action:@selector(newClick)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)newClick {
    QJDFunc;
}

@end
