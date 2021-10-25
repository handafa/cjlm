//
//  NSString+Extension.h
//  Project
//
//  Created by 韦瑀 on 2019/4/2.
//  Copyright © 2019 韦瑀. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/**
 MD5加密
 @param string 需要加密的字符串
 @return 加密后的字符串
 */
+ (NSString *)MD5EncryptionWithString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
