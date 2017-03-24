//
//  QJDTopic.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QJDComment;
@interface QJDTopic : NSObject

/** 名称 */
@property (nonatomic, strong) NSString *name;
/** 头像URL */
@property (nonatomic, strong) NSString *profile_image;
/** 文字内容 */
@property (nonatomic, strong) NSString *text;
/** 发帖时间 */
@property (nonatomic, strong) NSString *create_time;
/** 顶的人数 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的人数 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的人数 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的人数 */
@property (nonatomic, assign) NSInteger comment;
/** 新浪加V */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图片的URL */
@property (nonatomic, strong) NSString *smallImage;
/** 中等图片的URL */
@property (nonatomic, strong) NSString *middleImage;
/** 大图片的URL */
@property (nonatomic, strong) NSString *largeImage;
/** 帖子类型 */
@property (nonatomic, assign) QJDTopicType type;
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 播放次数 */
@property (nonatomic, assign) NSInteger playfcount;
/** 最热评论 */
@property (nonatomic, strong) QJDComment *top_cmt;
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频url */
@property (nonatomic, copy) NSString *voiceuri;
/** 视频url */
@property (nonatomic, copy) NSString *videouri;



/*********** 辅助属性 **************/

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 图片帖子中间内容的frame */
@property (nonatomic, assign, readonly) CGRect pictureFrame;
/** 图片是否太大 */
@property (nonatomic, assign, getter=isBigPicture) BOOL BigPicture;
/** 图片加载的进度条 */
@property (nonatomic, assign) CGFloat pictureProgress;
/** 声音帖子中间内容的frame */
@property (nonatomic, assign, readonly) CGRect voiceFrame;
/** 视频帖子中间内容的frame */
@property (nonatomic, assign, readonly) CGRect videoFrame;

@end
