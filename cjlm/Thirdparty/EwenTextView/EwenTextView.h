//
//  EwenTextView.h
//  0621TextViewDemo
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MaxTextViewHeight 80 //限制文字输入的高度
@interface EwenTextView : UIView

@property (nonatomic,copy) void(^tapBlock)(void);

//------ 发送文本 -----//
@property (nonatomic,copy) void (^EwenTextViewBlock)(NSString *text);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic,assign) NSInteger popupType;// 1：从屏幕底部之外弹出

@end
