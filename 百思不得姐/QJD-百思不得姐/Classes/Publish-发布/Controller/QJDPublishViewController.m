//
//  QJDPublishViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/16.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDPublishViewController.h"
#import "QJDVerticalButton.h"
#import <POP.h>
#import "QJDPostWordViewController.h"
#import "QJDNavigationController.h"
#import "QJDLoginTool.h"

static CGFloat const QJDAnimationDelay = 0.1;
static CGFloat const QJDSpringFactor = 10;

@interface QJDPublishViewController ()

@end

@implementation QJDPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    
    // 数据
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审批", @"离线下载"];
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    
    // 添加中间6个button
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartX = 30;
    CGFloat buttonStartY = (QJDScreenH - buttonH * 2) * 0.5;
    CGFloat xMargin = (QJDScreenW - (buttonStartX * 2 + buttonW * maxCols)) / (maxCols - 1);
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        // 创建button
        QJDVerticalButton *button = [QJDVerticalButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 计算X/Y
        NSInteger row = i / maxCols;
        NSInteger col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (buttonW + xMargin);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonStartY = buttonEndY - QJDScreenH;
        
        // 添加按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonStartY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = QJDSpringFactor;
        anim.springSpeed = QJDSpringFactor;
        anim.beginTime = CACurrentMediaTime() + QJDAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    // 计算起始中心点
    CGFloat endCenterY = QJDScreenH * 0.2;
    CGFloat startCenterY = endCenterY - QJDScreenH;
    CGFloat centerX = QJDScreenW * 0.5;
    sloganView.center = CGPointMake(endCenterY, startCenterY);
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, startCenterY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, endCenterY)];
    anim.springBounciness = QJDSpringFactor;
    anim.springSpeed = QJDSpringFactor;
    anim.beginTime = CACurrentMediaTime() +  QJDAnimationDelay * images.count;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 恢复事件点击
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    
}

/** 动画完毕后, 让控制器dismiss, 再回调block */
- (void)canceledWithAnimationCompletion:(void (^)())completionBlock {

    for (NSInteger i = 2; i < self.view.subviews.count; i++) {
        
        UIView *subview = self.view.subviews[i];
        
        // 退出动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, subview.centerY + QJDScreenH)];
        anim.beginTime = CACurrentMediaTime() + QJDAnimationDelay * (i - 2);
        [subview pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画的完成
        if (i == self.view.subviews.count - 1) {
            
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                // completionBlock? completionBlock() : nil;
//                if (completionBlock) {
//                    completionBlock();
//                }
                !completionBlock? : completionBlock();
            }];
        }
    }
}

- (void)buttonClick:(UIButton *)button {

    [self canceledWithAnimationCompletion:^{
        
        if (button.tag == 2) {
            
            if (![QJDLoginTool getUid:YES]) return ;
            
            QJDPostWordViewController *vc = [[QJDPostWordViewController alloc] init];
            
            QJDNavigationController *nav = [[QJDNavigationController alloc] initWithRootViewController:vc];
            
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            [root presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (IBAction)cancel {
    
    [self canceledWithAnimationCompletion:nil];
}


@end
