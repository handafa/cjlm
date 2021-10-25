//
//  KeyboardView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/20.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyboardView

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
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackground)]];
    
    _ewenTextView = [[EwenTextView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-49, SCREEN_WIDTH, 49)];
    _ewenTextView.popupType = 1;
    [_ewenTextView setPlaceholderText:@"评论"];
    [_ewenTextView.textView becomeFirstResponder];
    [self addSubview:_ewenTextView];
    WEAKSELF
    _ewenTextView.tapBlock = ^{
        [weakSelf tapOnBackground];
    };
}

- (void)tapOnBackground
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
