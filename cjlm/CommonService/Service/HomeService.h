//
//  HomeService.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeService : NSObject

/**
 发帖
 */
+ (void)postingWithParam:(NSMutableDictionary *)param contentText:(NSString *)content fileArray:(NSArray *)fileArray success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 首页最新数据列表
 */
+ (void)latestDataOnHomepageWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 首页关注列表
 */
+ (void)homepageAttentionListWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 点赞
 */
+ (void)giveALikeWithParam:(NSDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 取消点赞
 */
+ (void)cancelThumbUpWithParam:(NSDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 评论
 */
+ (void)remarkWithParam:(NSDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 删除评论
 */
+ (void)deleteCommentWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 举报
 */
+ (void)reportWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 帖子的所有的评论
 */
+ (void)allCommentsOnThePostWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 屏蔽用户的发帖
 */
+ (void)blockUserPostsWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 屏蔽用户
 */
+ (void)shieldingUsersWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 取消屏蔽用户
 */
+ (void)unblockedUserWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 删除发帖
 */
+ (void)deleteThePostWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

@end

NS_ASSUME_NONNULL_END
