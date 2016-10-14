//
//  XZScrollBarViewController.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/10.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZScrollBarViewController.h"
#import "XZScrollBarButton.h"
#import "XZScrollBarViewHeader.h"
#import "XZFlowLayout.h"
static NSString *const CollectionViewCellID = @"CollectionViewCellID";

@interface XZScrollBarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

// 初始化参数
@property (nonatomic, assign) BOOL isInitial;

/** 标题滚动视图 */
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIScrollView *titleScrollView;

/** 内容滚动视图 */
@property (nonatomic, weak) UICollectionView *contentScrollView;


@property(nonatomic,strong)UIColor *titleScrollViewColor;


@property(nonatomic,strong)UIColor *normalColor;
@property(nonatomic,strong)UIColor *selectColor;
@property(nonatomic,strong)UIFont *titleFont;


@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat titleHeight;
/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;


@property(nonatomic,strong)NSMutableArray *titleBtnArray;
@property(nonatomic,strong)NSMutableArray *titleBtnWidthArray;


/** 当前选中的标题按钮 */
@property (nonatomic, weak) UIButton *selectedTitleButton;


/** 计算上一次选中角标 */
//@property (nonatomic, assign) NSInteger selIndex;

@property (nonatomic, assign) XZTitleColorGradientStyle titleColorGradientStyle;

@end





@implementation XZScrollBarViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self initVc];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initVc];
}

- (void)initVc{
    _titleHeight = XZTitleViewH;
     self.automaticallyAdjustsScrollViewInsets = NO;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isInitial == NO) {
        if (self.childViewControllers.count == 0) return;
        
        if (_titleWidth == 0) {
            
            [self calculateTitleWidth];
        
        }
        
        [self setUpAllTitle];
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_isInitial == NO) {
        
        self.selectIndex = self.selectIndex;
        
        _isInitial = YES;
        
        
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        
        CGFloat titleViewY = self.navigationController.navigationBarHidden ?statusHeight:XZNavBarH;
        
        if (_isfullScreen) {
            
            self.contentView.frame = CGRectMake(0, 0, XZScreenW, XZScreenH);
            
            self.titleScrollView.frame = CGRectMake(0, 0, XZScreenW, self.titleHeight);
            
            self.contentScrollView.frame = self.contentView.bounds;
            
            return;
        }
        
            if (self.contentView.xz_height == 0) {
                self.contentView.frame = CGRectMake(0, titleViewY, XZScreenW, XZScreenH - titleViewY);
            }
            
            
            self.titleScrollView.frame = CGRectMake(0, 0, XZScreenW, self.titleHeight);
            
            // 顶部内容尺寸
            
            CGFloat contentY = CGRectGetMaxY(self.titleScrollView.frame);
            CGFloat contentH  = self.contentView.xz_height - self.titleScrollView.xz_height;
            
            self.contentScrollView.frame = CGRectMake(0, contentY, XZScreenW, contentH);
            
            
        
        
        
        
        
    }
    
    
    
}


- (void)setUpAllTitle{
    // 设置全部的标题
    
    NSInteger count = self.childViewControllers.count;
    
    CGFloat titleBtnW = _titleWidth;
    CGFloat titleBtnH = self.titleHeight;
    CGFloat titleBtnX = 0;
    CGFloat titleBtnY = 0;

    
    
    for (int i = 0 ; i < count; i ++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        XZScrollBarButton *titleBtn = [[XZScrollBarButton alloc] init];
        
        titleBtn.tag = i;
        
        [titleBtn setTitleColor:self.normalColor forState:UIControlStateNormal];
        
        titleBtn.titleLabel.font = self.titleFont;
        
        
        [titleBtn setTitle:vc.title forState:UIControlStateNormal];
//        titleBtn.titleLabel.text = vc.title;
        
        
        
   
        if (_titleWidth == 0) {
            
            titleBtnW = [self.titleBtnWidthArray[i] floatValue];
            
            
            UIButton *lastBtn = [self.titleBtnArray lastObject];
            
            titleBtnX = _titleMargin + CGRectGetMaxX(lastBtn.frame);
            
            
        }else{
        
            titleBtnX = i * titleBtnW;
        
        }
        titleBtn.frame = CGRectMake(titleBtnX, titleBtnY, titleBtnW, titleBtnH);
        
        
        NSLogRect(titleBtn)
        
        
        
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleBtnArray addObject:titleBtn];
        
        [self.titleScrollView addSubview:titleBtn];
        
        if (i == _selectIndex) {
            [self titleBtnClick:titleBtn];
        }
        
    }
    
  
    
    
    UIButton *firstTitleBtn = self.titleScrollView.subviews[0];
    firstTitleBtn.selected = YES;
    self.selectedTitleButton = firstTitleBtn;
    
    // 设置滚动的范围
    UIButton *lastBtn = self.titleBtnArray.lastObject;
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame), 0);
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(count * XZScreenW, 0);
    
    
    
}

- (void)calculateTitleWidth{
    
    // 判断
    NSInteger count = self.childViewControllers.count;
    
    NSArray *titles = [self.childViewControllers valueForKey:@"title"];
    
    CGFloat totalWidth = 0;
    

    @try {
        
        for (NSString *title  in titles) {
            
            CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.titleFont} context:nil];
            
            CGFloat width = titleBounds.size.width;
            
            [self.titleBtnWidthArray addObject:@(width)];
            
            totalWidth += width;
        }
        
        if (totalWidth > XZScreenW) {
            
            _titleMargin = XZTitleMargin;
            
            self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
            
            return;
        }
        
        
        CGFloat titleMargin = (XZScreenW - totalWidth)/ (count + 1);
        
        _titleMargin = titleMargin < XZTitleMargin? XZTitleMargin:titleMargin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
        
    } @finally {
        
        
    }

    
    
    
}



// btn的点击事件
- (void)titleBtnClick:(UIButton *)btn{
    
    self.selectedTitleButton.selected = NO;
    btn.selected = YES;
    self.selectedTitleButton = btn;
    
    
    [self dealSelectBtn:btn];
    
    NSInteger i =  btn.tag;
    
    
    
    CGFloat ofsetX = i * XZScreenW;

    
    self.contentScrollView.contentOffset = CGPointMake(ofsetX, 0);
    
    
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view) {
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:XZScrollBarClickBtnTitleOrScrollDidFinishNoti  object:vc];
        
        // 发出重复点击标题通知
//        if (_selIndex == i) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:YZDisplayViewRepeatClickTitleNote object:vc];
//        }
    }
 
//    if ([vc isViewLoaded]) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:XZScrollBarClickBtnTitleOrScrollDidFinishNoti object:vc];
//        
//        
//        
//        
//    }
    
    
    
    
    
}


- (void)dealSelectBtn:(UIButton *)btn{
    
    [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectColor  forState:UIControlStateSelected];
    
    [self setBtnTitleLabelCenter:btn];
}



- (void)setBtnTitleLabelCenter:(UIButton *)btn{
    
    // 设置偏移量
    CGFloat offsetX = btn.center.x - XZScreenW *0.5;
    
    if (offsetX == 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width
    
    
    
}

- (UIColor *)normalColor{
    if (_normalColor == nil) {
        
        _normalColor = [UIColor blackColor];
    }
    return  _normalColor;
 
  
}

- (UIFont *)titleFont{
    if (_titleFont == nil) {
        _titleFont = XZTitleFont;
    }
    return _titleFont;
}

- (NSMutableArray *)titleBtnArray{
    if (_titleBtnArray == nil) {
        _titleBtnArray = [NSMutableArray array];
    }
    return _titleBtnArray;
}

- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        UIScrollView   *titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.scrollsToTop = NO;
        titleScrollView.backgroundColor =_titleScrollViewColor?_titleScrollViewColor:[UIColor colorWithWhite:1 alpha:0.8];
        _titleScrollView = titleScrollView;
    
        [self.contentView addSubview:_titleScrollView];

    }
    return _titleScrollView;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] init];
        _contentView = view;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}
- (NSMutableArray *)titleBtnWidthArray
{
    if (_titleBtnWidthArray == nil) {
        _titleBtnWidthArray = [NSMutableArray array];
    }
    return _titleBtnWidthArray;
}

- (UICollectionView *)contentScrollView
{
    if (_contentScrollView == nil) {
        
        XZFlowLayout *layout = [[XZFlowLayout alloc]init];
        UICollectionView *contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _contentScrollView = contentScrollView;
        
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource  = self;
        _contentScrollView.scrollsToTop = NO;
        
        [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellID];
        _contentScrollView.backgroundColor = self.view.backgroundColor;
        
        [self.contentView insertSubview:_contentScrollView belowSubview:self.titleScrollView];
        
    }
    
    return _contentScrollView;
}


#pragma mark -collectionVcDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    
    
//    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    // 取得控制器
    UIViewController *childVc = self.childViewControllers[indexPath.row];
    childVc.view.frame = CGRectMake(0, 0, self.contentScrollView.xz_width, self.contentScrollView.xz_height);
    
    
    CGFloat top = _isfullScreen?CGRectGetMaxY(self.titleScrollView.frame):0;

    CGFloat bottom = self.tabBarController == nil?0:self.tabBarController.view.xz_height;
    
    
    
    if ([childVc isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tableVc =(UITableViewController *)childVc;
        tableVc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        
    }
    [cell.contentView addSubview:childVc.view];
    
    
    
    return cell;
    
    
    
}


// 监听滚动动画是否完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    _isAniming = NO;
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    // 点击和动画的时候不需要设置
//    if (_isAniming || self.titleLabels.count == 0) return;
//    
//    // 获取偏移量
//    CGFloat offsetX = scrollView.contentOffset.x;
//    
//    // 获取左边角标
//    NSInteger leftIndex = offsetX / YZScreenW;
//    
//    // 左边按钮
//    YZDisplayTitleLabel *leftLabel = self.titleLabels[leftIndex];
//    
//    // 右边角标
//    NSInteger rightIndex = leftIndex + 1;
//    
//    // 右边按钮
//    YZDisplayTitleLabel *rightLabel = nil;
//    
//    if (rightIndex < self.titleLabels.count) {
//        rightLabel = self.titleLabels[rightIndex];
//    }
//    
//    // 字体放大
//    [self setUpTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//    
//    // 设置下标偏移
//    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
//        
//        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//    }
//    
//    // 设置遮盖偏移
//    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//    
//    // 设置标题渐变
//    [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//    
//    // 记录上一次的偏移量
//    _lastOffsetX = offsetX;
}



- (void)setUpTitleBtnEffect:(void(^)(UIColor **titleScrollViewCorlor,UIColor **titleNormalCorlor,UIColor **titleSelectCorlor,UIFont **titleFont,CGFloat **titleWidth,CGFloat **titleHeight))titleEffectBlock{
  
    UIColor *titleScrollViewCorlor;
    UIColor *titleNormalCorlor;
    UIColor *titleSelectCorlor;
    UIFont *titleFont;
    CGFloat *titleWidth;
    CGFloat *titleHeight;
    
    
    if (titleEffectBlock) {
        
        titleEffectBlock(&titleScrollViewCorlor,&titleNormalCorlor,&titleSelectCorlor,&titleFont,&titleWidth,&titleHeight);
        
        if (titleScrollViewCorlor) {
            _titleScrollView.backgroundColor = titleScrollViewCorlor;
        }
        
        if (titleNormalCorlor) {
            self.normalColor = titleNormalCorlor;
        }
        if (titleSelectCorlor) {
            self.selectColor = titleSelectCorlor;
        }
        
        _titleFont = titleFont;
        
        
    }
    

    
}



@end
