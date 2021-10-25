//
//  TabBarController.m
//  Project
//
//  Created by 韦瑀 on 2019/4/16.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "TabBarController.h"
#import "HomeController.h"
#import "FriendsController.h"
#import "MineController.h"

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self setupViewControllers];
    
    if (@available(iOS 13.0, *)) {
        self.tabBar.tintColor = RGBOF(0xf7604d);
        self.tabBar.unselectedItemTintColor = RGBOF(0x999999);
    }
}

- (void)setupViewControllers{
    //首页
    HomeController *homeVC = [HomeController new];
    [homeVC setTabBarItemWithImageName:@"tab_home_Normal" selectedImageName:@"tab_home_select" title:@"首页"];
    //好友
    FriendsController *friendsVC = [FriendsController new];
    [friendsVC setTabBarItemWithImageName:@"tab_friends_Normal" selectedImageName:@"tab_friends_select" title:@"好友"];
    //我
    MineController *mineVC = [MineController new];
    [mineVC setTabBarItemWithImageName:@"tab_mine_Normal" selectedImageName:@"tab_mine_select" title:@"我"];
    
    //初始化UINavigationController，并设置根视图控制器
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:friendsVC];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    //嵌套navigationController
    self.viewControllers = @[nav1,nav2,nav3];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"首页"] == NO) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            LoginController *loginVC = [LoginController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
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
