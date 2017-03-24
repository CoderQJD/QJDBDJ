//
//  QJDMeCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/20.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDMeCell.h"

@implementation QJDMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + QJDTopicCellMargin;
}

// 可以用contentinset代替
//- (void)setFrame:(CGRect)frame
//{
////    XMGLog(@"%@", NSStringFromCGRect(frame));
//    frame.origin.y -= (35 - QJDTopicCellMargin);
//    [super setFrame:frame];
//}

@end
