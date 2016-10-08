//
//  MainViewController.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/8.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "MainViewController.h"
#import "MSYOrderManagerViewController.h"
#import "UIView+XZExtension.h"
#define XZColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XZColor(r, g, b) XZColorA((r), (g), (b), 255)
#define XZRandomColor XZColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface MainViewController ()<UIScrollViewDelegate>
/** 当前选中的标题按钮 */
@property (nonatomic, weak) UIButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildViewControllers];
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];
    
    
}

- (void)setupChildViewControllers
{
    
    MSYOrderManagerViewController *all = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:all];
    
  
    MSYOrderManagerViewController *pendingOrders = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:pendingOrders];
    
    MSYOrderManagerViewController *payment = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:payment];
    
    MSYOrderManagerViewController *underway = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:underway];
    
    MSYOrderManagerViewController *determined = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:determined];
    
    
    MSYOrderManagerViewController *determined1 = [[MSYOrderManagerViewController alloc] init];
    
    [self addChildViewController:determined1];
    
    
}

 
- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.xz_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}



- (void)setupTitlesView
{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    titlesView.frame = CGRectMake(0, 64, self.view.xz_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
 
 
    // 添加标题
    NSArray *titles = @[@"全部", @"待付款", @"进行中", @"待评价", @"已完成",@"退款"];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.xz_width / count;
    CGFloat titleButtonH = titlesView.xz_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        // self.selected = YES;
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        titleButton.titleLabel.font =  [UIFont systemFontOfSize:14];

     }
    
    // 按钮的选中颜色
    UIButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.xz_height = 1;
    indicatorView.xz_y = titlesView.xz_height - indicatorView.xz_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.xz_width = firstTitleButton.titleLabel.xz_width;
    indicatorView.xz_centerX = firstTitleButton.xz_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
}

#pragma mark - 监听点击
- (void)titleClick:(UIButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.xz_width = titleButton.titleLabel.xz_width;
        self.indicatorView.xz_centerX = titleButton.xz_centerX;
    }];
    
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.xz_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.xz_width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.xz_width;
    UIButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}


@end
