//
//  FeedbackController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/30.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "FeedbackController.h"
#import "XMTextView.h"

@interface FeedbackController ()

@property (nonatomic,strong) XMTextView *feedbackTextView;

@property (nonatomic,copy) NSString *feedbackString;

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];
    [self setTitleViewTitle:@"意见反馈"];
    
    [self initUI];
}

- (void)initUI
{
    self.feedbackTextView = [self XMTextViewWithFrame:FRAME(0, 5, SCREEN_WIDTH, 150) superView:self.view fontSize:14 textColor:TITLE_BLACK backgroundColor:RGBOF(0xf7f7f7) placeholder:@"请填写您的宝贵意见。" placeholderColor:PLACEHOLDER_COLOR borderLineColor:COLOR(clearColor)];
    self.feedbackTextView.maxNumColor = RGBOF(0xb7b7b7);
    self.feedbackTextView.maxNumFont = FONT(11);
    self.feedbackTextView.tintColor = RGBOF(0x76dae9);
    WEAKSELF
    self.feedbackTextView.textViewListening = ^(NSString *textViewStr) {
        weakSelf.feedbackString = textViewStr;
    };
    
    //提交btn
    UIButton *submitBtn = [HELPER buttonWithSuperView:self.view andNormalTitle:@"提交" andNormalTextColor:COLOR(whiteColor) andTextFont:17 andNormalImage:nil backgroundColor:RGBOF(0xf7604d) addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@40);
        make.top.equalTo(self.feedbackTextView.mas_bottom).offset(28);
    }];
    submitBtn.layer.cornerRadius = 20;
    submitBtn.layer.masksToBounds = YES;
}

- (void)submit
{
    if ([HELPER isZeroLengthWithString:self.feedbackString] == YES) {
        [HELPER showInfoHUDWithMessage:@"反馈内容为空"];
        return;
    }
    
    if ([HELPER whetherEmojisAreIncluded:self.feedbackString] == YES) {
        [HELPER showInfoHUDWithMessage:@"内容不能带有表情符号"];
        return;
    }
    
    if ([HELPER isSpecialCharactersIncluded:self.feedbackString] == YES) {
        [HELPER showInfoHUDWithMessage:@"内容含有特殊字符"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.feedbackString forKey:@"message"];
    [HELPER loadingHUD:@"" toView:WINDOW];
    [MineService feedbackWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];

        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [HELPER showSuccessHUDWithMessage:@"感谢您的宝贵意见"];

            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HELPER showErrorHUDWithMessage:@"反馈失败"];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:WINDOW];
    }];
}

/**
 自定义控件XMTextView
 */
- (XMTextView *)XMTextViewWithFrame:(CGRect)frame superView:(UIView *)superView fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor borderLineColor:(UIColor *)borderLineColor{
    
    XMTextView *textView = [[XMTextView alloc] initWithFrame:frame];
    [superView addSubview:textView];
    
    textView.textFont = [UIFont systemFontOfSize:fontSize];
    textView.textColor = textColor;
    
    textView.backgroundColor = backgroundColor;
    textView.textView.backgroundColor = backgroundColor;
    
    textView.placeholder = placeholder;
    textView.placeholderColor = placeholderColor;
    
    textView.borderLineColor = borderLineColor;
    
    return textView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
