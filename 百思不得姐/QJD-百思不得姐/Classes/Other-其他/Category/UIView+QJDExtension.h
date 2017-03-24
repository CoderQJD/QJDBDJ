//
//  UIView+QJDExtension.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QJDExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/** 
 判断控件是否显示在主窗口 
 */
- (BOOL)isShowingOnKeyWindow;
@end
