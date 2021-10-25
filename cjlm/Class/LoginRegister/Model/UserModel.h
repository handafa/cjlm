//
//  UserModel.h
//  Ruijin
//
//  Created by apple on 2018/11/6.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject<NSSecureCoding>

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
