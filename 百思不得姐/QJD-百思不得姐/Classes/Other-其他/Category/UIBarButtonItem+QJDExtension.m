//
//  UIBarButtonItem+QJDExtension.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "UIBarButtonItem+QJDExtension.h"

@implementation UIBarButtonItem (QJDExtension)

+ (instancetype)itemWithImageName:(NSString *)iamgeName lightImageName:(NSString *)lightImageName target:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:iamgeName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:lightImageName] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}
@end
