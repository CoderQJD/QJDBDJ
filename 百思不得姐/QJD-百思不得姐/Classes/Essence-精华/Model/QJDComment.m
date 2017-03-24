//
//  QJDComment.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/17.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDComment.h"
#import <MJExtension.h>

@implementation QJDComment

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"commentUser" : @"user",
             @"ID" : @"id"
             };
}
@end
