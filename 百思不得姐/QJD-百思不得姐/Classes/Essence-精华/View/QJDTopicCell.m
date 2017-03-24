//
//  QJDTopicCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopicCell.h"
#import "QJDTopic.h"
#import <UIImageView+WebCache.h>
#import "QJDTopicPictureView.h"
#import "QJDTopicVoiceView.h"
#import "QJDTopicVideoView.h"
#import "QJDComment.h"
#import "QJDCommentUser.h"
#import "QJDLoginTool.h"

@interface QJDTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImageView;
/** 文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/** 图片帖子的中间内容 */
@property (nonatomic, weak) QJDTopicPictureView *pictureView;
/** 声音帖子的中间内容 */
@property (nonatomic, weak) QJDTopicVoiceView *voiceView;
/** 视频帖子的中间内容 */
@property (nonatomic, weak) QJDTopicVideoView *videoView;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;

@end

@implementation QJDTopicCell

+ (instancetype)cell {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (QJDTopicPictureView *)pictureView {

    if (!_pictureView) {
        
        QJDTopicPictureView *pic = [QJDTopicPictureView pictureView];
        [self.contentView addSubview:pic];
        _pictureView = pic;
    }
    return _pictureView;
}

- (QJDTopicVoiceView *)voiceView {

    if (!_voiceView) {
        
        QJDTopicVoiceView *voice = [QJDTopicVoiceView voiceView];
        [self.contentView addSubview:voice];
        _voiceView = voice;
    }
    return _voiceView;
}

- (QJDTopicVideoView *)videoView {

    if (!_videoView) {
        QJDTopicVideoView *video = [QJDTopicVideoView videoView];
        [self.contentView addSubview:video];
        _videoView = video;
    }
    return  _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.backgroundView = view;
    
    // 设置圆角
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.clipsToBounds = YES;
}

- (void)setTopic:(QJDTopic *)topic {

    _topic = topic;
    
    // 新浪加V
    self.sinaVImageView.hidden = !topic.isSina_v;
    
    // 设置头像
    [self.profileImageView setHeaderImageWithURLString:topic.profile_image];
    
    // 设置用户名
    self.nameLabel.text = topic.name;
    
    // 设置按钮标题
    [self setButtonTitleWithButton:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setButtonTitleWithButton:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setButtonTitleWithButton:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setButtonTitleWithButton:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置发帖时间
    self.createTimeLabel.text = topic.create_time;
    
    // 文字内容
    self.text_label.text = topic.text;
    
    // 根据帖子类型添加不同控件
    if (topic.type == QJDTopicTypePicture) { // 图片
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
        
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    
    }else if (topic.type == QJDTopicTypeVoice) { // 音频
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
    
    }else if (topic.type == QJDTopicTypeVideo) { // 视频
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
    
    }else { // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    // 最热评论
    if (topic.top_cmt) {
        
        self.topCmtView.hidden = NO;
        
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.commentUser.username, topic.top_cmt.content];
    
    }else {
        self.topCmtView.hidden = YES;
    }
}

/** 按钮设置标题的自定义方法*/
- (void)setButtonTitleWithButton:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)palceholder{

    if (count > 0 && count <= 10000) {
        palceholder = [NSString stringWithFormat:@"%ld", count];
        
    }else if(count >10000){
        palceholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    }
    
    [button setTitle:palceholder forState:UIControlStateNormal];
}

/** cell间距 */
- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = QJDTopicCellMargin;
    frame.size.width -= QJDTopicCellMargin * 2;
    
    frame.origin.y += QJDTopicCellMargin;
    //    frame.size.height -= QJDTopicCellMargin;
    frame.size.height = self.topic.cellHeight - QJDTopicCellMargin;
    
    [super setFrame:frame];
}

- (IBAction)more {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 创建action
    /**
     *  UIAlertActionStyleDefault = 0,
     *  UIAlertActionStyleCancel,
     *  UIAlertActionStyleDestructive
     */
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![QJDLoginTool getUid:YES]) return ;
        QJDLog(@"收藏");
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![QJDLoginTool getUid:YES]) return ;
        QJDLog(@"举报");
    }];
    
    // 添加action
    [vc addAction:cancelAction];
    [vc addAction:action1];
    [vc addAction:action2];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    
    // 方法二
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
//    [sheet showInView:self.window];
}
@end
