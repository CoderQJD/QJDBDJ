//
//  UIImage+QJDExtension.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/19.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "UIImage+QJDExtension.h"

@implementation UIImage (QJDExtension)

/**
 图片圆角处理
 */
- (instancetype)circleImage {

    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 取得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪
    CGContextClip(context);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    // 获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
