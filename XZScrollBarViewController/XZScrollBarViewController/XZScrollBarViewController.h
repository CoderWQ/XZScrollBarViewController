//
//  XZScrollBarViewController.h
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/10.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    XZTitleColorGradientStyleRGB,// 正常模式
    XZTitleColorGradientStyleFill// 填充模式
} XZTitleColorGradientStyle;



@interface XZScrollBarViewController : UIViewController
/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;


@property (nonatomic, assign) BOOL isfullScreen;




- (void)setUpTitleBtnEffect:(void(^)(UIColor **titleScrollViewCorlor,UIColor **titleNormalCorlor,UIColor **titleSelectCorlor,UIFont **titleFont,CGFloat **titleWidth,CGFloat **titleHeight))titleEffectBlock;


@end
