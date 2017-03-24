//
//  QJDVerticalButton.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/12.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDVerticalButton.h"

@implementation QJDVerticalButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}



- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.width;
    
    // 调整标题
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
