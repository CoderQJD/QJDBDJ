//
//  QJDComment.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/17.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QJDCommentUser;

@interface QJDComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频评论的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) QJDCommentUser *commentUser;
@end
