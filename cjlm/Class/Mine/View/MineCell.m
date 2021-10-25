//
//  MineCell.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

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
    NSArray *titles = @[@"个人主页",@"联系客服",@"意见反馈",@"关于我们",@"退出登录"];
    self.textLabel.text = titles[self.dataIndexPath.row];
    self.textLabel.font = FONT(16);
    self.textLabel.textColor = SUBTITLE_BLACK;
    
    //底部分割线
    [HELPER imageViewWithSuperView:self.contentView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    if (self.dataIndexPath.row != 3) {
        [HELPER imageViewWithSuperView:self.contentView backgroundColor:COLOR(clearColor) image:IMG(@"icon_enter") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.right.equalTo(@(-ScaleX(22)));
            make.centerY.equalTo(self.contentView);
        }];
    }
}

@end
