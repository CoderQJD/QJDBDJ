//
//  UIImageView+QJDExtension.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/19.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "UIImageView+QJDExtension.h"
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>

@implementation UIImageView (QJDExtension)

- (void)setHeaderImageWithURLString:(NSString *)url {

    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.image = image? [image circleImage] : placeholder;
        
    }];
}
@end
