//
//  QJDPushGuideView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/12.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDPushGuideView.h"

@implementation QJDPushGuideView

+ (void)show {

    // 获取当前应用版本
    //NSLog(@"%@", [NSBundle mainBundle].infoDictionary);
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 获取沙盒存储的版本
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        // 显示推送引导
        QJDPushGuideView *pgVc = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QJDPushGuideView class]) owner:nil options:nil] lastObject];
        // 主窗口
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        pgVc.frame = window.bounds;
        [window addSubview:pgVc];
    }
    
    // 存储版本号
    [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize]; // 立即存储
}

- (IBAction)close {
    
    [self removeFromSuperview];
}

@end
