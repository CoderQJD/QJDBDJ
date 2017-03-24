//
//  QJDTaBarController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTaBarController.h"
#import "QJDEssenceViewController.h"
#import "QJDNewViewController.h"
#import "QJDFriendTrendsViewController.h"
#import "QJDMeViewController.h"
#import "QJDTabBar.h"
#import "QJDNavigationController.h"

@interface QJDTaBarController ()

@end

@implementation QJDTaBarController

+ (void)initialize {

    // 通过Apprance统一设置TabBarItem的Title属性, UI_APPEARANCE_SELECTOR的方法可用
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    NSMutableDictionary *selected = [NSMutableDictionary dictionary];
    selected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selected forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加子控制器
    [self setChildVc:[[QJDEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selected:@"tabBar_essence_click_icon"];
    [self setChildVc:[[QJDNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selected:@"tabBar_new_click_icon"];
    [self setChildVc:[[QJDFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selected:@"tabBar_friendTrends_click_icon"];
    [self setChildVc:[[QJDMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我的" image:@"tabBar_me_icon" selected:@"tabBar_me_click_icon"];
    
    // 替换tabBar
    [self setValue:[[QJDTabBar alloc] init] forKey:@"tabBar"];
    
}

/** 初始化子控制器 */
- (void)setChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)imageName selected:(NSString *)selectedImageName {

    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    QJDNavigationController *nav = [[QJDNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
