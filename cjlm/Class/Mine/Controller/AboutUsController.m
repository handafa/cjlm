//
//  AboutUsController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/21.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];
    [self setTitleViewTitle:@"关于我们"];
    
    [self initUI];
}

- (void)initUI
{
    UIImageView *icon = [HELPER imageViewWithSuperView:self.view backgroundColor:COLOR(clearColor) image:IMG(@"icon_aboutUs") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(ScaleY(78)));
    }];
    icon.layer.cornerRadius = 15;
    icon.layer.masksToBounds = YES;
   
    //当前版本
    UILabel *lblVersion = [HELPER labelWithSuperView:self.view backgroundColor:COLOR(clearColor) text:@"当前版本" textAlignment:NSTextAlignmentLeft textColor:SUBTITLE_BLACK fontSize:16 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(25)));
        make.top.equalTo(icon.mas_bottom).offset(ScaleY(50));
    }];
    
    [HELPER labelWithSuperView:self.view backgroundColor:COLOR(clearColor) text:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] textAlignment:NSTextAlignmentRight textColor:RGBOF(0xadadad) fontSize:13 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(lblVersion.mas_centerY);
        make.right.equalTo(@(-ScaleX(21)));
    }];
    [HELPER imageViewWithSuperView:self.view backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@1);
        make.left.equalTo(lblVersion.mas_left);
        make.right.equalTo(@(-ScaleX(21)));
        make.top.equalTo(lblVersion.mas_bottom).offset(ScaleY(13));
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
