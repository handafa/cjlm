//
//  FriendModel.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/27.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendModel : NSObject

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *follow_status;// 0：未关注 1:已关注

@end

NS_ASSUME_NONNULL_END
