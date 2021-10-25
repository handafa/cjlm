//
//  PersonalHomeHeaderView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/21.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "PersonalHomeHeaderView.h"

@implementation PersonalHomeHeaderView

#pragma mark - setter
- (void)setID:(NSString *)ID
{
    _ID = ID;
    
    if ([[NSString stringWithFormat:@"%@",ID] isEqualToString:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid]] == NO) {// 别人的主页
        _nicknameLabel.text = self.nicknameString;
    }else{// 自己的主页
        _nicknameLabel.text = [HELPER obtainUserInfo].nickname;
    }
}

- (void)setFollow_count:(NSString *)follow_count
{
    _follow_count = follow_count;
    
    _labelFollowNumber.text = [NSString stringWithFormat:@"关注 %@",follow_count];
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
    //背景
    _bgImageView = [HELPER imageViewWithSuperView:self backgroundColor:COLOR(clearColor) image:IMG(@"mine_personal_bg") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self);
    }];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
//    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://qzonestyle.gtimg.cn/qzone/app/weishi/client/testimage/1024/1.jpg"]];
    
    //头像
    _avatar = [HELPER imageViewWithSuperView:self backgroundColor:COLOR(clearColor) image:IMG(@"avatar_default_logined") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(self);
        make.bottom.equalTo(@(-ScaleY(73)));
    }];
    [self layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:_avatar withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(30, 30) borderWidth:0 borderColor:COLOR(clearColor)];
//    [_avatar sd_setImageWithURL:[NSURL URLWithString:@"https://xinlikj.oss-cn-shanghai.aliyuncs.com/youni/logo1564637889577.jpg"]];//赋值
    
    //昵称
    _nicknameLabel = [HELPER labelWithSuperView:self backgroundColor:COLOR(clearColor) text:nil textAlignment:NSTextAlignmentCenter textColor:RGBOF(0xfefefe) fontSize:17 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(ScaleY(13));
        make.centerX.equalTo(self);
    }];
    
    //关注数
    _labelFollowNumber = [HELPER labelWithSuperView:self backgroundColor:COLOR(clearColor) text:[NSString stringWithFormat:@"关注 %@",self.follow_count ? self.follow_count : @""] textAlignment:NSTextAlignmentCenter textColor:RGBOF(0xfefefe) fontSize:13 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.bottom.equalTo(@(-ScaleY(15)));
        make.centerX.equalTo(self);
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
