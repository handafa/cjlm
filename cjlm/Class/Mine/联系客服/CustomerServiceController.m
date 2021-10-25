//
//  CustomerServiceController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/12/5.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "CustomerServiceController.h"

@interface CustomerServiceController ()

@end

@implementation CustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];
    [self setTitleViewTitle:@"联系客服"];
    
    [HELPER labelWithSuperView:self.view backgroundColor:COLOR(clearColor) text:@"客服QQ：2452001592\n\n客服邮箱：2452001592@qq.com\n\n工作时间：每周一至周六  9:30--19:00" textAlignment:NSTextAlignmentCenter textColor:TITLE_BLACK fontSize:16 numberOfLines:0 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@50);
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
