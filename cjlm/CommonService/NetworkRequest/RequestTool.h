//
//  RequestTool.h
//  Ruijin
//
//  Created by apple on 2018/11/6.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccessBlock)(id successResult, NSURLSessionDataTask *requestTask);
typedef void(^RequestFailedBlock)(id failResult, NSURLSessionDataTask *requestTask);

@interface RequestTool : NSObject

+ (instancetype)sharedTool;


/**
 普通请求

 @param urlString    请求地址
 @param parameter    请求参数
 @param method       请求方法：get 或 post
 @param successBlock 成功回调
 @param failBlock    失败回调
 */
-(void)requestWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter method:(NSString *)method successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock;


/**
 带有头参数的请求

 @param urlString       请求地址
 @param headParameters  头参数
 @param parameter       请求参数
 @param method          请求方法：get 或 post
 @param successBlock    成功回调
 @param failBlock       失败回调
 */
-(void)requestWithUrlString:(NSString *)urlString forHTTPHeader:(NSDictionary *)headParameters requestParameter:(NSDictionary *)parameter method:(NSString *)method successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock;


/**
 单文件上传

 @param urlString      请求地址
 @param parameter      非文件参数
 @param data           文件参数 (二进制数据)
 @param specifiedName  和后台定好的文件名
 @param successBlock   成功回调
 @param failBlock      失败回调
 */
-(void)uploadSingleFileWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter data:(NSData *)data specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock: (RequestFailedBlock)failBlock;


/**
 多文件上传

 @param urlString       请求地址
 @param parameter       非文件参数
 @param filesArray      存放要上传的文件的数组
 @param specifiedName   和后台定好的文件名
 @param successBlock    成功回调
 @param failBlock       失败回调
 */
- (void)uploadMultipleFilesWithUrlString:(NSString *)urlString requestParameter: (NSDictionary *)parameter filesArray:(NSMutableArray *)filesArray specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock: (RequestFailedBlock)failBlock;


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
-(void)uploadVideoWithUrlString:(NSString *)urlString requestParameter:(NSDictionary *)parameter data:(NSData *)data videoFileName:(NSString *)videoFileName specifiedName:(NSString *)specifiedName successBlock:(RequestSuccessBlock)successBlock failBlock:(RequestFailedBlock)failBlock;


@end


