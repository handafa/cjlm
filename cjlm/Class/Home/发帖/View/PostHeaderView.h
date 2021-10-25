//
//  PostHeaderView.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/28.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostHeaderView : UIView

@property (nonatomic,copy) void(^editContentBlock)(NSString *publishContent);// 编辑发布内容

@property (nonatomic,strong) XMTextView *postedTextView;

@end

NS_ASSUME_NONNULL_END
