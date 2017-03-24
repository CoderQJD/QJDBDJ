//
//  QJDPlaceholderTextView.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/21.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QJDPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
