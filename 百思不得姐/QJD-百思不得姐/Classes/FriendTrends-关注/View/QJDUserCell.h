//
//  QJDUserCell.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QJDUser;

@interface QJDUserCell : UITableViewCell

/// 用户模型
@property (nonatomic, strong) QJDUser *user;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
