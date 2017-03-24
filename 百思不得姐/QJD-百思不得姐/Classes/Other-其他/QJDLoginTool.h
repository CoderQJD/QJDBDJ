//
//  QJDLoginTool.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/21.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDLoginTool : NSObject

+ (void)setUid:(NSString *)uid;

+ (NSString *)getUid;

+ (NSString *)getUid:(BOOL)showLoginContrller;

@end
