//
//  XZScrollBarViewHeader.h
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/10.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#ifndef XZScrollBarViewHeader_h
#define XZScrollBarViewHeader_h



#define XZTitleFont [UIFont systemFontOfSize:15];

#define XZScreenW [UIScreen mainScreen].bounds.size.width
#define XZScreenH [UIScreen mainScreen].bounds.size.height



// 标题被点击，内容滚动完成----可以做加载数据的操作
static NSString * const XZScrollBarClickBtnTitleOrScrollDidFinishNoti = @"XZScrollBarClickBtnTitleOrScrollDidFinishNoti";
// 重复点击的操作
static NSString * const XZScrollBarRepeatClickTitleBtnNoti = @"XZScrollBarRepeatClickTitleBtnNoti";

// 导航条高度
static CGFloat const XZNavBarH = 64;

static CGFloat const XZTitleViewH = 35;

static CGFloat const XZTitleMargin = 20;


#endif /* XZScrollBarViewHeader_h */
