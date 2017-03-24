//
//  QJDTextField.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/12.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTextField.h"
#import <objc/runtime.h>

@implementation QJDTextField


+ (void)initialize {
    QJDFunc;
    unsigned int count = 0;
    
    // 拷贝所有的成员变量
    Ivar *ivars = class_copyIvarList([UIButton class], &count);
    
    for (int i = 0; i < count; i++) {
        // 取出成员变量
        Ivar ivar = *(ivars + i);
        // 打印成员变量名
        NSLog(@"%s", ivar_getName(ivar));
    }
    
    // 释放
    free(ivars);
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self resignFirstResponder];
    
    // 设置光标颜色
    self.tintColor = self.textColor;
}

/** 
 成为第一响应者
 */
- (BOOL)becomeFirstResponder {

    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    return [super becomeFirstResponder];
}
/**
 辞去第一响应者
 */
- (BOOL)resignFirstResponder {
    
    [self setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];

    return [super resignFirstResponder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {

    _placeholderColor = placeholderColor;
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}
@end
