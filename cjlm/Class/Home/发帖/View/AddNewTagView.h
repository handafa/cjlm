//
//  AddNewTagView.h
//  cjlm
//
//  Created by 韦瑀 on 2019/12/23.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddNewTagView : UIView

@property (nonatomic,copy) void(^labelViewHeightChangeBlock)(CGFloat value);// 添加标签后labelView高度的变化block

@property (nonatomic,strong) NSMutableArray *labelArray;// 标签数组

@property (nonatomic,strong) UITextField *labelTextField;

@property (nonatomic,strong) UIView *labelView;

@end

NS_ASSUME_NONNULL_END
