//
//  QJDTagToolBar.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/21.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTagToolBar.h"

@implementation QJDTagToolBar

+ (instancetype)tagToolBar {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

@end
