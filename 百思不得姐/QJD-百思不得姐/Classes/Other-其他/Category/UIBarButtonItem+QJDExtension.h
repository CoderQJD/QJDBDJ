//
//  UIBarButtonItem+QJDExtension.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (QJDExtension)

/**  */
+ (instancetype)itemWithImageName:(NSString *)iamgeName lightImageName:(NSString *)lightImageName target:(id)target action:(SEL)action;

@end
