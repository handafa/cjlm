//
//  TermsConditionsController.h
//  cjlm
//
//  Created by 韦瑀 on 2019/12/3.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ControllerTypeTerms = 0,// 服务条款
    ControllerTypeConditions,// 隐私协议
} ControllerType;

@interface TermsConditionsController : BaseViewController

@property (nonatomic,assign) ControllerType controllerType;

@end

NS_ASSUME_NONNULL_END
