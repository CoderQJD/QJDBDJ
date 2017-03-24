//
//  QJDADViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/22.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDADViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "QJDTaBarController.h"

@interface QJDADViewController ()<UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** tabBarC */
@property (nonatomic, strong) QJDTaBarController *tarbBarController;
@end

@implementation QJDADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tarbBarController = [[QJDTaBarController alloc] init];
    
    self.tarbBarController.delegate = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"demo"] = @(3);
    params[@"entrytype"] = @(1);
    
    [[AFHTTPSessionManager manager] GET:@"http://sprite.spriteapp.com/ad/get.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        [self.imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x.png"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {

    static NSInteger i = 10;
    
    [self.jumpButton setTitle:[NSString stringWithFormat:@"跳过(%zd)", i] forState:UIControlStateNormal];
    
    if (i == 0) {
        
        [self.timer invalidate];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = self.tarbBarController;
    }
    
    NSLog(@"%zd",i);
    
    i--;
    
}

- (IBAction)jumpClick {
    
    [self.timer invalidate];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[QJDTaBarController alloc] init];
}

- (BOOL)prefersStatusBarHidden {

    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QJDTabBarDidSelectNotification object:nil userInfo:nil];
}
@end
