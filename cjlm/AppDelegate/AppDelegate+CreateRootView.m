//
//  AppDelegate+CreateRootView.m
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AppDelegate+CreateRootView.h"

@implementation AppDelegate (CreateRootView)

- (void)createRootViewControllerWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR(whiteColor);
    self.window.rootViewController = [TabBarController new];
    [self.window makeKeyAndVisible];
}

@end
