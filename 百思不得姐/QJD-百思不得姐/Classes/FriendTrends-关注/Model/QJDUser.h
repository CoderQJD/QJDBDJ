//
//  QJDUser.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDUser : NSObject

/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;

@end
