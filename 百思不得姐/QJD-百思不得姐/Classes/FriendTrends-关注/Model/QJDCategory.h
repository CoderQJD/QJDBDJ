//
//  QJDCategory.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDCategory : NSObject
/** 关注人数 */
@property (nonatomic, assign) NSInteger count;
/** ID */
@property (nonatomic, assign) NSInteger ID;
/** 名称 */
@property (nonatomic, strong) NSString *name;

/** 当前左边类别对应的右边数据 */
@property (nonatomic, strong) NSMutableArray *users;
/** 数据总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

@end
