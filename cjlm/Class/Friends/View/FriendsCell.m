//
//  FriendsCell.m
//  Project
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellAddData
{
    FriendModel *model = self.dataSource[self.dataIndexPath.row];
    
    //头像
    UIImageView *avatar = [HELPER imageViewWithSuperView:self.contentView backgroundColor:COLOR(clearColor) image:IMG(@"avatar_default_logined") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(@(ScaleX(15)));
        make.centerY.equalTo(self.contentView);
    }];
    [self.contentView layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:avatar withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(35/2, 35/2) borderWidth:0 borderColor:COLOR(clearColor)];
//    [avatar sd_setImageWithURL:[NSURL URLWithString:@"https://xinlikj.oss-cn-shanghai.aliyuncs.com/youni/logo1564637889577.jpg"]];//赋值
    
    //昵称
    [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:model.nickname textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:15 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(avatar.mas_right).offset(ScaleX(12));
    }];
    
    // 取消关注btn
    _btnUnfollow = [HELPER buttonWithSuperView:self.contentView andNormalTitle:@"取消关注" andNormalTextColor:RGBOF(0xababac) andTextFont:12 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(unfollow) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(75, 30));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(@-13);
    }];
    [self.contentView layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:_btnUnfollow withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(15, 15) borderWidth:0.8 borderColor:RGBOF(0xceced9)];
    _btnUnfollow.hidden = YES;
    
    // 关注按钮
    _btnFollow = [HELPER buttonWithSuperView:self.contentView andNormalTitle:@"关注" andNormalTextColor:RGBOF(0xff8272) andTextFont:12 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(75, 30));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(@-13);
    }];
    [self.contentView layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:_btnFollow withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(15, 15) borderWidth:1 borderColor:RGBOF(0xff8272)];
    _btnFollow.hidden = YES;
    if ([[NSString stringWithFormat:@"%@",model.follow_status] isEqualToString:@"0"]) {// 未关注状态
        _btnFollow.hidden = NO;
        _btnUnfollow.hidden = YES;
    }else if ([[NSString stringWithFormat:@"%@",model.follow_status] isEqualToString:@"1"]) {// 已关注状态
        _btnFollow.hidden = YES;
        _btnUnfollow.hidden = NO;
    }
    // 当前搜索出来的是自己，自己不能关注自己
    if ([[NSString stringWithFormat:@"%@",model.uid] isEqualToString:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid]]) {
        _btnFollow.hidden = YES;
        _btnUnfollow.hidden = YES;
    }
    
    //底部分割线
    [HELPER imageViewWithSuperView:self.contentView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}

#pragma mark - 取消关注
- (void)unfollow
{
    FriendModel *model = self.dataSource[self.dataIndexPath.row];
    if (self.unfollowBlock) {
        self.unfollowBlock(model);
    }
}

#pragma mark - 关注
- (void)follow
{
    FriendModel *model = self.dataSource[self.dataIndexPath.row];
    if (self.followBlock) {
        self.followBlock(model);
    }
}

@end
