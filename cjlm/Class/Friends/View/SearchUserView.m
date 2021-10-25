//
//  SearchUserView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/20.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "SearchUserView.h"

@implementation SearchUserView

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(SCREEN_WIDTH, 44);
}

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
    _searchTextField = [HELPER textFieldWithSuperView:self textAlignment:NSTextAlignmentLeft fontSize:14 textColor:TITLE_BLACK backgroundColor:RGBOF(0xf2f4f5) placeholder:@"搜索用户" placeholderColor:PLACEHOLDER_COLOR placeholderFont:14 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@35);
        make.centerY.equalTo(self);
        make.right.equalTo(@-5);
        make.left.equalTo(@0);
    }];
    _searchTextField.layer.cornerRadius = 35/2;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 35, 35)];
    [HELPER imageViewWithSuperView:self backgroundColor:COLOR(clearColor) image:IMG(@"icon_search_gray") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@0);
    }];
    _searchTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
