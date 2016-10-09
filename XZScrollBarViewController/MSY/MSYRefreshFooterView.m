//
//  MSYRefreshFooterView.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/9.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "MSYRefreshFooterView.h"

@implementation MSYRefreshFooterView

-(void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = XZRandomColor;
    
    [self addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    
////     刷新控件出现一半就会进入刷新状态
//        self.triggerAutomaticallyRefreshPercent = 0.5;
//    
////     不要自动刷新
//        self.automaticallyRefresh = NO;
//    
    
}

@end
