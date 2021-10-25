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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (fileArray.count > 0) {// 有图片时
        [manager.requestSerializer setValue:@"Content-Type" forHTTPHeaderField:@"multipart/form-data"];
        // 上传图片参数拼接
        NSMutableDictionary *dictFileInfo = [NSMutableDictionary dictionary];
        [param setObject:dictFileInfo forKey:@"fileInfo"];
        
        NSMutableArray *imageDatas = [NSMutableArray array]; // 图片data数组
        dispatch_group_t group = dispatch_group_create();
        for (HXPhotoModel *photoModel in fileArray) {
            dispatch_group_enter(group);
            if (photoModel.subType == HXPhotoModelMediaSubTypePhoto) {
                [photoModel requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                    NSData *imageData = [HELPER imageCompression:image withMaxLength:5*1024.f*1024.f];
                    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:0];
                    [imageDatas addObject:[NSString stringWithFormat:@"第%ld张%@",(long)model.selectedIndex+1,encodedImageStr]];
                    
                    //拼接图片宽高参数
                    NSMutableDictionary *dictFile = [NSMutableDictionary dictionary];
                    [dictFile setObject:[NSString stringWithFormat:@"%f",image.size.width*2] forKey:@"width"];
                    [dictFile setObject:[NSString stringWithFormat:@"%f",image.size.height*2] forKey:@"height"];
                    [dictFileInfo setObject:dictFile forKey:[NSString stringWithFormat:@"file%ld",(long)(model.selectedIndex+1)]];
                    
                    dispatch_group_leave(group);
                } failed:^(NSDictionary *info, HXPhotoModel *model) {
                    dispatch_group_leave(group);
                }];
            }
        }
        
        // 获取图片名字
        NSMutableArray *imageNameArray = [NSMutableArray array];// 图片名字数组
        for (HXPhotoModel *photoModel in fileArray) {
            if (photoModel.subType == HXPhotoModelMediaSubTypePhoto) {
                if (photoModel.asset) {
                    dispatch_group_enter(group);
                    [photoModel requestImageURLStartRequestICloud:^(PHContentEditingInputRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                        
                    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                        
                    } success:^(NSURL * _Nullable imageURL, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        LOG(@"🐷imageURL==%@",model.imageURL);
                        
                        NSString *imageName = [model.imageURL.absoluteString componentsSeparatedByString:@"/"].lastObject;
                        NSRange range = [imageName rangeOfString:@"."];
                        imageName = [imageName substringToIndex:range.location];
                        imageName = [NSString stringWithFormat:@"%@.png",imageName];
                        [imageNameArray addObject:[NSString stringWithFormat:@"第%ld张%@",(long)model.selectedIndex+1,imageName]];
                        
                        dispatch_group_leave(group);
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        dispatch_group_leave(group);
                    }];
                }
            }
        }
        
        // 开始上传图片
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:param];
            
            //字典转JSON字符串
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param[@"fileInfo"] options:0 error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [param setObject:jsonStr forKey:@"fileInfo"];
            
            [manager POST:[NSString stringWithFormat:@"%@v1/uploadFileOss",REQUEST_PATH] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (int i = 0; i < [tempDict[@"fileInfo"] allKeys].count; i++) {
                    // 根据图片排号顺序重新排序图片名称
                    NSString *newImageName;
                    for (NSString *imageName in imageNameArray) {
                        if ([[(NSString *)[tempDict[@"fileInfo"] allKeys][i] substringFromIndex:4] isEqualToString:[imageName substringWithRange:NSMakeRange(1, 1)]]) {
                            newImageName = [imageName substringFromIndex:3];
                        }
                    }
                    
                    // 根据图片排号顺序重新排序图片data
                    NSData *newImageData;
                    for (NSString *encodedImageStr in imageDatas) {
                        if ([[(NSString *)[tempDict[@"fileInfo"] allKeys][i] substringFromIndex:4] isEqualToString:[encodedImageStr substringWithRange:NSMakeRange(1, 1)]]) {
                            NSString *newEncodedStr;
                            newEncodedStr = [encodedImageStr substringFromIndex:3];
                            newImageData = [[NSData alloc] initWithBase64EncodedString:newEncodedStr options:0];
                        }
                    }
        
                    [formData appendPartWithFileData:newImageData name:[tempDict[@"fileInfo"] allKeys][i] fileName:newImageName mimeType:@"image/png"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                LOG(@"🐷%@",responseObject);
                
                NSArray *imageUrls = responseObject[@"data"][@"dataInfo"][0][@"fileUrl"]; // 获取到返回的图片地址
                NSMutableDictionary *fileUrl = [NSMutableDictionary dictionary];
                for (NSInteger i = 0; i < imageUrls.count; i ++) {
                    NSDictionary *dict = imageUrls[i];
                    
                    NSMutableDictionary *dictFile = [NSMutableDictionary dictionary];
                    [dictFile setObject:dict[@"fileRealUrl"] forKey:@"fileRealUrl"];
                    [dictFile setObject:STRING(dict[@"fileSize"]) forKey:@"fileSize"];
                    [dictFile setObject:dict[@"fileType"] forKey:@"fileType"];
                    [dictFile setObject:[NSString stringWithFormat:@"file%ld",(long)(i+1)] forKey:@"fileSort"];
                    [dictFile setObject:dict[@"width"] forKey:@"width"];
                    [dictFile setObject:dict[@"height"] forKey:@"height"];
                    [dictFile setObject:dict[@"orgfilename"] forKey:@"orgfilename"];
                    
                    [fileUrl setObject:dictFile forKey:[NSString stringWithFormat:@"file%ld",(long)(i+1)]];
                }
                NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
                [dictData setObject:([HELPER isZeroLengthWithString:content] ? @"" : content) forKey:@"content"];
                [dictData setObject:[NSDictionary dictionaryWithObjectsAndKeys:fileUrl,@"fileUrl", nil] forKey:@"fileData"];
               
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                [mutableDict setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
                [mutableDict setObject:@"addThread" forKey:@"postType"];
                [mutableDict setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
                [mutableDict setObject:@"1" forKey:@"fileExist"];
                [mutableDict setObject:@"image:jpg" forKey:@"fileType"];
                //字典转JSON字符串
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictData.copy options:0 error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [mutableDict setObject:jsonStr forKey:@"data"];
                
                [mutableDict setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
                //是否有内容
                if ([HELPER isZeroLengthWithString:content]) {
                    [mutableDict setObject:@"4" forKey:@"contentType"];// 0:html 1:txt 2:markdown 3:ubb 4:空
                    [mutableDict setObject:@"0" forKey:@"contentExists"];
                }else{
                    [mutableDict setObject:@"1" forKey:@"contentType"];// 0:html 1:txt 2:markdown 3:ubb 4:空
                    [mutableDict setObject:@"1" forKey:@"contentExists"];
                }
                
                [[RequestTool sharedTool] requestWithUrlString:[NSString stringWithFormat:@"%@v1/addThread",REQUEST_PATH] requestParameter:mutableDict.copy method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
                    NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
                    success(successResult, responseCode);
                } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
                    NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
                    fail(failResult, responseCode);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        });
    }else{// 无图片时
        NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
        [dictData setObject:([HELPER isZeroLengthWithString:content] ? @"" : content) forKey:@"content"];
        [dictData setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"fileUrl", nil] forKey:@"fileData"];
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
        [mutableDict setObject:@"addThread" forKey:@"postType"];
        [mutableDict setObject:@"1" forKey:@"contentExists"];
        [mutableDict setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
        [mutableDict setObject:@"0" forKey:@"fileExist"];
        [mutableDict setObject:@"0" forKey:@"fileType"];
        [mutableDict setObject:@"1" forKey:@"contentType"];// 0:html 1:txt 2:markdown 3:ubb 4:空
        //字典转JSON字符串
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictData.copy options:0 error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [mutableDict setObject:jsonStr forKey:@"data"];
        
        [mutableDict setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
        [[RequestTool sharedTool] requestWithUrlString:[NSString stringWithFormat:@"%@v1/addThread",REQUEST_PATH] requestParameter:mutableDict.copy method:@"post" successBlock:^(id successResult, NSURLSessionDataTask *requestTask) {
            NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
            success(successResult, responseCode);
        } failBlock:^(id failResult, NSURLSessionDataTask *requestTask) {
            NSInteger responseCode = [HELPER showResponseCode:requestTask.response];
            fail(failResult, responseCode);
        }];
    }
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
    NSString* urlStr = [NSString stringWithFormat:@"%@v1/delThread",REQUEST_PATH];
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
