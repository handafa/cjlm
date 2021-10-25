//
//  UIButton+Extension.m
//  Project
//
//  Created by 韦瑀 on 2019/4/1.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

/** 按钮倒计时 */
- (void)countDownWithTime:(NSInteger)totalTime normalTitle:(NSString *)normalTitle countDownTitle:(NSString *)subTitle normalBGColor:(UIColor *)normalBGColor countDownBGColor:(UIColor *)countDownBGColor
{
    __weak typeof(self) weakSelf = self;
    __block NSInteger timeOut = totalTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setBackgroundColor:normalBGColor];
                [weakSelf setTitle:normalTitle forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)totalTime + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setBackgroundColor:countDownBGColor];
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


/** 按钮默认样式下（图片在左，文字在右）调整图片和标题的间隔 */
- (void)imagePositionDefaultWithSpacing:(CGFloat)spacing
{
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, - 0.5 * spacing, 0, 0.5 * spacing);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * spacing, 0, - 0.5 * spacing);
    }
}

/** 设置按钮中图片在右，标题在左，并调整图片和标题的间隔 */
- (void)imagePositionRightWithSpacing:(CGFloat)spacing
{
    CGFloat imageW = self.imageView.image.size.width;
    CGFloat titleW = self.titleLabel.frame.size.width;
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + spacing, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, 0, 0);
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageW + spacing);
    } else {
        CGFloat imageOffset = titleW + 0.5 * spacing;
        CGFloat titleOffset = imageW + 0.5 * spacing;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, - imageOffset);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
    }
}

/** 设置按钮中图片在上，标题在下，并调整图片和标题的间隔 */
- (void)imagePositionTopWithSpacing:(CGFloat)spacing
{
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
    self.imageEdgeInsets = UIEdgeInsetsMake(- titleIntrinsicContentSizeH - spacing, 0, 0, - titleIntrinsicContentSizeW);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, - imageH - spacing, 0);
}

/** 设置按钮中图片在下，标题在上，并调整图片和标题的间隔 */
- (void)imagePositionBottomWithSpacing:(CGFloat)spacing
{
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
    self.imageEdgeInsets = UIEdgeInsetsMake(titleIntrinsicContentSizeH + spacing, 0, 0, - titleIntrinsicContentSizeW);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, imageH + spacing, 0);
}


@end
