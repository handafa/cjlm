//
//  UserModel.m
//  Ruijin
//
//  Created by apple on 2018/11/6.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
 
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_mobile forKey:@"phone"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_username forKey:@"username"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.token =  [aDecoder decodeObjectForKey:@"token"];
        self.mobile = [aDecoder decodeObjectForKey:@"phone"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
    }
    
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}


@end
