//
//  QJDUserCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDUserCell.h"
#import <UIImageView+WebCache.h>
#import "QJDUser.h"

@interface QJDUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation QJDUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    QJDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setUser:(QJDUser *)user {
    
    _user = user;
    
    self.screenNameLabel.text = user.screen_name;
    
    if (user.fans_count < 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"已有%zd人关注", user.fans_count];
    } else {
        self.fansCountLabel.text = [NSString stringWithFormat:@"已有%.1f万人关注", user.fans_count / 10000.0];
    }
    
    [self.headerView setHeaderImageWithURLString:user.header];
}

@end
