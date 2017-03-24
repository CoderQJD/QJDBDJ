//
//  QJDNavigationController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/9.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDNavigationController.h"

@interface QJDNavigationController ()

@end

@implementation QJDNavigationController

/**
 当第一次使用这个类的时候调用一次
 */
+ (void)initialize {

    // 统一设置背景
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    // 统一设置标题
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    
    // 统一设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    NSMutableDictionary *disabled = [NSMutableDictionary dictionary];
    disabled[NSFontAttributeName] = attrs[NSFontAttributeName];
    disabled[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:disabled forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果滑动移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
    self.interactivePopGestureRecognizer.delegate = nil;
}
/**
 拦截所有push的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        btn.size = CGSizeMake(100, 50);
        [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮内容左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 按钮整体向左平移
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        // 隐藏标签栏
        viewController.hidesBottomBarWhenPushed = YES;
    }
   
    [super pushViewController:viewController animated:animated];
}

- (void)pop {

    [self popViewControllerAnimated:YES];
}

@end
