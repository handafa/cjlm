//
//  AllCommentsCell.m
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AllCommentsCell.h"

@implementation AllCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellAddData
{
    CommentModel *model = self.arrayComment[self.dataIndexPath.row];
    
    //头像
    UIImageView *avatar = [HELPER imageViewWithSuperView:self.contentView backgroundColor:COLOR(clearColor) image:IMG(@"avatar_default_logined") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@(ScaleX(12)));
        make.top.equalTo(@12);
    }];
    [self.contentView layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:avatar withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(20, 20) borderWidth:0 borderColor:COLOR(clearColor)];
//    [avatar sd_setImageWithURL:[NSURL URLWithString:@"https://xinlikj.oss-cn-shanghai.aliyuncs.com/youni/logo1564637889577.jpg"]];//赋值
    avatar.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPersonalHomepage)]];
    
    //昵称
    UILabel *lblNickName = [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:model.nickname textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:14 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.top.equalTo(avatar.mas_top).offset(5);
        make.left.equalTo(avatar.mas_right).offset(ScaleX(12));
    }];
    
    //发布时间
    NSString *pubdate = [HELPER timestampConversion:10 timestamp:model.create_date];
    if ([[[HELPER getCurrentDateString] componentsSeparatedByString:@" "][0] isEqualToString:[pubdate componentsSeparatedByString:@" "][0]]) {//当天时间
        pubdate = [pubdate componentsSeparatedByString:@" "][1];
    }else{
        pubdate = [pubdate componentsSeparatedByString:@" "][0];
    }
    [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:pubdate textAlignment:NSTextAlignmentRight textColor:RGBOF(0x9e9e9e) fontSize:12 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(lblNickName.mas_centerY);
        make.right.equalTo(@(-ScaleX(13)));
    }];
    
    //评论内容
    [self.contentView layoutIfNeeded];
    UILabel *lblComment = [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:model.message_fmt textAlignment:NSTextAlignmentLeft textColor:SUBTITLE_BLACK fontSize:14 numberOfLines:0 andMasonryBlock:nil];
    lblComment.frame = FRAME(lblNickName.mj_x, lblNickName.mj_bottom+13, SCREEN_WIDTH - lblNickName.mj_x - ScaleX(18), 0);
    [lblComment sizeToFit];
    
    [HELPER imageViewWithSuperView:self.contentView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
        make.left.equalTo(lblNickName.mas_left);
    }];
}

#pragma mark - 点击头像跳转到个人主页
- (void)jumpToPersonalHomepage
{
    CommentModel *model = self.arrayComment[self.dataIndexPath.row];
    if (self.jumpToPersonalHomepageBlock) {
        self.jumpToPersonalHomepageBlock(model);
    }
}

@end
