//
//  QJDCommentCell.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/18.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QJDComment;

@interface QJDCommentCell : UITableViewCell
/** 评论模型 */
@property (nonatomic, strong) QJDComment *comment;
@end
