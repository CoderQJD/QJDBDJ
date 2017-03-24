//
//  QJDTopicCell.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QJDTopic;

@interface QJDTopicCell : UITableViewCell

/** 帖子模型 */
@property (nonatomic, strong) QJDTopic *topic;

+ (instancetype)cell;

@end
