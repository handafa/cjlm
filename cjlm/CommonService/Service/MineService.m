//
//  MineService.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/28.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "MineService.h"

@implementation MineService

+ (void)personalHomepageWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/userLastestThread",REQUEST_PATH];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"get" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)viewOtherPeopleHomepageDataWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/otherUserLastestThread",REQUEST_PATH];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"get" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)feedbackWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addFeedBack",REQUEST_PATH];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

@end
