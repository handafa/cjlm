//
//  MineController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/11.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "MineController.h"
#import "MineTableHeaderView.h"
#import "MineCell.h"
#import "AboutUsController.h"
#import "PersonalHomeController.h"
#import "HomeController.h"
#import "NewestController.h"
#import "FeedbackController.h"
#import "CustomerServiceController.h"

@interface MineController ()

@property (nonatomic,strong) MineTableHeaderView *tableHeaderViewMine;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableHeaderViewMine = [[MineTableHeaderView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 160)];
    self.mainTableView.tableHeaderView = _tableHeaderViewMine;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"mineCell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineCell" owner:nil options:nil] firstObject];
    }else{
        if (cell.contentView.subviews) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
    }
    cell.dataIndexPath = indexPath;
    [cell cellAddData];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {// 个人主页
        PersonalHomeController *personalHomeVC = [PersonalHomeController new];
        personalHomeVC.ID = [HELPER obtainUserInfo].uid;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalHomeVC animated:YES];
    }else if (indexPath.row == 2) {// 意见反馈
        FeedbackController *feedbackVC = [FeedbackController new];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (indexPath.row == 3) {// 关于我们
        AboutUsController *aboutUsVC = [AboutUsController new];
        aboutUsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if (indexPath.row == 4) {// 退出登录
        SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" preferredStyle:SPAlertControllerStyleActionSheet];
        alertController.messageFont = FONT(11);
        
        SPAlertAction *logout = [SPAlertAction actionWithTitle:@"退出登录" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
            [HELPER removeUserInfo];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogined"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
            
            TabBarController *tabBarVC = (TabBarController *)WINDOW.rootViewController;
            tabBarVC.selectedIndex = 0;
            UINavigationController *nav = tabBarVC.viewControllers[0];
            HomeController *homeVC = nav.viewControllers[0];
            homeVC.pageTitleView.resetSelectedIndex = 0;
        }];
        
        SPAlertAction *cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:nil];
        [alertController addAction:logout];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 1) {// 联系客服
        CustomerServiceController *customerServiceVC = [CustomerServiceController new];
        customerServiceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customerServiceVC animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_tableHeaderViewMine) {
        _tableHeaderViewMine.lblNickName.text = [HELPER obtainUserInfo].nickname;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
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
