//
//  QJDLoginRegistViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/19.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDLoginRegistViewController.h"

@interface QJDLoginRegistViewController()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@end

@implementation QJDLoginRegistViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginOrRegister:(UIButton *)btn {
    
    if (self.leftMargin.constant == 0) { // 注册页面
        
        self.leftMargin.constant = - self.view.width;
        [btn setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else { // 登录页面
        self.leftMargin.constant = 0;
        [btn setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 设置当前控制器状态栏为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

@end
