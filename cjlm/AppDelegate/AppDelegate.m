//
//  AppDelegate.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+CreateRootView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    //创建根控制器
    [self createRootViewControllerWithApplication:application options:launchOptions];
    
    return YES;
}


@end
