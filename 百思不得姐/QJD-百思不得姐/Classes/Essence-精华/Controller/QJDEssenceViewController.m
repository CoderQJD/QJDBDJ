//
//  QJDEssenceViewController.m
//  QJD-百思不得姐
//
//  Created by 姚叶 on 2017/3/6.
//  Copyright © 2017年 qjd. All rights reserved.
//

#import "QJDEssenceViewController.h"
#import "QJDRecommendTagController.h"
#import "QJDTopicViewController.h"

@interface QJDEssenceViewController () <UIScrollViewDelegate>
/** 顶部标签栏的底部红色指示器 */
@property (nonatomic, weak) UIView *indicator;
/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation QJDEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏
    [self setupNavBar];
    
    // 初始化自控制器
    [self setupChildVces];
    
    // 设置顶部标签栏
    [self setupTitlesView];
    
    // 设置底部ScrollView
    [self setupContentView];
}

- (void)setupChildVces {
    
    QJDTopicViewController *all = [[QJDTopicViewController alloc] init];
    all.title = @"全部";
    all.type = QJDTopicTypeAll;
    [self addChildViewController:all];
    
    QJDTopicViewController *video = [[QJDTopicViewController alloc] init];
    video.title = @"视频";
    video.type = QJDTopicTypeVideo;
    [self addChildViewController:video];
    
    QJDTopicViewController *voice = [[QJDTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = QJDTopicTypeVoice;
    [self addChildViewController:voice];
    
    QJDTopicViewController *picture = [[QJDTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = QJDTopicTypePicture;
    [self addChildViewController:picture];

    QJDTopicViewController *word = [[QJDTopicViewController alloc] init];
    word.title = @"段子";
    word.type = QJDTopicTypeWord;
    [self addChildViewController:word];

}

/** 设置导航栏 */
- (void)setupNavBar {
    
    // 背景颜色
    self.view.backgroundColor = QJDGlobalColor;
    
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:@"MainTagSubIcon" lightImageName:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.navigationItem.leftBarButtonItem = item;
}

/** 设置顶部标签栏 */
- (void)setupTitlesView {

    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    titlesView.y = QJDTitlesViewY;
    titlesView.width = self.view.width;
    titlesView.height = QJDTitlesViewH;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 红色指示器
    UIView *indicator = [[UIView alloc] init];
    indicator.backgroundColor = [UIColor redColor];
    indicator.height = 2;
    indicator.y = titlesView.height - indicator.height;
    self.indicator = indicator;
    
    CGFloat btnW = self.view.width / 5;
    CGFloat btnH = titlesView.height;
    CGFloat btnX;
    CGFloat btnY = 0;

    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        btnX = btnW * i;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag = i;
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        // [btn layoutIfNeeded]; // 不好,开始进入有动画
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        
        // 默认点击第一个按钮
        if (i == 0) {
            
            btn.enabled = NO;
            self.selectedButton = btn;
            
            // 让按钮内部label根据文字计算size
            [btn.titleLabel sizeToFit];
            self.indicator.width = btn.titleLabel.width;
            self.indicator.centerX = btn.centerX;
        }
    }
    [titlesView addSubview:indicator];
}

/** 设置底部ScrollView */
- (void)setupContentView {
    
    // 不要系统自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 创建内容视图
    UIScrollView *contenView = [[UIScrollView alloc] init];
    contenView.size = self.view.size;
    [self.view insertSubview:contenView atIndex:0];
    
    contenView.pagingEnabled = YES;
    
    // 内容尺寸
    contenView.contentSize = CGSizeMake(contenView.width * self.childViewControllers.count, 0);
    
    // 设置代理
    contenView.delegate = self;
    
    self.contentView = contenView;
    
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

/** 标题按钮的点击 */
- (void)titleClick:(UIButton *)button {
    
    // button的状态(控制button指示器的颜色)
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;

    // 设置指示器动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicator.width = button.titleLabel.width;
        self.indicator.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = self.contentView.width * button.tag;
    [self.contentView setContentOffset:offset animated:YES];
}

/** 推荐标签按钮点击 */
- (void)tagClick {

    QJDRecommendTagController *vc = [[QJDRecommendTagController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    // 添加子控制器的View
    
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 拿到当前的tableview
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // tableView.y默认是20;height是self.
    vc.view.height = self.view.height;
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮(让指示器跟着移动)
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}


@end
