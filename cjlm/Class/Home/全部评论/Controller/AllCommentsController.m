//
//  AllCommentsController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AllCommentsController.h"
#import "AllCommentsCell.h"
#import "CommentModel.h"
#import "PersonalHomeController.h"

@interface AllCommentsController ()

@property (nonatomic,strong) NSMutableArray *arrayComment;

@end

@implementation AllCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleViewTitle:_nickname];
    [self setLeftBackButton];
    
    [self initUI];
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadAllComments];
}

#pragma mark - 加载所有的评论
- (void)loadAllComments
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.tid forKey:@"tid"];
        [param setObject:self.pid forKey:@"pid"];
        [HomeService allCommentsOnThePostWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
            LOG(@"🐷%@",returnData);
            
            if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                for (NSDictionary *dict in returnData[@"data"][@"dataInfo"][0][@"real_data"]) {
                    CommentModel *model = [CommentModel yy_modelWithDictionary:dict];
                    [self.arrayComment addObject:model];
                }
            }
            [self.mainTableView reloadData];
        } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
            
        }];
    });
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayComment.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"allCommentsCell";
    AllCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllCommentsCell" owner:nil options:nil] firstObject];
    }else{
        if (cell.contentView.subviews) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
    }
    cell.dataIndexPath = indexPath;
    cell.arrayComment = self.arrayComment;
    [cell cellAddData];
    WEAKSELF
    //点击头像跳转到个人主页
    cell.jumpToPersonalHomepageBlock = ^(CommentModel * _Nonnull model) {
        PersonalHomeController *personalHomeVC = [PersonalHomeController new];
        personalHomeVC.ID = model.uid;
        personalHomeVC.nickname = model.nickname;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:personalHomeVC animated:YES];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = self.arrayComment[indexPath.row];
    UILabel *lblComment = [HELPER labelWithSuperView:nil backgroundColor:COLOR(clearColor) text:model.message_fmt textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:14 numberOfLines:0 andMasonryBlock:nil];
    lblComment.frame = FRAME(0, 0, SCREEN_WIDTH - ScaleX(24) - 40 - ScaleX(18), 0);
    [lblComment sizeToFit];
    return 47 + lblComment.mj_h + 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 42;
    }
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 0)];
        headerView.backgroundColor = COLOR(whiteColor);
        [HELPER labelWithSuperView:headerView backgroundColor:COLOR(clearColor) text:[NSString stringWithFormat:@"%lu条评论",(unsigned long)self.arrayComment.count] textAlignment:NSTextAlignmentLeft textColor:SUBTITLE_BLACK fontSize:15 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.left.equalTo(@(ScaleX(14)));
            make.centerY.equalTo(headerView);
        }];
        
        [HELPER imageViewWithSuperView:headerView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@1);
        }];
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentModel *model = self.arrayComment[indexPath.row];
    // 只有自己的评论可以删除
    if ([[NSString stringWithFormat:@"%@",model.uid] isEqualToString:[NSString stringWithFormat:@"%@",[HELPER obtainUserInfo].uid]]) {
        SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeDefault];
        //取消
        SPAlertAction *cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:nil];
        //删除评论
        SPAlertAction *delete = [SPAlertAction actionWithTitle:@"删除评论" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:model.pid forKey:@"pid"];
            [param setObject:model.tid forKey:@"tid"];
            [param setObject:model.cid forKey:@"cid"];
            [HELPER loadingHUD:@"" toView:WINDOW];
            [HomeService deleteCommentWithParam:param success:^(id  _Nonnull returnData, NSInteger responseCode) {
                LOG(@"🐷%@",returnData);
                [HELPER endLoadingToView:WINDOW];

                if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
                    [self.arrayComment removeObjectAtIndex:indexPath.row];
                    [self.mainTableView reloadData];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];// 发布该通知是为了刷新首页评论数据
                }else{
                    [HELPER showErrorHUDWithMessage:@"删除失败"];
                }
            } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
                [HELPER endLoadingToView:WINDOW];
            }];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:delete];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)arrayComment
{
    if (!_arrayComment) {
        _arrayComment = [NSMutableArray array];
    }
    return _arrayComment;
}

@end
