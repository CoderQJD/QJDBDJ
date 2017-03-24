//
//  QJDRecommendTagCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/11.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDRecommendTagCell.h"
#import "QJDRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface QJDRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subCountLabel;

@end

@implementation QJDRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecmdTag:(QJDRecommendTag *)recmdTag {

    _recmdTag = recmdTag;
    
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recmdTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.themeNameLabel.text = recmdTag.theme_name;
    
    if (recmdTag.sub_number < 10000) {
        self.subCountLabel.text = [NSString stringWithFormat:@"%zd人订阅", recmdTag.sub_number];
    } else {
        self.subCountLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", recmdTag.sub_number / 10000.0];
    }
}

/** 修改cell的左右,下面的间距 */
- (void)setFrame:(CGRect)frame {

    frame.origin.x = 5;
    frame.size.width -= frame.origin.x * 2;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}
@end
