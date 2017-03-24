//
//  QJDTabBar.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTabBar.h"
#import "QJDPublishViewController.h"

@interface QJDTabBar ()
/** 发布按钮 */
@property (nonatomic, strong) UIButton *publishButton;
@end
@implementation QJDTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        // 添加发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        self.publishButton = publishButton;
    }
    return self;
}

- (void)publishClick {

    QJDPublishViewController *vc = [[QJDPublishViewController alloc] init];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}

- (void)layoutSubviews {

    [super layoutSubviews];

    // 设置publishButton的frame
    self.publishButton.size = self.publishButton.currentBackgroundImage.size;
    self.publishButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);

    // 设置其他按钮的frame
    NSUInteger index = 0;
    
    CGFloat buttonY = 0;
    CGFloat buttonW = self.width / 5;
    CGFloat buttonH = self.height;
    
    for (UIView *button in self.subviews) {
     
        if(![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        CGFloat buttonX = buttonW * ((index>1)?(index + 1) : index);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index ++;
    }
}

@end
