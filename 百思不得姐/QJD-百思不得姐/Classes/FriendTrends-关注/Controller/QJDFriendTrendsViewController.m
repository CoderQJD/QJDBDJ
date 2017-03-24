//
//  QJDFriendTrendsViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDFriendTrendsViewController.h"
#import "QJDRecommendViewController.h"
#import "QJDLoginRegistViewController.h"

@interface QJDFriendTrendsViewController ()

@end

@implementation QJDFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 背景颜色
    self.view.backgroundColor = QJDGlobalColor;
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    // 设置左边按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:@"friendsRecommentIcon" lightImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];
    self.navigationItem.leftBarButtonItem = item;
}
- (IBAction)loginRegister {
    
    QJDLoginRegistViewController *lrVc = [[QJDLoginRegistViewController alloc] init];
    
    [self presentViewController:lrVc animated:YES completion:nil];
}

- (void)friendClick {
    
    QJDRecommendViewController *vc = [[QJDRecommendViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
