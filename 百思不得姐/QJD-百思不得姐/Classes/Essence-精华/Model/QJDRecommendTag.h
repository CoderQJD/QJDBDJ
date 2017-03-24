//
//  QJDRecommendTag.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/11.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDRecommendTag : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *image_list;
/** 名称 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅人数 */
@property (nonatomic, assign) NSInteger sub_number;
@end
