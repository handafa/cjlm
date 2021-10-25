//
//  RequestTool.m
//  Ruijin
//
//  Created by apple on 2018/11/6.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool

+ (instancetype)sharedTool
{
    static RequestTool* requestTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTool == nil) {
            requestTool = [[RequestTool alloc] init];
        }
    });
    return requestTool;
}


/**
 普通请求
 
 @param urlString    请求地址
 @param parameter    请求参数
 @param method       请求方法：get 或 post
 @param successBlock 成功回调
 @param failBlock    失败回调
 */
- (void)requestWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter method:(NSString *)method successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是JSON类型
    if ([method isEqualToString:@"get"]) {
        [manager GET:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject, task);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock(error, task);
        }];
    }else if ([method isEqualToString:@"post"]) {
        [manager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject, task);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock(error, task);
        }];
    }
}


/**
 带有头参数的请求
 
 @param urlString       请求地址
 @param headParameters  头参数
 @param parameter       请求参数
 @param method          请求方法：get 或 post
 @param successBlock    成功回调
 @param failBlock       失败回调
 */
- (void)requestWithUrlString:(NSString *)urlString forHTTPHeader:(NSDictionary *)headParameters requestParameter:(NSDictionary *)parameter method:(NSString *)method successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是JSON类型
    if (headParameters.allKeys.count > 0) {
        for (NSString *key in headParameters.allKeys) {
            [manager.requestSerializer setValue:[headParameters objectForKey:key] forHTTPHeaderField:key];
        }
    }
    if ([method isEqualToString:@"get"]) {
        [manager GET:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject, task);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock(error, task);
        }];
    }else if ([method isEqualToString:@"post"]) {
        [manager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject, task);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock(error, task);
        }];
    }
}


/**
 单文件上传
 
 @param urlString      请求地址
 @param parameter      非文件参数
 @param data           文件参数 (二进制数据)
 @param specifiedName  和后台定好的文件名
 @param successBlock   成功回调
 @param failBlock      失败回调
 */
-(void)uploadSingleFileWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter data:(NSData *)data specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd-hh:mm:ss";
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",string];
        [formData appendPartWithFileData:data name:specifiedName fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject, task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error, task);
    }];
}


/**
 多文件上传
 
 @param urlString       请求地址
 @param parameter       非文件参数
 @param filesArray      存放要上传的文件的数组
 @param specifiedName   和后台定好的文件名
 @param successBlock    成功回调
 @param failBlock       失败回调
 */
-(void)uploadMultipleFilesWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter filesArray:(NSMutableArray *)filesArray specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < filesArray.count; i++) {
            UIImage *image = filesArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd-hh:mm:ss";
            NSString *string = [dateFormatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png",string];
            [formData appendPartWithFileData:imageData name:specifiedName fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject, task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error, task);
    }];
}


/**
 视频上传
 
 @param urlString      请求地址
 @param parameter      非文件参数
 @param data           文件参数 (二进制数据)
 @param videoFileName  需自己生成的视频文件名称
 @param specifiedName  和后台定好的文件名
 @param successBlock   成功回调
 @param failBlock      失败回调
 */
- (void)uploadVideoWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter data:(NSData *)data videoFileName:(NSString *)videoFileName specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:specifiedName fileName:videoFileName mimeType:@"video/mpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject, task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error, task);
    }];
}


@end
