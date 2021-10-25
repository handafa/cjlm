//
//  UIButton+Extension.h
//  Project
//
//  Created by 韦瑀 on 2019/4/1.
//  Copyright © 2019 韦瑀. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

/** 按钮倒计时 */
- (void)countDownWithTime:(NSInteger)totalTime normalTitle:(NSString *)normalTitle countDownTitle:(NSString *)subTitle normalBGColor:(UIColor *)normalBGColor countDownBGColor:(UIColor *)countDownBGColor;


/** 按钮默认样式下（图片在左，文字在右）调整图片和标题的间隔 */
- (void)imagePositionDefaultWithSpacing:(CGFloat)spacing;

/** 设置按钮中图片在右，标题在左，并调整图片和标题的间隔 */
- (void)imagePositionRightWithSpacing:(CGFloat)spacing;

/** 设置按钮中图片在上，标题在下，并调整图片和标题的间隔 */
- (void)imagePositionTopWithSpacing:(CGFloat)spacing;

/** 设置按钮中图片在下，标题在上，并调整图片和标题的间隔 */
- (void)imagePositionBottomWithSpacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
