//
//  AllCommentsCell.h
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllCommentsCell : BaseTableViewCell

@property (nonatomic,copy) void(^jumpToPersonalHomepageBlock)(CommentModel *model);// 点击头像和昵称跳转到个人主页

@property (nonatomic,strong) NSMutableArray *arrayComment;

@end

NS_ASSUME_NONNULL_END
