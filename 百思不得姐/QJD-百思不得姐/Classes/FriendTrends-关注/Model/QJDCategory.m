//
//  QJDCategory.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDCategory.h"

@implementation QJDCategory

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id"};
}

- (NSMutableArray *)users {

    if (!_users) {
        
        _users = [NSMutableArray array];
    }
    
    return _users;
}


@end
