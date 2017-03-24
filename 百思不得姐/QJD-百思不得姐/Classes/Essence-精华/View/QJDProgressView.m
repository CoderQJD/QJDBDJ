//
//  QJDProgressView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/15.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDProgressView.h"

@implementation QJDProgressView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {

    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%0.f%%", progress * 100];
    
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
@end
