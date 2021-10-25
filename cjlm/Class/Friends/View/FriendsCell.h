//
//  FriendsCell.h
//  Project
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCell : BaseTableViewCell

@property (nonatomic,copy) void(^unfollowBlock)(FriendModel *model);// 取消关注

@property (nonatomic,copy) void(^followBlock)(FriendModel *model);// 关注

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIButton *btnUnfollow;

@property (nonatomic,strong) UIButton *btnFollow;

@end

NS_ASSUME_NONNULL_END
