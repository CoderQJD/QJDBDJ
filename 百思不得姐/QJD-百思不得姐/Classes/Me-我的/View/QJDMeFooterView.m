//
//  QJDMeFooterView.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/20.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDMeFooterView.h"
#import "QJDSquareButton.h"
#import "QJDSquare.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "QJDWebViewController.h"

@implementation QJDMeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSArray *sqaures = [QJDSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            // 创建方块
            [self createSquares:sqaures];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)sqaures {
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = QJDScreenW / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<sqaures.count; i++) {
        // 创建按钮
        QJDSquareButton *button = [QJDSquareButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.square = sqaures[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
        //self.height = CGRectGetMaxY(button.frame);
    }
    // 总行数
    //    NSUInteger rows = sqaures.count / maxCols;
    //    if (sqaures.count % maxCols) { // 不能整除, + 1
    //        rows++;
    //    }
    
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;
    
    // 计算footer的高度
    self.height = rows * buttonH;
    
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(QJDSquareButton *)button {
   
    if (![button.square.url hasPrefix:@"http"]) return;
    
    QJDWebViewController *webVc = [[QJDWebViewController alloc] init];
    webVc.url = button.square.url;
    webVc.title = button.titleLabel.text;
    
    UITabBarController *tabBarC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *navC = tabBarC.selectedViewController;
    [navC pushViewController:webVc animated:YES];
}

// 设置背景图片
//- (void)drawRect:(CGRect)rect {
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

@end
