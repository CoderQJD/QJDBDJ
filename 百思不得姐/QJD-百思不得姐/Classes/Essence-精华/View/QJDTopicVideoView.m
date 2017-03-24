//
//  QJDTopicVideoView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/17.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopicVideoView.h"
#import "QJDTopic.h"
#import <UIImageView+WebCache.h>
#import "QJDShowPictureViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QJDTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;


/** <#注释#> */
@property (nonatomic, strong) MPMoviePlayerViewController *playerVc;

@end

@implementation QJDTopicVideoView

+ (instancetype)videoView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (MPMoviePlayerViewController *)playerVc
{
    if (_playerVc == nil) {
        NSURL *url = [NSURL URLWithString:self.topic.videouri];
        
        _playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    }
    return _playerVc;
}

- (IBAction)playVideo {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.playerVc animated:YES completion:nil];
}

/** 显示图片 */
- (void)showPicture {
    
//    QJDShowPictureViewController *vc = [[QJDShowPictureViewController alloc] init];
//    
//    vc.topic = self.topic;
//    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.playerVc animated:YES completion:nil];
}

- (void)setTopic:(QJDTopic *)topic {
    
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage]];
    
    // 播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld次播放", topic.playfcount];
    
    // 播放时长
    NSInteger mintue = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", mintue, second];
}
@end
