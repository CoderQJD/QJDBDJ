//
//  QJDShowPictureViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/16.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDShowPictureViewController.h"
#import "QJDTopic.h"
#import <UIImageView+WebCache.h>
#import <FLAnimatedImageView.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h>
#import "QJDProgressView.h"

@interface QJDShowPictureViewController ()
/** 滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;
/** 图片 */
@property (nonatomic, weak) FLAnimatedImageView *imageView;
/** 进度条 */
@property (weak, nonatomic) IBOutlet QJDProgressView *progressView;

@end

@implementation QJDShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建图片
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.pictureScrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片的宽高
    CGFloat pictureW = QJDScreenW;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    
    if (pictureH > QJDScreenH) { // 大图(图片显示的高度大于屏幕高度)
        
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.pictureScrollView.contentSize = CGSizeMake(0, pictureH);
        
    } else { // 小图
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = QJDScreenH * 0.5;
    }
    
    // 让进读条显示当前的进度
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    
    // 设置图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        self.progressView.hidden = NO;
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.progressView.hidden = YES;
        
    }];
}
- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePicture {
    
    // 将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    // 方法二:
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        
//        // 将图片写入相册
//        PHAssetChangeRequest *reqt = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
//        
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        
//        NSLog(@"success == %d, error == %@", success ,error);
//    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
}

@end
