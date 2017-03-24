//
//  QJDCategoryCell.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QJDCategory;

@interface QJDCategoryCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 模型属性 */
@property (nonatomic, strong) QJDCategory *category;
@end
