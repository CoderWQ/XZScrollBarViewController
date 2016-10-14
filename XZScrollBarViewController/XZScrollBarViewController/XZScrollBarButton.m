//
//  XZScrollBarButton.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/10.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZScrollBarButton.h"

@implementation XZScrollBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_fillColor set];
    
    rect.size.width = rect.size.width * _progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}
@end
