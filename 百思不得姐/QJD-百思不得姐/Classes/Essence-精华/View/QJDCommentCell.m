//
//  QJDCommentCell.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/18.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDCommentCell.h"
#import "QJDComment.h"
#import <UIImageView+WebCache.h>
#import "QJDCommentUser.h"

@interface QJDCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceCmtButton;

@end
@implementation QJDCommentCell

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // 设置背景图片
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.backgroundView = view;
    
    // 设置圆角
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.clipsToBounds = YES;
}

- (void)setComment:(QJDComment *)comment {

    _comment = comment;

    // 设置头像
    [self.profileImageView setHeaderImageWithURLString:comment.commentUser.profile_image];
    
    self.sexImageView.image = [comment.commentUser.sex isEqualToString:QJDCmtUserSexMale]? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    
    self.usernameLabel.text = comment.commentUser.username;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    self.contentLabel.text = comment.content;
    
    // 根据有无音频评论显示是文字评论还是音频评论
    if (comment.voiceuri.length) {
        self.voiceCmtButton.hidden = NO;
        [self.voiceCmtButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    }else {
        self.voiceCmtButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame {

    frame.origin.x = QJDTopicCellMargin;
    frame.size.width -= 2 * QJDTopicCellMargin;
    [super setFrame:frame];
}

@end
