//
//  QJDPostWordViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/20.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDPostWordViewController.h"
#import "QJDPlaceholderTextView.h"
#import "QJDTagToolBar.h"

@interface QJDPostWordViewController () <UIScrollViewDelegate>
/** 占位文字控件 */
@property (nonatomic, weak) QJDPlaceholderTextView *textView;
/** 标签工具栏 */
@property (nonatomic, weak) QJDTagToolBar *tagToolBar;
@end

@implementation QJDPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏
    [self setupNav];
    
    // 设置占位文字控件
    [self setupTextView];
    
    // 设置标签工具栏
    [self setupTagToolBar];
}

/** 设置导航栏 */
- (void)setupNav {

    self.navigationItem.title = @"发表文字";
    
    self.view.backgroundColor = QJDGlobalColor;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postClick)];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

/** 设置占位文字控件 */
- (void)setupTextView {

    QJDPlaceholderTextView *textView = [[QJDPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.delegate = (id)self;
    [self.view addSubview:textView];
    self.textView = textView;
}

/** 设置标签工具栏 */
- (void)setupTagToolBar {

    QJDTagToolBar *tagToolBar = [QJDTagToolBar tagToolBar];
    tagToolBar.width = self.view.width;
    tagToolBar.y = QJDScreenH - tagToolBar.height;
    [self.view addSubview:tagToolBar];
    self.tagToolBar = tagToolBar;
    
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/** 监听键盘通知 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {

    // 键盘最终显示的frame
    CGRect keyBoardF =  [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
      
        self.tagToolBar.transform = CGAffineTransformMakeTranslation(0, keyBoardF.origin.y - QJDScreenH);
    }];
}

- (void)cancleClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postClick {

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.view endEditing:YES];
}

@end
