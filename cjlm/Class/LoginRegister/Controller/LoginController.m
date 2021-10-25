//
//  LoginController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/21.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "LoginController.h"
#import "TermsConditionsController.h"

@interface LoginController () <TYAttributedLabelDelegate>

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UITextField *authCodeTextField;

@end

@implementation LoginController

/**
 设置leftBarButtonItem为返回按钮
 */
- (void)setLeftBackButton
{
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 18)];
    leftBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBackBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackBtn];
}

- (void)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        TabBarController *tabBarVC = (TabBarController *)WINDOW.rootViewController;
        tabBarVC.selectedIndex = 0;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];
    
    [self initUI];
}

- (void)initUI
{
    UILabel *lblLogin = [HELPER labelWithSuperView:self.view backgroundColor:COLOR(clearColor) text:@"登录" textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:34 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(33)));
        make.top.equalTo(@(ScaleY(57)));
    }];
    
    [HELPER labelWithSuperView:self.view backgroundColor:COLOR(clearColor) text:@"手机号未注册时，登录后将自动注册。" textAlignment:NSTextAlignmentLeft textColor:RGBOF(0x838383) fontSize:14 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(lblLogin.mas_left);
        make.top.equalTo(lblLogin.mas_bottom).offset(ScaleY(9));
    }];
    
    // 输入手机号码
    _phoneTextField = [HELPER textFieldWithSuperView:self.view textAlignment:NSTextAlignmentLeft fontSize:16 textColor:TITLE_BLACK backgroundColor:COLOR(clearColor) placeholder:@"请输入手机号码" placeholderColor:PLACEHOLDER_COLOR placeholderFont:16 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(33)));
        make.right.equalTo(@(-ScaleX(33)));
        make.top.equalTo(lblLogin.mas_bottom).offset(ScaleY(94));
    }];
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [HELPER imageViewWithSuperView:self.view backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@1);
        make.left.equalTo(@(ScaleX(32)));
        make.right.equalTo(@(-ScaleX(32)));
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScaleY(12));
    }];
    
    //验证码
    _authCodeTextField = [HELPER textFieldWithSuperView:self.view textAlignment:NSTextAlignmentLeft fontSize:16 textColor:TITLE_BLACK backgroundColor:COLOR(clearColor) placeholder:@"验证码" placeholderColor:PLACEHOLDER_COLOR placeholderFont:16 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(33)));
        make.width.equalTo(@(ScaleX(200)));
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(ScaleY(45));
    }];
    [HELPER imageViewWithSuperView:self.view backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@1);
        make.left.equalTo(@(ScaleX(32)));
        make.right.equalTo(@(-ScaleX(32)));
        make.top.equalTo(self.authCodeTextField.mas_bottom).offset(ScaleY(12));
    }];
    
    // 获取验证码btn
    [HELPER buttonWithSuperView:self.view andNormalTitle:@"获取验证码" andNormalTextColor:RGBOF(0xf6a84c) andTextFont:14 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.right.equalTo(@(-ScaleX(32)));
        make.centerY.equalTo(self.authCodeTextField.mas_centerY);
    }];
    
    //登录btn
    UIButton *loginButton = [HELPER buttonWithSuperView:self.view andNormalTitle:@"登录" andNormalTextColor:COLOR(whiteColor) andTextFont:17 andNormalImage:nil backgroundColor:RGBOF(0xf7604d) addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(36)));
        make.right.equalTo(@(-ScaleX(36)));
        make.height.equalTo(@49);
        make.top.equalTo(self.authCodeTextField.mas_bottom).offset(ScaleY(50));
    }];
    loginButton.layer.cornerRadius = 49/2;
    loginButton.layer.masksToBounds = YES;
    
    [self.view layoutIfNeeded];
    //服务条款、隐私协议
    NSString *terms = @"登录即代表您已同意《服务条款》和《隐私协议》";
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = terms;
    textContainer.textAlignment = kCTTextAlignmentCenter;
    textContainer.textColor = TITLE_BLACK;
    textContainer.font = [UIFont boldSystemFontOfSize:12];
    
    TYLinkTextStorage *linkTextStorage = [[TYLinkTextStorage alloc]init];
    linkTextStorage.range = [terms rangeOfString:@"《服务条款》"];
    linkTextStorage.textColor = RGBOF(0xf7604d);
    linkTextStorage.underLineStyle = kCTUnderlineStyleNone;
    linkTextStorage.linkData = @"服务条款";
    [textContainer addTextStorage:linkTextStorage];
    
    TYLinkTextStorage *linkTextStorage2 = [[TYLinkTextStorage alloc]init];
    linkTextStorage2.range = [terms rangeOfString:@"《隐私协议》"];
    linkTextStorage2.textColor = RGBOF(0xf7604d);
    linkTextStorage2.underLineStyle = kCTUnderlineStyleNone;
    linkTextStorage2.linkData = @"隐私协议";
    [textContainer addTextStorage:linkTextStorage2];

    TYAttributedLabel *lblTerms = [[TYAttributedLabel alloc] initWithFrame:FRAME(ScaleX(32), loginButton.mj_bottom+ScaleX(53), SCREEN_WIDTH-ScaleX(64), 0)];
    lblTerms.delegate = self;
    lblTerms.textContainer = textContainer;
    [lblTerms sizeToFit];
    [self.view addSubview:lblTerms];
}

#pragma mark - 获取验证码
- (void)getAuthCode:(UIButton *)sender
{
    if ([HELPER isValidMobile:self.phoneTextField.text] == NO) {
        [HELPER showInfoHUDWithMessage:@"手机号码错误"];
        return;
    }
    
    [sender countDownWithTime:59 normalTitle:@"获取验证码" countDownTitle:@"s后重新获取" normalBGColor:COLOR(clearColor) countDownBGColor:COLOR(clearColor)];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phoneTextField.text forKey:@"mobile"];
    [LoginRegisterService getVerificationCodeWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [HELPER showSuccessHUDWithMessage:@"验证码发送成功！"];
        }else{
            [HELPER showErrorHUDWithMessage:returnData[@"data"][@"dataInfo"][0][@"msg"]];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        
    }];
}

#pragma mark - 登录
- (void)login
{
    if ([self.phoneTextField.text isEqualToString:@"12345678910"]) {
        
    }else{
        if ([HELPER isValidMobile:self.phoneTextField.text] == NO) {
            [HELPER showInfoHUDWithMessage:@"手机号码错误"];
            return;
        }
    }
    
    if ([HELPER isZeroLengthWithString:self.authCodeTextField.text]) {
        [HELPER showInfoHUDWithMessage:@"验证码不能为空"];
        return;
    }
    
    [HELPER loadingHUD:@"" toView:WINDOW];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phoneTextField.text forKey:@"mobile"];
    [param setObject:self.authCodeTextField.text forKey:@"smscode"];
    [LoginRegisterService loginWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];
        
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogined"];
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.token = returnData[@"data"][@"authToken"];
            userModel.mobile = returnData[@"data"][@"dataInfo"][0][@"mobile"];
            userModel.nickname = returnData[@"data"][@"dataInfo"][0][@"nickname"];
            userModel.uid = [NSString stringWithFormat:@"%@",returnData[@"data"][@"dataInfo"][0][@"uid"]];
            userModel.username = returnData[@"data"][@"dataInfo"][0][@"username"];
            HELPER.userModel = userModel;
            [HELPER saveUserInfo];
            
            //发送登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [HELPER showErrorHUDWithMessage:returnData[@"msg"]];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:WINDOW];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.shadowImage = nil;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _phoneTextField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        id linkStr = ((TYLinkTextStorage*)textStorage).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            if ([linkStr isEqual:@"服务条款"]) {
                TermsConditionsController *termsConditionsVC = [TermsConditionsController new];
                termsConditionsVC.controllerType = 0;
                [self.navigationController pushViewController:termsConditionsVC animated:YES];
            }else if ([linkStr isEqual:@"隐私协议"]){
                TermsConditionsController *termsConditionsVC = [TermsConditionsController new];
                termsConditionsVC.controllerType = 1;
                [self.navigationController pushViewController:termsConditionsVC animated:YES];
            }
        }
    }
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
