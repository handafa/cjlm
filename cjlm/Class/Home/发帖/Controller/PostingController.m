//
//  PostingController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "PostingController.h"
#import "PostingCell.h"
#import "PostHeaderView.h"
#import "AddNewTagView.h"

@interface PostingController ()

@property (nonatomic,assign) CGFloat photoViewHeight;

@property (nonatomic,copy) NSString *publishContent;// 发布内容

@property (nonatomic,copy) NSArray *arrayPhotos;// 图片数组

@property (nonatomic,strong) TYAttributedLabel *postBottomView;

@property (nonatomic,strong) AddNewTagView *addNewTagView;

@end

@implementation PostingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleViewTitle:@"发帖"];
    [self setLeftBackButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btnNavRight = [HELPER buttonWithSuperView:nil andNormalTitle:@"发布" andNormalTextColor:THEME_RED andTextFont:17 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        btnNavRight;
    })];
    
    [self initUI];
}

- (void)publish
{
    if (self.arrayPhotos.count == 0 && [HELPER isZeroLengthWithString:self.publishContent]) {
        [HELPER showInfoHUDWithMessage:@"无发布内容"];
        return;
    }
    
    if ([HELPER whetherEmojisAreIncluded:self.publishContent] == YES) {
        [HELPER showInfoHUDWithMessage:@"发布内容不可带有表情符号"];
        return;
    }
    
    [HELPER loadingHUD:@"" toView:WINDOW];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[HELPER obtainUserInfo].uid forKey:@"uid"];
    [param setObject:[HELPER obtainUserInfo].token forKey:@"authToken"];
    [HomeService postingWithParam:param contentText:[WordFilterHelper.shared filter:self.publishContent] fileArray:self.arrayPhotos success:^(id  _Nonnull returnData, NSInteger responseCode) {
        LOG(@"🐷%@",returnData);
        [HELPER endLoadingToView:WINDOW];
        
        if ([[NSString stringWithFormat:@"%@", returnData[@"code"]] isEqualToString:@"200"]) {
            [HELPER showSuccessHUDWithMessage:@"发布成功！"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirstLevelPageListNotification object:nil];// 发送该通知是为了刷新首页数据
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HELPER showErrorHUDWithMessage:@"发布失败"];
        }
    } fail:^(NSError * _Nonnull error, NSInteger responseCode) {
        [HELPER endLoadingToView:WINDOW];
    }];
}

- (void)initUI
{
    self.mainTableView = [self tableViewWithSuperView:self.view style:UITableViewStylePlain backgroundColor:COLOR(clearColor) target:self andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view);
    }];
    WEAKSELF
    PostHeaderView *headerView = [[PostHeaderView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 125)];
    self.mainTableView.tableHeaderView = headerView;
    // 发布内容
    headerView.editContentBlock = ^(NSString * _Nonnull publishContent) {
        weakSelf.publishContent = publishContent;
    };
    
    [self setupTableFooterView];
}

#pragma mark - 设置tableFooterView
- (void)setupTableFooterView
{
    WEAKSELF
    self.postBottomView = [[TYAttributedLabel alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 0)];
    
    self.addNewTagView = [[AddNewTagView alloc] initWithFrame:FRAME(0, 0, SCREEN_WIDTH, 54)];
    [self.postBottomView appendView:self.addNewTagView];
    // 添加标签后高度的变化
    self.addNewTagView.labelViewHeightChangeBlock = ^(CGFloat value) {
        weakSelf.addNewTagView.mj_h+=value;
        weakSelf.postBottomView.mj_h+=value;
        
        [weakSelf.mainTableView reloadData];
    };
    
    [self.postBottomView sizeToFit];
    self.mainTableView.tableFooterView = self.postBottomView;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"postingCell";
    PostingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostingCell" owner:nil options:nil] firstObject];
    }else{
        if (cell.contentView.subviews) {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
    }
    cell.dataIndexPath = indexPath;
    [cell cellAddData];
    
    WEAKSELF
    // 选择照片后cell高度的变化
    cell.photoViewChangeHeightBlock = ^(CGFloat height) {
        weakSelf.photoViewHeight = height + 24;
        [weakSelf.mainTableView reloadData];
    };
    
    // 添加图片
    cell.photoViewAddPhotoBlock = ^(NSArray * _Nonnull photos) {
        weakSelf.arrayPhotos = photos;
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.photoViewHeight;
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


@end
