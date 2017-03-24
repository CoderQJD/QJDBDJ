//
//  QJDConst.h
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/14.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 帖子的类型 */
typedef enum {
    QJDTopicTypeAll = 1,
    QJDTopicTypeWord = 29,
    QJDTopicTypePicture = 10,
    QJDTopicTypeVoice = 31,
    QJDTopicTypeVideo = 41,
    
} QJDTopicType;

/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const QJDTitlesViewH;
/** 精华-顶部标题的Y */
UIKIT_EXTERN CGFloat const QJDTitlesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const QJDTopicCellMargin;
/** 精华-cell-文字内容Y值 */
UIKIT_EXTERN CGFloat const QJDTopicCellTextY;
/** 精华-cell-文字底部工具栏高度*/
UIKIT_EXTERN CGFloat const QJDTopicCellBottomToolH;

/** 精华-cell-图片帖子的图片最大高度 */
UIKIT_EXTERN CGFloat const QJDTopicCellPictureMaxH;
/** 精华-cell-图片帖子的图片超出最大高度,就使用BreakH */
UIKIT_EXTERN CGFloat const QJDTopicCellPictureBreakH;

/** XMGCommentUser模型-性别属性值 */
UIKIT_EXTERN NSString * const QJDCmtUserSexMale;
UIKIT_EXTERN NSString * const QJDCmtUserSexFemale;

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const QJDTabBarDidSelectNotification;


