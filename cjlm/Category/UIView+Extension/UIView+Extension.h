//
//  UIView+Extension.h
//  cjlm
//
//  Created by 韦瑀 on 2020/1/10.
//  Copyright © 2020 韦瑀. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

@property (assign, nonatomic) CGFloat mj_x;
@property (assign, nonatomic) CGFloat mj_y;
@property (assign, nonatomic) CGFloat mj_w;
@property (assign, nonatomic) CGFloat mj_h;
@property (assign, nonatomic) CGSize mj_size;
@property (assign, nonatomic) CGPoint mj_origin;

@property (assign, nonatomic) CGFloat mj_centerX;
@property (assign, nonatomic) CGFloat mj_centerY;

@property (nonatomic) CGFloat mj_right;
@property (nonatomic) CGFloat mj_bottom;

- (UIViewController *)mj_superViewController;

@end

NS_ASSUME_NONNULL_END
