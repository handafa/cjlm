//
//  MineService.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/28.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineService : NSObject

/**
 个人主页
 */
+ (void)personalHomepageWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 查看别人主页数据
 */
+ (void)viewOtherPeopleHomepageDataWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 意见反馈
 */
+ (void)feedbackWithParam:(NSMutableDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

@end

NS_ASSUME_NONNULL_END
