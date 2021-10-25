//
//  NewestModel.h
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewestModel : NSObject

@property (nonatomic,copy) NSString *nickname; 

@property (nonatomic,copy) NSString *message_fmt; //帖子内容

@property (nonatomic,copy) NSArray *file_url; //图片地址数组

@property (nonatomic,copy) NSArray *comment; //用户评论数组

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *create_date;// 发布时间

@property (nonatomic,copy) NSString *pid; //帖子内容id

@property (nonatomic,copy) NSString *tid; //主题id

@property (nonatomic,copy) NSString *vote_status; //点赞状态 0:未点赞 1:已点赞

@property (nonatomic,copy) NSString *votes;

@property (nonatomic,assign) BOOL isFullTextShown;//是否展开全文

@end

NS_ASSUME_NONNULL_END
