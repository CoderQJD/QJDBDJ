//
//  QJDCommentHeaderView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/18.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDCommentHeaderView.h"

@interface QJDCommentHeaderView ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation QJDCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    QJDCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) { // 缓存池中没有, 自己创建
        header = [[QJDCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = QJDGlobalColor;
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = QJDColor(67, 67, 67, 1);
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.x = QJDTopicCellMargin;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title {

    _title = [title copy];
    
    self.label.text = title;
}

@end
