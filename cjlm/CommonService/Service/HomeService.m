//
//  HomeService.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "HomeService.h"

@implementation HomeService

+ (void)postingWithParam:(NSMutableDictionary *)param contentText:(NSString *)content fileArray:(NSArray *)fileArray success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    [HELPER loadingHUD:@"" toView:WINDOW];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HELPER endLoadingToView:WINDOW];
        [HELPER showInfoHUDWithMessage:@"发布成功，内容正在审核中。"];
    });
}

+ (void)latestDataOnHomepageWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/lastestThread",REQUEST_PATH];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
        [param setObject:@"0" forKey:@"isLogin"];
    }else{
        [param setObject:@"1" forKey:@"isLogin"];
        [param setObject:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid] forKey:@"uid"];
        [param setObject:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].token] forKey:@"authToken"];
    }
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"get" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)homepageAttentionListWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/userFollowLastestThread",REQUEST_PATH];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == YES) {
        [param setObject:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid] forKey:@"uid"];
        [param setObject:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].token] forKey:@"authToken"];
    }
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"get" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)giveALikeWithParam:(NSDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addVote",REQUEST_PATH];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)cancelThumbUpWithParam:(NSDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/delVote",REQUEST_PATH];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)remarkWithParam:(NSDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addPostComment",REQUEST_PATH];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)deleteCommentWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/delPostComment",REQUEST_PATH];
    [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [[RequestTool sharedTool] requestWithUrlString:urlStr requestParameter:param method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        success(successResult, responseCode);
    } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
        NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
        fail(failResult, responseCode);
    }];
}

+ (void)reportWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addReport",REQUEST_PATH];
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

+ (void)allCommentsOnThePostWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/allThreadPostComment",REQUEST_PATH];
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

+ (void)blockUserPostsWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addBlackThread",REQUEST_PATH];
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

+ (void)shieldingUsersWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/addBlackUser",REQUEST_PATH];
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

+ (void)unblockedUserWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/delBlackUser",REQUEST_PATH];
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

+ (void)deleteThePostWithParam:(NSMutableDictionary *)param success:(void (^)(id _Nonnull, NSInteger))success fail:(void (^)(NSError * _Nonnull, NSInteger))fail
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HELPER endLoadingToView:WINDOW];
        [HELPER showInfoHUDWithMessage:@"删除失败。"];
    });
}


@end
