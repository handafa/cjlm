//
//  LoginRegisterService.h
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRegisterService : NSObject

/**
 登录
 */
+ (void)loginWithParam:(NSDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;

/**
 获取验证码
 */
+ (void)getVerificationCodeWithParam:(NSDictionary *)param success:(void(^)(id returnData, NSInteger responseCode))success fail:(void(^)(NSError *error, NSInteger responseCode))fail;


@end

NS_ASSUME_NONNULL_END
