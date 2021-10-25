//
//  UITableView+Extension.m
//  yzw
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 瑀 韦. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)tableViewShowMessage:(NSString *)message forDataCount:(NSUInteger)dataCount
{
    if (dataCount == 0) {
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = RGBOF(0x888888);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        self.backgroundView = messageLabel;
    } else {
        self.backgroundView = nil;
    }
}

- (void)tableViewShowImage:(UIImage *)image withMessage:(NSString *)message withStyle:(NSInteger)style forDataCount:(NSUInteger)dataCount
{
    if (dataCount == 0) {
        if (style == 0) {// 图片在上，文字在下
            UIView *bgView = [HELPER viewWithSuperView:nil backgroundColor:COLOR(clearColor) andMasonryBlock:nil];
            self.backgroundView = bgView;
            
            UIImageView *imageView = [HELPER imageViewWithSuperView:bgView backgroundColor:COLOR(clearColor) image:image andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
                make.top.equalTo(@(ScaleY(180)));
                make.centerX.equalTo(bgView);
            }];
            
            [HELPER labelWithSuperView:bgView backgroundColor:COLOR(clearColor) text:message textAlignment:NSTextAlignmentCenter textColor:RGBOF(0xe4e4e4) fontSize:13 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
                make.top.equalTo(imageView.mas_bottom).offset(25);
                make.centerX.equalTo(bgView);
            }];
        }
    }else{
        self.backgroundView = nil;
    }
}

@end
