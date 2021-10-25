//
//  ReportController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "ReportController.h"
#import "XMTextView.h"

@interface ReportController ()

@property (nonatomic,strong) XMTextView *reportTextView;

@property (nonatomic,copy) NSString *reportString;

@end

@implementation ReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleViewTitle:@"举报"];
    [self setLeftBackButton];
    
    [self initUI];
}

- (void)initUI
{
    self.reportTextView = [self XMTextViewWithFrame:FRAME(0, 5, SCREEN_WIDTH, 150) superView:self.view fontSize:14 textColor:TITLE_BLACK backgroundColor:RGBOF(0xf7f7f7) placeholder:@"请填写举报原因。" placeholderColor:PLACEHOLDER_COLOR borderLineColor:COLOR(clearColor)];
    self.reportTextView.maxNumColor = RGBOF(0xb7b7b7);
    self.reportTextView.maxNumFont = FONT(11);
    self.reportTextView.tintColor = RGBOF(0x76dae9);
    WEAKSELF
    self.reportTextView.textViewListening = ^(NSString *textViewStr) {
        weakSelf.reportString = textViewStr;
    };
    
    //提交btn
    UIButton *reportBtn = [HELPER buttonWithSuperView:self.view andNormalTitle:@"提交" andNormalTextColor:COLOR(whiteColor) andTextFont:17 andNormalImage:nil backgroundColor:RGBOF(0xf7604d) addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@40);
        make.top.equalTo(self.reportTextView.mas_bottom).offset(28);
    }];
    reportBtn.layer.cornerRadius = 20;
    reportBtn.layer.masksToBounds = YES;
}

- (void)submit
{
    if ([HELPER isZeroLengthWithString:self.reportString]) {
        [HELPER showInfoHUDWithMessage:@"举报内容为空"];
        return;
    }
    
    if ([HELPER whetherEmojisAreIncluded:self.reportString] == YES) {
        [HELPER showInfoHUDWithMessage:@"内容不能带有表情符号"];
        return;
    }
    
    if ([HELPER isSpecialCharactersIncluded:self.reportString] == YES) {
        [HELPER showInfoHUDWithMessage:@"内容含有特殊字符"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.pid forKey:@"pid"];
    [param setObject:self.tid forKey:@"tid"];
    [param setObject:self.reportString forKey:@"message"];
    [HELPER loadingHUD:@"" toView:WINDOW];
    [HomeService reportWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];
        
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [HELPER showSuccessHUDWithMessage:@"举报成功，平台将会在24小时之内给出回复。"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HELPER showErrorHUDWithMessage:@"提交失败"];
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
