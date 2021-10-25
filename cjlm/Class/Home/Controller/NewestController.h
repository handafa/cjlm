//
//  NewestController.h
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    HomeControllerTypeNewest = 0,// 最新
    HomeControllerTypeFocus,// 关注
}HomeControllerType;

@interface NewestController : BaseViewController

@property (nonatomic,assign) HomeControllerType homeVCType;

@end

NS_ASSUME_NONNULL_END
