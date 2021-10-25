//
//  MineTableHeaderView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "MineTableHeaderView.h"

@implementation MineTableHeaderView

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
    //背景
    _bgImageView = [HELPER imageViewWithSuperView:self backgroundColor:COLOR(clearColor) image:IMG(@"mine_bg") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self);
    }];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
//    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://qzonestyle.gtimg.cn/qzone/app/weishi/client/testimage/1024/1.jpg"]];
    
    //昵称
    _lblNickName = [HELPER labelWithSuperView:self backgroundColor:COLOR(clearColor) text:[HELPER obtainUserInfo].nickname textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:0 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.top.equalTo(@(STATUS_BAR_HEIGHT + 20));
        make.left.equalTo(@(ScaleX(20)));
        make.width.equalTo(@(SCREEN_WIDTH - ScaleX(55) - 75));
    }];
    _lblNickName.font = [UIFont boldSystemFontOfSize:26];
    
    //头像
    _avatar = [HELPER imageViewWithSuperView:self backgroundColor:COLOR(clearColor) image:IMG(@"avatar_default_logined") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.right.equalTo(@(-ScaleX(20)));
        make.top.equalTo(@(STATUS_BAR_HEIGHT + 25));
    }];
    [self layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:self.avatar withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(75/2, 75/2) borderWidth:0 borderColor:nil];
    
    //底部分割线
    [HELPER imageViewWithSuperView:self backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
