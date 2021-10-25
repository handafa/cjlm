//
//  BaseTableViewCell.m
//  Ruijin
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellAddData
{
    
}

@end
