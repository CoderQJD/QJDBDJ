//
//  QJDLoginTool.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/21.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDLoginTool.h"
#import "QJDLoginRegistViewController.h"

@implementation QJDLoginTool

+ (void)setUid:(NSString *)uid {

    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUid {

    return [self getUid:NO];
}

+ (NSString *)getUid:(BOOL)showLoginContrller {

    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    if (showLoginContrller) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            QJDLoginRegistViewController *vc = [[QJDLoginRegistViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        });
    }
    
    return uid;
}

@end
