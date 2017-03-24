//
//  QJDWebViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/20.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDWebViewController.h"
#import <NJKWebViewProgress.h>

@interface QJDWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

/** 进度值的代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;

@end

@implementation QJDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QJDGlobalColor;
    
    self.progress = [[NJKWebViewProgress alloc] init];
    
    self.webView.delegate = self.progress;
    
    __weak typeof(self) weakSelf = self;
    
    self.progress.progressBlock = ^(float progress) {
    
        weakSelf.progressView.progress = progress;
        
        weakSelf.progressView.hidden = progress == 1.0;
    };
    
    self.progress.webViewProxyDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)goBack:(id)sender {
    
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
