//
//  SearchUserController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/20.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "SearchUserController.h"
#import "SearchUserView.h"
#import "FriendsCell.h"

@interface SearchUserController ()

@property (nonatomic,strong) NSMutableArray *arraySearchResult;

@end

@implementation SearchUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavigationBar];
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    
    SearchUserView *searchUserView = [[SearchUserView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 44)];
    self.navigationItem.titleView = searchUserView;
    WEAKSELF
    searchUserView.searchBlock = ^(NSString * _Nonnull text) {
        [weakSelf searchUserByNickname:text];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btnNavRight = [HELPER buttonWithSuperView:nil andNormalTitle:@"取消" andNormalTextColor:SUBTITLE_BLACK andTextFont:16 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        btnNavRight;
    })];
    
    [self initUI];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 搜索用户
- (void)searchUserByNickname:(NSString *)nickname;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:(nickname ? nickname : @"") forKey:@"nickname"];
    [FriendsService searchUserWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [self.arraySearchResult removeAllObjects];
            
            FriendModel *model = [FriendModel yy_modelWithDictionary:returnData[@"data"][@"dataInfo"][0][@"real_data"]];
            if (model) {
                [self.arraySearchResult addObject:model];
            }else{
                [self.arraySearchResult removeAllObjects];
            }
        }else{
            [self.arraySearchResult removeAllObjects];
        }
        [self.mainTableView tableViewShowMessage:@"暂无搜索结果。" forDataCount:self.arraySearchResult.count];
        [self.mainTableView reloadData];
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        
    }];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arraySearchResult.count;
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
    cell.dataSource = self.arraySearchResult;
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
                [HELPER showSuccessHUDWithMessage:returnData[@"msg"]];
                
                model.follow_status = @"1";
                [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];// 发送该通知是为了刷新“关注的人”列表
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
                [HELPER showSuccessHUDWithMessage:returnData[@"msg"]];
                
                model.follow_status = @"0";
                [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];// 发送该通知是为了刷新“关注的人”列表
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
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)arraySearchResult
{
    if (!_arraySearchResult) {
        _arraySearchResult = [NSMutableArray array];
    }
    return _arraySearchResult;
}

@end
