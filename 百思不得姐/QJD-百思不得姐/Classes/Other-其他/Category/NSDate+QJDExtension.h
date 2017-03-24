//
//  NSDate+QJDExtension.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/15.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (QJDExtension)
/**  
 比较self和from的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 是否为今年
 */
- (BOOL)isThisYear;

/**
 是否为今天
 */
- (BOOL)isThisToday;

/**
 是否为昨天
 */
- (BOOL)isThisYesterday;
@end
