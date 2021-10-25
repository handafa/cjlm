//
//  KeyboardView.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/20.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EwenTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardView : UIView

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,strong)EwenTextView *ewenTextView;

@end

NS_ASSUME_NONNULL_END
