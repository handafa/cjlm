//
//  SearchUserView.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/20.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchUserView : UIView <UITextFieldDelegate>

@property (nonatomic,copy) void(^searchBlock)(NSString *text);

@property (nonatomic,strong) UITextField *searchTextField;

@end

NS_ASSUME_NONNULL_END
