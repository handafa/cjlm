//
//  HomeController.m
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "HomeController.h"
#import "NewestController.h"
#import "PostingController.h"

@interface HomeController () 

//发布button
@property (nonatomic,strong) UIButton *postButton;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI
{
    NSArray *titles = @[@"最新", @"关注"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleColor = TITLE_BLACK;
    configure.indicatorColor = [RGBOF(0xff9386) colorWithAlphaComponent:0.6];
    configure.indicatorHeight = 6;
    configure.indicatorCornerRadius = 3;
    configure.indicatorToBottomDistance = 9;
    configure.titleSelectedFont = [UIFont boldSystemFontOfSize:20];
    configure.titleFont = FONT(17);
    configure.titleSelectedColor = TITLE_BLACK;
    configure.titleColor = RGBOF(0x666666);
    configure.showBottomSeparator = NO;
    configure.bounces = NO;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, STATUS_BAR_HEIGHT+ScaleY(20), 150, 46) delegate:self titleNames:titles configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    _childArray = [NSMutableArray new];
    // 最新
    NewestController *newestVC = [NewestController new];
    newestVC.homeVCType = 0;
    // 关注
    NewestController *focusVC = [NewestController new];
    focusVC.homeVCType = 1;
    
    [_childArray addObject:newestVC];
    [_childArray addObject:focusVC];
    CGFloat contentViewHeight = SCREEN_HEIGHT - TABBAR_HEIGHT - self.pageTitleView.mj_bottom;
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, self.pageTitleView.mj_bottom, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:_childArray];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    [HELPER imageViewWithSuperView:self.view backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(@0);
        make.top.equalTo(self.pageTitleView.mas_bottom);
    }];
    
    self.postButton.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentScrollViewDelegate
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)postButton
{
    if (!_postButton) {
        _postButton = [HELPER buttonWithSuperView:self.view andNormalTitle:nil andNormalTextColor:COLOR(clearColor) andTextFont:0 andNormalImage:IMG(@"icon_post") backgroundColor:COLOR(clearColor) addTarget:self action:@selector(toPost) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.right.equalTo(@(-ScaleX(12)));
            make.bottom.equalTo(@(-TABBAR_HEIGHT-18));
        }];
        _postButton.layer.cornerRadius = 25;
    }
    return _postButton;
}

- (void)toPost
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
        [self needAccountForLogin];
        return ;
    }
    
    PostingController *postingVC = [PostingController new];
    postingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postingVC animated:YES];
}
                                  

@end
