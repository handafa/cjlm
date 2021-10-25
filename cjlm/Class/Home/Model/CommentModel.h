//
//  CommentModel.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/28.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

@property (nonatomic,copy) NSString *cid;

@property (nonatomic,copy) NSString *message_fmt;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *pid;

@property (nonatomic,copy) NSString *tid;

@property (nonatomic,copy) NSString *create_date;

@end

NS_ASSUME_NONNULL_END
