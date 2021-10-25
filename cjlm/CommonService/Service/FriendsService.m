//
//  FriendsService.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/27.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "FriendsService.h"

@implementation FriendsService

+ (void)listOfPeopleFollowedByMeWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/allUserFollow",REQUEST_PATH];
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

+ (void)searchUserWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/searchUser",REQUEST_PATH];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"get" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)followWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addUserFollow",REQUEST_PATH];
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

+ (void)unfollowWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/delUserFollow",REQUEST_PATH];
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
