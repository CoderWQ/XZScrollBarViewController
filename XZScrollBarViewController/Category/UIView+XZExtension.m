//
//  UIView+XZExtension.m
//  XZScrollBarViewController
//
//  Created by coderXu on 16/10/8.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "UIView+XZExtension.h"

@implementation UIView (XZExtension)


- (CGSize)xz_size
{
    return self.frame.size;
}

- (void)setXz_size:(CGSize)xz_size
{
    CGRect frame = self.frame;
    frame.size = xz_size;
    self.frame = frame;
}

- (CGFloat)xz_width
{
    return self.frame.size.width;
}

- (CGFloat)xz_height
{
    return self.frame.size.height;
}

- (void)setXz_width:(CGFloat)xz_width
{
    CGRect frame = self.frame;
    frame.size.width = xz_width;
    self.frame = frame;
}

- (void)setXz_height:(CGFloat)xz_height
{
    CGRect frame = self.frame;
    frame.size.height = xz_height;
    self.frame = frame;

}

//- (void)setxz_height:(CGFloat)xz_height
//{
//    CGRect frame = self.frame;
//    frame.size.height = xz_height;
//    self.frame = frame;
//}

- (CGFloat)xz_x
{
    return self.frame.origin.x;
}

- (void)setXz_x:(CGFloat)xz_x
{
    CGRect frame = self.frame;
    frame.origin.x = xz_x;
    self.frame = frame;
}

- (CGFloat)xz_y
{
    return self.frame.origin.y;
}

- (void)setXz_y:(CGFloat)xz_y
{
    CGRect frame = self.frame;
    frame.origin.y = xz_y;
    self.frame = frame;
}

- (CGFloat)xz_centerX
{
    return self.center.x;
}

- (void)setXz_centerX:(CGFloat)xz_centerX
{
    CGPoint center = self.center;
    center.x = xz_centerX;
    self.center = center;
}

- (CGFloat)xz_centerY
{
    return self.center.y;
}

- (void)setXz_centerY:(CGFloat)xz_centerY
{
    CGPoint center = self.center;
    center.y = xz_centerY;
    self.center = center;
}

- (CGFloat)xz_right
{
     return CGRectGetMaxX(self.frame);
}

- (CGFloat)xz_bottom
{
     return CGRectGetMaxY(self.frame);
}

- (void)setXz_right:(CGFloat)xz_right
{
    self.xz_x = xz_right - self.xz_width;
}

- (void)setXz_bottom:(CGFloat)xz_bottom
{
    self.xz_y = xz_bottom - self.xz_height;
}



- (CGFloat)xz_left {
    return self.frame.origin.x;
}

- (void)setXz_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)xz_top {
    return self.frame.origin.y;
}

- (void)setXz_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
@end
