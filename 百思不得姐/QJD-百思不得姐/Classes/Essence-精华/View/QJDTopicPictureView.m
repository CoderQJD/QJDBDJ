//
//  QJDTopicPictureView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/15.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "QJDTopic.h"
#import "QJDProgressView.h"
#import "QJDShowPictureViewController.h"
#import <FLAnimatedImageView.h>

@interface QJDTopicPictureView ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet QJDProgressView *progressView;

@end

@implementation QJDTopicPictureView

+ (instancetype)pictureView {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

/** 显示图片 */
- (void)showPicture {

    QJDShowPictureViewController *vc = [[QJDShowPictureViewController alloc] init];
    
    vc.topic = self.topic;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setTopic:(QJDTopic *)topic {

    _topic = topic;
    
    // 让进度条显示最新的进度(防止cell重用机制显示重复的进度)
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        self.progressView.hidden = NO;
        
        // 保存进度条值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        
        [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.progressView.hidden = YES;
        
        NSString *extension = topic.largeImage.pathExtension; // 取得扩展名
        if ([extension.lowercaseString isEqualToString:@"gif"]) return;
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureFrame.size, YES, 0.0);
        
        // 将下载完成的image绘制到图形上下文(以如下的矩形方式)
        CGFloat width = topic.pictureFrame.size.width;
        CGFloat height = width * topic.height / topic.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 获得设置好的图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    
    // 判断是否是gif
    NSString *extension = topic.largeImage.pathExtension; // 取得扩展名
    self.gifImageView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    // 判断是否显示@"点击查看大图"
    self.seeBigButton.hidden = ! topic.isBigPicture;
}

@end
