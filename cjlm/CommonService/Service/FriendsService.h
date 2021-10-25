//
//  FriendsService.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/27.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsService : NSObject

/**
 我的关注人列表
 */
+ (void)listOfPeopleFollowedByMeWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 搜索用户
 */
+ (void)searchUserWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 关注
 */
+ (void)followWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 取消关注
 */
+ (void)unfollowWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

@end

NS_ASSUME_NONNULL_END
