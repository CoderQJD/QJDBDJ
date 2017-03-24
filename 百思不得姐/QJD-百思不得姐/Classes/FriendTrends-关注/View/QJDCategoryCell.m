//
//  QJDCategoryCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/10.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDCategoryCell.h"
#import "QJDCategory.h"

@interface QJDCategoryCell ()

/** 选中左边列表的指示器 */
@property (weak, nonatomic) IBOutlet UIView *selectIndicator;

@end

@implementation QJDCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = QJDColor(244, 244, 244, 1);
    self.selectIndicator.backgroundColor = QJDColor(219, 21, 26, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - self.textLabel.y * 2;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    QJDCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setCategory:(QJDCategory *)category {

    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.selectIndicator.hidden = !selected;
    
    self.textLabel.textColor = selected? self.selectIndicator.backgroundColor : QJDColor(78, 78, 78, 1);
}

@end
