//
//  FriendsController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/11.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "FriendsController.h"
#import "FriendsCell.h"
#import "SearchUserController.h"
#import "FriendModel.h"
#import "PersonalHomeController.h"

@interface FriendsController ()

@property (nonatomic,strong) NSMutableArray *friendArray;

@end

@implementation FriendsController

- (void)searchFriend
{
    SearchUserController *searchUserVC = [SearchUserController new];
    searchUserVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchUserVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleViewTitle:@"关注的人"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        [HELPER buttonWithSuperView:nil andNormalTitle:nil andNormalTextColor:COLOR(clearColor) andTextFont:0 andNormalImage:IMG(@"icon_search_pink") backgroundColor:COLOR(clearColor) addTarget:self action:@selector(searchFriend) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
    })];
    
    self.page = 1;
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefresh) name:RefreshFirstLevelPageListNotification object:nil];// 以后要改的
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    self.mainTableView.bounces = YES;
    
    [self loadMyFollowerListData];
    WEAKSELF
    // 添加上拉刷新
    [self setTableRefreshFooterWithTableView:self.mainTableView refreshBlock:^{
        [weakSelf pullUpToRefresh];
    }];
}


#pragma mark - 加载我的关注人列表数据
- (void)loadMyFollowerListData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
        [FriendsService listOfPeopleFollowedByMeWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            
            [self.refreshNormalHeader endRefreshing];
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                if ([returnData[@"data"][@"dataInfo"][0][@"real_data"] count] > 0) {
                    [self.backNormalFooter endRefreshing];
                    
                    for (NSDictionary *dict in returnData[@"data"][@"dataInfo"][0][@"real_data"]) {
                        FriendModel *model = [FriendModel yy_modelWithDictionary:dict];
                        [self.friendArray addObject:model];
                    }
                }else{
                    self.backNormalFooter.state = MJRefreshStateNoMoreData;
                }
            }
            [self.mainTableView tableViewShowImage:IMG(@"icon_noFriend") withMessage:@"你还没有关注好友" withStyle:0 forDataCount:self.friendArray.count];
            [self.mainTableView reloadData];
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            // 结束刷新
            [self.backNormalFooter endRefreshing];
            [self.refreshNormalHeader endRefreshing];
        }];
    });
}


#pragma mark - 上拉刷新
- (void)pullUpToRefresh
{
    self.page++;
    [self loadMyFollowerListData];
}


#pragma mark - 下拉刷新
- (void)pullDownRefresh
{
    [self.friendArray removeAllObjects];
    
    self.page = 1;
    [self loadMyFollowerListData];
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"friendsCell";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendsCell" owner:nil options:nil] firstObject];
    }else{
        if (cell.contentView.subviews) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
    }
    cell.dataIndexPath = indexPath;
    cell.dataSource = self.friendArray;
    [cell cellAddData];
    WEAKSELF
    // 关注
    cell.followBlock = ^(FriendModel * _Nonnull model) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.uid forKey:@"friend_uid"];
        [HELPER loadingHUD:@"" toView:WINDOW];
        [FriendsService followWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            [HELPER endLoadingToView:WINDOW];
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                [weakSelf loadMyFollowerListData];
            }else{
                [HELPER showErrorHUDWithMessage:@"操作失败"];
            }
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            [HELPER endLoadingToView:WINDOW];
        }];
    };
    
    // 取消关注
    cell.unfollowBlock = ^(FriendModel * _Nonnull model) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.uid forKey:@"friend_uid"];
        [HELPER loadingHUD:@"" toView:WINDOW];
        [FriendsService unfollowWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            [HELPER endLoadingToView:WINDOW];
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                [weakSelf loadMyFollowerListData];
            }else{
                [HELPER showErrorHUDWithMessage:@"操作失败"];
            }
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            [HELPER endLoadingToView:WINDOW];
        }];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    FriendModel *model = self.friendArray[indexPath.row];
    PersonalHomeController *personalHomeVC = [PersonalHomeController new];
    personalHomeVC.ID = model.uid;
    personalHomeVC.nickname = model.nickname;
    personalHomeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalHomeVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)friendArray
{
    if (!_friendArray) {
        _friendArray = [NSMutableArray array];
    }
    return _friendArray;
}


@end
