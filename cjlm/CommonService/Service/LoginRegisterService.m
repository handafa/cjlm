//
//  LoginRegisterService.m
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "LoginRegisterService.h"

@implementation LoginRegisterService

+ (void)loginWithParam:(NSDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/login",REQUEST_PATH];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)getVerificationCodeWithParam:(NSDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/sendCode",REQUEST_PATH];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}


@end
