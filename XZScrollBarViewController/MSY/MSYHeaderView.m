//
//  MSYHeaderView.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/8.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "MSYHeaderView.h"
#import "UIView+XZExtension.h"
@interface MSYHeaderView()


@end

@implementation MSYHeaderView

// 重写初始化
- (void)prepare
{
    [super prepare];
    self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    self.stateLabel.textColor = [UIColor redColor];
    
    [self setTitle:@"赶紧下拉吧" forState:MJRefreshStateIdle];
    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];

    [self addSubview:[[UISwitch alloc] init]];
    
 
    
}



@end
