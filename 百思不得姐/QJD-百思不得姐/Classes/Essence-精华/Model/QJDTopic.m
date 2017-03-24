//
//  QJDTopic.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDTopic.h"
#import <MJExtension.h>
#import "QJDComment.h"
#import "QJDCommentUser.h"

@implementation QJDTopic {

    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{
             @"smallImage" : @"image0",
             @"middleImage": @"image2",
             @"largeImage" : @"image1",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}


//+ (NSDictionary *)mj_objectClassInArray {
//
//    return @{@"top_cmt" : @"QJDComment"};
//}
/*
 今年
    今天
        1分中内
            刚刚
        1小时内
            xx分钟前
        其他
            xx小时前
    昨天
        昨天 09:21:56
    其他
        01-21 12:53:28
 
 非今年
    2015-09-20 16:20:35
 */
- (NSString *)create_time {

    // 时间格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间格式化
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *createTime = [fmt dateFromString:_create_time];
    
    if ([createTime isThisYear]) { // 今年
        
        if ([createTime isThisToday]) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:createTime];
            
            if (cmps.hour > 1) { // 大于1小时
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            
            } else if(cmps.minute > 1){ // 1小时>(1小时内)>1分钟
               return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            
            } else { // 1分钟内
                return @"刚刚";
            }
            
        } else if([createTime isThisYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createTime];
            
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createTime];
        }
        
    } else { // 不是今年
        return _create_time;
    }
}

/**
 计算cell的高度
 */
- (CGFloat)cellHeight {

    /*
     cell的高度 = textY + textH + margin + bottomH + margin
     */
    
    if (!_cellHeight) {
        
        // 最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * QJDTopicCellMargin, MAXFLOAT);
        // 文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _cellHeight = QJDTopicCellTextY + textH + QJDTopicCellMargin;
        
        if (self.type == QJDTopicTypePicture) { // 图片
            
            // 图片的宽度
            CGFloat pictureW = maxSize.width;
            // 图片的高度
            CGFloat pictureH = self.height * pictureW / self.width;
            if (pictureH >= QJDTopicCellPictureMaxH) {
                self.BigPicture = YES;
                pictureH = QJDTopicCellPictureBreakH;
            }
            CGFloat pictureX = QJDTopicCellMargin;
            CGFloat pictureY = QJDTopicCellTextY + textH + QJDTopicCellMargin;
            
            _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + QJDTopicCellMargin;
        
        } else if (self.type == QJDTopicTypeVoice) { // 声音
        
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = self.height * voiceW / self.width;
            CGFloat voiceX = QJDTopicCellMargin;
            CGFloat voiceY = QJDTopicCellTextY + textH + QJDTopicCellMargin;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + QJDTopicCellMargin;
            
        } else if (self.type == QJDTopicTypeVideo) { // 视频
            
            CGFloat videoW = maxSize.width;
            CGFloat videoH = self.height * videoW / self.width;
            CGFloat videoX = QJDTopicCellMargin;
            CGFloat videoY = QJDTopicCellTextY + textH + QJDTopicCellMargin;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + QJDTopicCellMargin;
        }
        
        // 最热评论
        // 最热评论标题H + 评论内容H + margin
        if (self.top_cmt) {
            CGFloat contentH = [[NSString stringWithFormat:@"%@ : %@", self.top_cmt.commentUser.username, self.top_cmt.content] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height;
            _cellHeight += 20 + contentH + QJDTopicCellMargin;
        }
        
        // 底部工具条 + cell高度缩进
        _cellHeight += QJDTopicCellBottomToolH + QJDTopicCellMargin;
    }
    return _cellHeight;
}
@end
