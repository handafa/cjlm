//
//  TermsConditionsController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/12/3.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "TermsConditionsController.h"

@interface TermsConditionsController ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation TermsConditionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];
    
    [self initUI];
}

- (void)initUI
{
    NSString *urlString;
    if (_controllerType == 0) {// 服务条款
        [self setTitleViewTitle:@"服务条款"];
        
        urlString = [NSString stringWithFormat:@"%@serviceClause.htm",REQUEST_PATH];
    }else if (_controllerType == 1){// 隐私协议
        [self setTitleViewTitle:@"隐私协议"];
        
        urlString = [NSString stringWithFormat:@"%@privacyPolicy.htm",REQUEST_PATH];
    }
    _webView = [self WKWebViewWithSuperView:self.view requestURLStr:urlString target:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
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
