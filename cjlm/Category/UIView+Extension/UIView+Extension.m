//
//  UIView+Extension.m
//  cjlm
//
//  Created by 韦瑀 on 2020/1/10.
//  Copyright © 2020 韦瑀. All rights reserved.
//

#import "UIView+Extension.h"


@implementation UIView (Extension)

- (void)setMj_x:(CGFloat)mj_x
{
    CGRect frame = self.frame;
    frame.origin.x = mj_x;
    self.frame = frame;
}

- (CGFloat)mj_x
{
    return self.frame.origin.x;
}


- (void)setMj_y:(CGFloat)mj_y
{
    CGRect frame = self.frame;
    frame.origin.y = mj_y;
    self.frame = frame;
}

- (CGFloat)mj_y
{
    return self.frame.origin.y;
}


- (void)setMj_w:(CGFloat)mj_w
{
    CGRect frame = self.frame;
    frame.size.width = mj_w;
    self.frame = frame;
}

- (CGFloat)mj_w
{
    return self.frame.size.width;
}


- (void)setMj_h:(CGFloat)mj_h
{
    CGRect frame = self.frame;
    frame.size.height = mj_h;
    self.frame = frame;
}

- (CGFloat)mj_h
{
    return self.frame.size.height;
}


- (void)setMj_size:(CGSize)mj_size
{
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}

- (CGSize)mj_size
{
    return self.frame.size;
}


- (void)setMj_origin:(CGPoint)mj_origin
{
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)mj_origin
{
    return self.frame.origin;
}


- (void)setMj_centerX:(CGFloat)mj_centerX{
    
    CGPoint center = self.center;
    center.x = mj_centerX;
    self.center = center;
}

- (CGFloat)mj_centerX{
    return self.center.x;
}


- (void)setMj_centerY:(CGFloat)mj_centerY{
    CGPoint center = self.center;
    center.y = mj_centerY;
    self.center = center;
}

- (CGFloat)mj_centerY{
    return self.center.y;
}


- (void)setMj_right:(CGFloat)mj_right
{
    CGRect frame = self.frame;
    frame.origin.x = mj_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mj_right
{
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setMj_bottom:(CGFloat)mj_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = mj_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mj_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}


- (UIViewController *)mj_superViewController
{
    UIViewController *vc = [[UIViewController alloc]init];
    for (UIView *next = [self superview]; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            vc = (UIViewController*)nextResponder;
            break;
        }
    }
    return vc;
}

@end
