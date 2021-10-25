//
//  PostHeaderView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/28.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "PostHeaderView.h"

@implementation PostHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.postedTextView = [self XMTextViewWithFrame:FRAME(0, 0, SCREEN_WIDTH, 125) superView:self fontSize:14 textColor:TITLE_BLACK backgroundColor:COLOR(clearColor) placeholder:@"分享精彩，菜鸡陪你玩~" placeholderColor:PLACEHOLDER_COLOR borderLineColor:COLOR(clearColor)];
    self.postedTextView.tintColor = RGBOF(0x76dae9);
    self.postedTextView.maxNumColor = RGBOF(0xb7b7b7);
    self.postedTextView.maxNumFont = FONT(11);
    WEAKSELF
    self.postedTextView.textViewListening = ^(NSString *textViewStr) {
        if (weakSelf.editContentBlock) {
            weakSelf.editContentBlock(textViewStr);
        }
    };
}

/**
 自定义控件XMTextView
 */
- (XMTextView *)XMTextViewWithFrame:(CGRect)frame superView:(UIView *)superView fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor borderLineColor:(UIColor *)borderLineColor{
    
    XMTextView *textView = [[XMTextView alloc] initWithFrame:frame];
    [superView addSubview:textView];
    
    textView.textFont = [UIFont systemFontOfSize:fontSize];
    textView.textColor = textColor;
    
    textView.backgroundColor = backgroundColor;
    textView.textView.backgroundColor = backgroundColor;
    
    textView.placeholder = placeholder;
    textView.placeholderColor = placeholderColor;
    
    textView.borderLineColor = borderLineColor;
    
    return textView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
