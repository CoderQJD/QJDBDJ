//
//  QJDSquareButton.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/20.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QJDSquare;

@interface QJDSquareButton : UIButton

/** 方块模型 */
@property (nonatomic, strong) QJDSquare *square;
@end
