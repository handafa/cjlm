//
//  PersonalHomeController.m
//  cjlm
//
//  Created by 韦瑀 on 2019/11/21.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "PersonalHomeController.h"
#import "PersonalHomeHeaderView.h"
#import "NewestModel.h"
#import "NewestFrameModel.h"
#import "NewestCell.h"
#import "LZImageBrowserManger.h"
#import "ReportController.h"
#import "AllCommentsController.h"
#import "KeyboardView.h"

@interface PersonalHomeController () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *arrayNewest;

@property (nonatomic,strong) NSMutableArray *frameModels;

@property (nonatomic,strong) PersonalHomeHeaderView *tableHeaderView;

@property (nonatomic,copy) NSString *follow_status;

@property (nonatomic,copy) NSString *countTotalPosts;// 全部帖子数

@end

@implementation PersonalHomeController

- (void)setFollow_status:(NSString *)follow_status
{
    _follow_status = follow_status;
    if ([_follow_status isEqualToString:@"0"]) {// 未关注状态
        [self setupFollowButton];
    }else if ([_follow_status isEqualToString:@"1"]) {// 已关注状态
        [self setupUnfollowButton];
    }
}

#pragma mark - 设置关注按钮
- (void)setupFollowButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btnFollow = [HELPER buttonWithSuperView:nil andNormalTitle:@"关注" andNormalTextColor:RGBOF(0xff8272) andTextFont:12 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        btnFollow.frame = FRAME(0, 0, 75, 30);
        [HELPER addSpecifiedRoundedCornersToView:btnFollow withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(15, 15) borderWidth:1 borderColor:RGBOF(0xff8272)];
        btnFollow;
    })];
}

- (void)followAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.ID forKey:@"friend_uid"];
    [HELPER loadingHUD:@"" toView:WINDOW];
    [FriendsService followWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];

        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [self setupUnfollowButton];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
        }else{
            [HELPER showErrorHUDWithMessage:@"操作失败"];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:WINDOW];
    }];
}

#pragma mark - 设置取消关注按钮
- (void)setupUnfollowButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btnUnfollow = [HELPER buttonWithSuperView:nil andNormalTitle:@"取消关注" andNormalTextColor:SPLIT_COLOR andTextFont:12 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(unfollowAction) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        btnUnfollow.frame = FRAME(0, 0, 85, 30);
        [HELPER addSpecifiedRoundedCornersToView:btnUnfollow withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(15, 15) borderWidth:1 borderColor:SPLIT_COLOR];
        btnUnfollow;
    })];
}

- (void)unfollowAction
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.ID forKey:@"friend_uid"];
    [HELPER loadingHUD:@"" toView:WINDOW];
    [FriendsService unfollowWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];

        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [self setupFollowButton];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
        }else{
            [HELPER showErrorHUDWithMessage:@"操作失败"];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:WINDOW];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLeftBackButton];

    self.page = 1;
    [self initUI];
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    self.mainTableView.bounces = YES;
    
    _tableHeaderView = [[PersonalHomeHeaderView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, ScaleY(215))];
    _tableHeaderView.nicknameString = self.nickname;
    _tableHeaderView.ID = self.ID;
    self.mainTableView.tableHeaderView = _tableHeaderView;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadPersonalHomepageData];
    WEAKSELF
    // 添加上拉刷新
    [self setTableRefreshFooterWithTableView:self.mainTableView refreshBlock:^{
        [weakSelf pullUpToRefresh];
    }];
    // 添加下拉刷新
    [self setTableRefreshHeaderWithTableView:self.mainTableView refreshBlock:^{
        [weakSelf pullDownRefresh];
    }];
}


#pragma mark - 加载个人主页数据
- (void)loadPersonalHomepageData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[NSString stringWithFormat:@"%@",self.ID] isEqualToString:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid]]){// 自己的主页
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
            [MineService personalHomepageWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
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
                    //获取关注数
                    self.tableHeaderView.follow_count = returnData[@"data"][@"dataInfo"][0][@"follow_count"];
                    //获取全部帖子数
                    self.countTotalPosts = returnData[@"data"][@"dataInfo"][0][@"threads_count"];
                }
                [self.mainTableView reloadData];
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                // 结束刷新
                [self.refreshNormalHeader endRefreshing];
                [self.backNormalFooter endRefreshing];
            }];
        }else{// 别人的主页
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
            [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            [param setObject:self.ID forKey:@"fuid"];
            [MineService viewOtherPeopleHomepageDataWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
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
                    //获取关注数
                    self.tableHeaderView.follow_count = returnData[@"data"][@"dataInfo"][0][@"follow_count"];
                    //获取关注状态
                    self.follow_status = [NSString stringWithFormat:@"%@",returnData[@"data"][@"dataInfo"][0][@"follow_status"]];
                    self.countTotalPosts = returnData[@"data"][@"dataInfo"][0][@"threads_count"];
                    // 如果数据为空，判断是否是因为用户被屏蔽导致
                    [self showUIWhenTheUserIsBlocked:STRING(returnData[@"data"][@"dataInfo"][0][@"black_status"]) forDataCount:self.arrayNewest.count];
                }
                [self.mainTableView reloadData];
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                // 结束刷新
                [self.refreshNormalHeader endRefreshing];
                [self.backNormalFooter endRefreshing];
            }];
        }
    });
}


#pragma mark - 上拉刷新
- (void)pullUpToRefresh
{
    self.page++;
    [self loadPersonalHomepageData];
}


#pragma mark - 下拉刷新
- (void)pullDownRefresh
{
    [self.arrayNewest removeAllObjects];
    [self.frameModels removeAllObjects];
    
    self.page = 1;
    [self loadPersonalHomepageData];
}


#pragma mark - 展示用户被屏蔽时的界面
- (void)showUIWhenTheUserIsBlocked:(NSString *)status forDataCount:(NSUInteger)dataCount
{
    if (dataCount == 0 && [status isEqualToString:@"1"]) {
        UIView *blockView = [UIView new];
        self.mainTableView.backgroundView = blockView;
        
        UILabel *lblContent = [UILabel new];
        [blockView addSubview:lblContent];
        [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@(ScaleY(250)+36));
        }];
        lblContent.numberOfLines = 0;
        
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:@"暂无内容\n您已经屏蔽了对方，无法查看他的内容"];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, 4)];
        [contentStr addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(4, contentStr.length-4)];
        
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 10;
        [contentStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, contentStr.length)];
        lblContent.attributedText = contentStr;
        lblContent.textAlignment = NSTextAlignmentCenter;
        
        // 取消屏蔽btn
        UIButton *btnCancel = [HELPER buttonWithSuperView:blockView andNormalTitle:@"取消屏蔽" andNormalTextColor:TITLE_BLACK andTextFont:14 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(cancelShielding) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.centerX.equalTo(blockView);
            make.size.mas_equalTo(CGSizeMake(90, 35));
            make.top.equalTo(lblContent.mas_bottom).offset(20);
        }];
        btnCancel.layer.borderColor = COLOR(lightGrayColor).CGColor;
        btnCancel.layer.borderWidth = 1;
    } else {
        self.mainTableView.backgroundView = nil;
    }
}

/*
 取消屏蔽
 */
- (void)cancelShielding
{
    [HELPER loadingHUD:@"" toView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.ID forKey:@"target_uid"];
    [HomeService unblockedUserWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:self.view];
        
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [HELPER showSuccessHUDWithMessage:@"已取消屏蔽"];
            // 发送该通知是为了刷新所有带有被屏蔽用户发帖的列表
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
            
            [self pullDownRefresh];// 以后要改的
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:self.view];
    }];
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
    
    
#pragma mark - 点击 更多 按钮
    cell.checkMoreBlock = ^(NewestModel * _Nonnull model) {
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
                        
                        // 发送该通知是为了刷新所有带有被删除的帖子的列表
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];
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
                        
                        [weakSelf.arrayNewest removeObjectAtIndex:indexPath.row];
                        [weakSelf.frameModels removeObjectAtIndex:indexPath.row];
                        [weakSelf.mainTableView reloadData];
                        
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
                        
                        [weakSelf pullDownRefresh];// 以后要改的
                        
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
        AllCommentsController *allCommentsVC = [AllCommentsController new];
        allCommentsVC.tid = model.tid;
        allCommentsVC.pid = model.pid;
        allCommentsVC.nickname = model.nickname;
        allCommentsVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:allCommentsVC animated:YES];
    };
    
    
#pragma mark - 评论事件
    cell.commentBlock = ^(NewestModel * _Nonnull model) {
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
            [param setObject:[WordFilterHelper.shared filter:test] forKey:@"message"];;
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
                    [weakSelf pullDownRefresh];// 以后要改的
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
                        [weakSelf pullDownRefresh];// 以后要改的
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
                    model.vote_status = @"1";
                    //点赞数量改变
                    NSInteger numberLike = [model.votes integerValue];
                    numberLike+=1;
                    model.votes = [NSString stringWithFormat:@"%ld",(long)numberLike];
                    
                    [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
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
                    model.vote_status = @"0";
                    //点赞数量改变
                    NSInteger numberLike = [model.votes integerValue];
                    numberLike-=1;
                    model.votes = [NSString stringWithFormat:@"%ld",(long)numberLike];
                    
                    [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
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
    return 36;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //全部帖子
    UIView *headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 36)];
    headerView.backgroundColor = COLOR(whiteColor);
    [HELPER labelWithSuperView:headerView backgroundColor:COLOR(clearColor) text:[NSString stringWithFormat:@"全部帖子（%@）",self.countTotalPosts] textAlignment:NSTextAlignmentLeft textColor:SUBTITLE_BLACK fontSize:13 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(13)));
        make.centerY.equalTo(headerView);
    }];
    [HELPER imageViewWithSuperView:headerView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@0.8);
        make.left.right.bottom.equalTo(@0);
    }];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTableView) {
        if (scrollView.contentOffset.y > ScaleY(215) - NAVIGATION_BAR_HEIGHT) {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }else{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
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
