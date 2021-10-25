//
//  NewestController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "NewestController.h"
#import "NewestCell.h"
#import "NewestModel.h"
#import "NewestFrameModel.h"
#import "LZImageBrowserManger.h"
#import "ReportController.h"
#import "AllCommentsController.h"
#import "KeyboardView.h"
#import "PersonalHomeController.h"

@interface NewestController ()

@property (nonatomic,strong) NSMutableArray *arrayNewest;

@property (nonatomic,strong) NSMutableArray *frameModels;

@end

@implementation NewestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.page = 1;
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefresh) name:RefreshFirstLevelPageListNotification object:nil];// 以后要改的
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStyleGrouped backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    self.mainTableView.bounces = YES;
    // 数据加载
    [self loadTableListData];
    WEAKSELF
    // 添加下拉刷新
    [self setTableRefreshHeaderWithTableView:self.mainTableView refreshBlock:^{
        [weakSelf pullDownRefresh];
    }];
    // 添加上拉刷新
    [self setTableRefreshFooterWithTableView:self.mainTableView refreshBlock:^{
        [weakSelf pullUpRefresh];
    }];
}


#pragma mark - 加载最新、关注列表的数据
- (void)loadTableListData
{
    if (self.homeVCType == 0) {// 最新
        [self loadLatestListData];
    }else if(self.homeVCType == 1) {// 关注
        [self loadConcernListData];
    }
}

/*
 加载最新列表数据
 */
- (void)loadLatestListData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
        [HomeService latestDataOnHomepageWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            
            [self.refreshNormalHeader endRefreshing];
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                if ([returnData[@"data"][@"dataInfo"][0][@"real_data"] count] > 0) {
                    [self.backNormalFooter endRefreshing];
                    
                    for (NSDictionary *dict in returnData[@"data"][@"dataInfo"][0][@"real_data"]) {
                        NewestModel *model = [NewestModel yy_modelWithDictionary:dict];
                        [self.arrayNewest addObject:model];
                            
                        NewestFrameModel *frameModel = [NewestFrameModel new];
                        frameModel.newestModel = model;
                        [self.frameModels addObject:frameModel];
                    }
                }else{
                    self.backNormalFooter.state = MJRefreshStateNoMoreData;
                }
            }
            [self.mainTableView reloadData];
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            // 结束刷新
            [self.backNormalFooter endRefreshing];
            [self.refreshNormalHeader endRefreshing];
        }];
    });
}

/*
 加载关注列表数据
 */
- (void)loadConcernListData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
        [HomeService homepageAttentionListWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            
            [self.refreshNormalHeader endRefreshing];
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                if ([returnData[@"data"][@"dataInfo"][0][@"real_data"] count] > 0) {
                    [self.backNormalFooter endRefreshing];
                    
                    for (NSDictionary *dict in returnData[@"data"][@"dataInfo"][0][@"real_data"]) {
                        NewestModel *model = [NewestModel yy_modelWithDictionary:dict];
                        [self.arrayNewest addObject:model];
                            
                        NewestFrameModel *frameModel = [NewestFrameModel new];
                        frameModel.newestModel = model;
                        [self.frameModels addObject:frameModel];
                    }
                }else{
                    self.backNormalFooter.state = MJRefreshStateNoMoreData;
                }
            }
            [self.mainTableView reloadData];
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            // 结束刷新
            [self.backNormalFooter endRefreshing];
            [self.refreshNormalHeader endRefreshing];
        }];
    });
}


#pragma mark - 上拉刷新
- (void)pullUpRefresh
{
    self.page ++;
    [self loadTableListData];
}


#pragma mark - 下拉刷新
- (void)pullDownRefresh
{
    [self.arrayNewest removeAllObjects];
    [self.frameModels removeAllObjects];
    
    self.page = 1;
    [self loadTableListData];
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayNewest.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"newestCell";
    NewestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewestCell" owner:nil options:nil] firstObject];
    }else{
        if (cell.contentView.subviews) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        
        [cell.arrayImgUrl removeAllObjects];
        [cell.arrayimgView removeAllObjects];
    }
    cell.dataIndexPath = indexPath;
    cell.arrayNewest = self.arrayNewest;
    [cell cellAddData];
    
    WEAKSELF
#pragma mark - 点击头像和昵称跳转到个人主页
    cell.jumpToPersonalHomepageBlock = ^(NewestModel * _Nonnull model) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            [weakSelf needAccountForLogin];
            return ;
        }
        
        PersonalHomeController *personalHomeVC = [PersonalHomeController new];
        personalHomeVC.ID = model.uid;
        personalHomeVC.nickname = model.nickname;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:personalHomeVC animated:YES];
    };
    
    
#pragma mark - 展开全文事件
    cell.blockShowFullText = ^(NewestModel * _Nonnull model) {
        NewestFrameModel *frameModel = weakSelf.frameModels[indexPath.row];
        frameModel.newestModel = model;
        [weakSelf.mainTableView reloadData];
    };
    
    
#pragma mark - 点击查看图片
    TabBarController *tabBarVC = (TabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    cell.checkImageBlock = ^(NSArray * _Nonnull imgUrls, NSArray * _Nonnull imageViews, NSInteger tag) {
        LZImageBrowserManger *manager = [LZImageBrowserManger imageBrowserMangerWithUrlStr:imgUrls originImageViews:imageViews originController:tabBarVC forceTouch:YES forceTouchActionTitles:nil forceTouchActionComplete:nil];
        manager.selectPage = tag;
        [manager showImageBrowser];
    };
    
    
#pragma mark - 点击 ... 按钮
    cell.checkMoreBlock = ^(NewestModel * _Nonnull model) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            [weakSelf needAccountForLogin];
            return ;
        }
        
        SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeDefault];
        if ([STRING(model.uid) isEqualToString:[HELPER obtainUserInfo].uid]) {// 自己发的帖子
            //取消
            SPAlertAction *cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:nil];
            // 删除
            SPAlertAction *delete = [SPAlertAction actionWithTitle:@"删除" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
                [HELPER loadingHUD:@"" toView:WINDOW];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:model.tid forKey:@"tid"];
                [HomeService deleteThePostWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                    LOG(@"🐷%@",returnData);
                    [HELPER endLoadingToView:WINDOW];
                    
                    if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                        [HELPER showSuccessHUDWithMessage:@"删除成功！"];
                        
                        [weakSelf.arrayNewest removeObjectAtIndex:indexPath.row];
                        [weakSelf.frameModels removeObjectAtIndex:indexPath.row];
                        [weakSelf.mainTableView reloadData];
                    }
                } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                    [HELPER endLoadingToView:WINDOW];
                }];
            }];
            delete.titleColor = RGBOF(0xff5c5c);
            
            [alertController addAction:cancel];
            [alertController addAction:delete];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }else{// 别人发的帖子
            //取消
            SPAlertAction *cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:nil];
            // 屏蔽内容
            SPAlertAction *blockContent = [SPAlertAction actionWithTitle:@"屏蔽该内容" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
                [HELPER loadingHUD:@"" toView:WINDOW];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:model.tid forKey:@"tid"];
                [HomeService blockUserPostsWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                    LOG(@"🐷%@",returnData);
                    [HELPER endLoadingToView:WINDOW];
                    
                    if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                        [HELPER showSuccessHUDWithMessage:@"屏蔽成功"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                    }
                } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                    [HELPER endLoadingToView:WINDOW];
                }];
            }];
            // 屏蔽用户
            SPAlertAction *blockUser = [SPAlertAction actionWithTitle:@"屏蔽该用户" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
                [HELPER loadingHUD:@"" toView:WINDOW];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:model.uid forKey:@"target_uid"];
                [HomeService shieldingUsersWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                    LOG(@"🐷%@",returnData);
                    [HELPER endLoadingToView:WINDOW];
                    
                    if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                        [HELPER showSuccessHUDWithMessage:@"屏蔽成功"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                    }
                } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                    [HELPER endLoadingToView:WINDOW];
                }];
            }];
            //举报
            SPAlertAction *report = [SPAlertAction actionWithTitle:@"举报" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
                ReportController *reportVC = [ReportController new];
                reportVC.pid = model.pid;
                reportVC.tid = model.tid;
                reportVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:reportVC animated:YES];
            }];
            report.titleColor = RGBOF(0xff5c5c);
            
            [alertController addAction:cancel];
            [alertController addAction:report];
            [alertController addAction:blockContent];
            [alertController addAction:blockUser];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    };
    
    
#pragma mark - 查看全部评论
    cell.seeAllCommentsBlock = ^(NewestModel * _Nonnull model) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            [weakSelf needAccountForLogin];
            return ;
        }
        
        AllCommentsController *allCommentsVC = [AllCommentsController new];
        allCommentsVC.tid = model.tid;
        allCommentsVC.pid = model.pid;
        allCommentsVC.nickname = model.nickname;
        allCommentsVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:allCommentsVC animated:YES];
    };
    
    
#pragma mark - 评论事件
    cell.commentBlock = ^(NewestModel * _Nonnull model) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            [weakSelf needAccountForLogin];
            return ;
        }
        
        KeyboardView *keyboardView = [[KeyboardView alloc] initWithFrame:FRAME(0, 0, SCREEN_HEIGHT, 500)];
        keyboardView.dismissBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        keyboardView.ewenTextView.EwenTextViewBlock = ^(NSString *test){
            if ([HELPER whetherEmojisAreIncluded:test]) {
                [HELPER showInfoHUDWithMessage:@"评论内容不能包含表情符号"];
                return ;
            }
            
            [HELPER loadingHUD:@"" toView:WINDOW];
            //评论请求
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:model.pid forKey:@"pid"];
            [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
            [param setObject:model.tid forKey:@"tid"];
            [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
            [param setObject:@"0" forKey:@"thread_type"];// 0：朋友圈
            [param setObject:@"0" forKey:@"quotepid"];
            [param setObject:[WordFilterHelper.shared filter:test] forKey:@"message"];
            [param setObject:@"1" forKey:@"doctype"];
            // 第一次评论传评论人id，否则传0
            if (model.comment.count > 0) {
                [param setObject:@"0" forKey:@"is_first"];
            }else{
                [param setObject:[HELPER obtainUserInfo].uid forKey:@"is_first"];
            }
            [HomeService remarkWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                LOG(@"🐷%@",returnData);
                [HELPER endLoadingToView:WINDOW];
                
                if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                }else{
                    [HELPER showErrorHUDWithMessage:@"评论失败"];
                }
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                [HELPER endLoadingToView:WINDOW];
            }];
        };
        
        SPAlertController *alertController = [SPAlertController alertControllerWithCustomAlertView:keyboardView preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeFromBottom];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
    
    
#pragma mark - 操作用户评论
    cell.handleCommentBlock = ^(NewestModel * _Nonnull model, NSString * _Nonnull cid, NSString * _Nonnull uid) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
            [weakSelf needAccountForLogin];
            return ;
        }
        
        //如果是自己的评论可以删除
        if ([STRING(uid) isEqual:[HELPER obtainUserInfo].uid]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            //删除
            UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:model.pid forKey:@"pid"];
                [param setObject:model.tid forKey:@"tid"];
                [param setObject:cid forKey:@"cid"];
                [HELPER loadingHUD:@"" toView:WINDOW];
                [HomeService deleteCommentWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                    LOG(@"🐷%@",returnData);
                    [HELPER endLoadingToView:WINDOW];
                    
                    if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                    }else{
                        [HELPER showErrorHUDWithMessage:@"删除失败"];
                    }
                } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                    [HELPER endLoadingToView:WINDOW];
                }];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancel];
            [alertController addAction:delete];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    };
    
    
#pragma mark - 点赞或取消点赞
    cell.giveLikeBlock = ^(NewestModel * _Nonnull model) {
        if ([[NSString stringWithFormat:@"%@",model.vote_status] isEqualToString:@"0"]) {// 未点赞状态
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
            [param setObject:model.tid forKey:@"tid"];
            [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
            [HomeService giveALikeWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                LOG(@"🐷%@",returnData);

                if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                }
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {

            }];
        }else  if ([[NSString stringWithFormat:@"%@",model.vote_status] isEqualToString:@"1"]) {// 已点赞状态
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
            [param setObject:model.tid forKey:@"tid"];
            [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
            [HomeService cancelThumbUpWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                LOG(@"🐷%@",returnData);

                if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
                }
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {

            }];
        }
    };

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewestFrameModel *frameModel = self.frameModels[indexPath.row];
    return frameModel.cellHeight;
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
   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)arrayNewest
{
    if (!_arrayNewest) {
        _arrayNewest = [NSMutableArray array];
    }
    return _arrayNewest;
}

- (NSMutableArray *)frameModels
{
    if (!_frameModels) {
        _frameModels = [NSMutableArray array];
    }
    return _frameModels;
}


@end
