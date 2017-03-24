//
//  QJDCommentHeaderView.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/18.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJDCommentHeaderView : UITableViewHeaderFooterView

/** 标题 */
@property (nonatomic, copy) NSString *title;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
