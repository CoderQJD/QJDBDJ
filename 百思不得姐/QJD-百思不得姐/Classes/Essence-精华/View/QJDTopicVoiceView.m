//
//  QJDTopicVoiceView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/17.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopicVoiceView.h"
#import "QJDTopic.h"
#import <UIImageView+WebCache.h>
#import "QJDShowPictureViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QJDTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

/** 音频播放器 */
@property (nonatomic, strong) MPMoviePlayerViewController *player;

@end

@implementation QJDTopicVoiceView


+ (instancetype)voiceView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];

}

- (MPMoviePlayerViewController *)player {

    if (!_player) {
        _player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.topic.voiceuri]];
    }
    return _player;
}

/** 播放音频 */
- (IBAction)playVioice {
    
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.player animated:YES completion:nil];
}


/** 显示图片 */
- (void)showPicture {
    
    QJDShowPictureViewController *vc = [[QJDShowPictureViewController alloc] init];
    
    vc.topic = self.topic;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setTopic:(QJDTopic *)topic {

    _topic = topic;
  
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage]];
    
    // 播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld次播放", topic.playfcount];
    
    // 播放时长
    NSInteger mintue = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", mintue, second];
}
@end
