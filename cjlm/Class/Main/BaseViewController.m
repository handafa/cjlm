//
//  BaseViewController.m
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


/**
 设置tabBarItem
 */
- (void)setTabBarItemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [UIImage imageNamed:selectedImageName];
    selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImg];
    //设置tabBarItem文字未选中时的颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGBOF(0x999999);
    [self.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //设置tabBarItem文字选中时的颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = RGBOF(0xf7604d);
    [self.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
}

/**
 设置titleView的文字
 */
- (void)setTitleViewTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScaleX(180), 44)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TITLE_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
}

/**
 设置leftBarButtonItem为返回按钮
 */
- (void)setLeftBackButton
{
    UIButton *leftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 18)];
    leftBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBackBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackBtn];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 创建UITableView
 */
- (UITableView *)tableViewWithSuperView:(UIView *)superView style:(UITableViewStyle)style backgroundColor:(UIColor *)bgColor target:(id)target andMasonryBlock:(MasonryBlock)masonryBlock
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tableView.backgroundColor = bgColor;
    tableView.delegate = target;
    tableView.dataSource = target;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    [superView addSubview:tableView];
    
    if (masonryBlock) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return tableView;
}

/**
 创建UICollectionView
 */
- (UICollectionView *)collectionViewWithSuperView:(UIView *)superView flowLayout:(UICollectionViewFlowLayout *)flowLayout backgroundColor:(UIColor *)bgColor target:(id)target andMasonryBlock:(MasonryBlock)masonryBlock
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = bgColor;
    collectionView.delegate = target;
    collectionView.dataSource = target;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    [superView addSubview:collectionView];
    
    if (masonryBlock) {
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return collectionView;
}

/**
创建WKWebView
*/
- (WKWebView *)WKWebViewWithSuperView:(UIView *)superView requestURLStr:(NSString *)requestStr target:(id)target andMasonryBlock:(MasonryBlock)masonryBlock
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.allowsBackForwardNavigationGestures = YES;//开启了支持滑动返回
    webView.scrollView.bounces = NO;
    webView.UIDelegate = target;
    webView.navigationDelegate = target;
    
    NSURL *url = [NSURL URLWithString:requestStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [superView addSubview:webView];
    if (masonryBlock) {
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    return webView;
}

/**
需要登录帐户
*/
- (void)needAccountForLogin
{
    TabBarController *tabBarVC = (TabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    LoginController *loginVC = [LoginController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [tabBarVC presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 上下拉刷新
/**
 下拉刷新的回调
 */
- (void)setTableRefreshHeaderWithTableView:(UITableView *)tableView refreshBlock:(RefreshBlock)refreshBlock
{
    self.refreshNormalHeader = [[MJRefreshNormalHeader alloc] init];
    self.refreshNormalHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.refreshNormalHeader setTitle:@"下拉刷新到最新" forState:MJRefreshStateIdle];
    tableView.mj_header = self.refreshNormalHeader;
    [self.refreshNormalHeader setRefreshingBlock:refreshBlock];
}

/**
 上拉刷新的回调
 */
- (void)setTableRefreshFooterWithTableView:(UITableView *)tableView refreshBlock:(RefreshBlock)refreshBlock
{
    self.backNormalFooter = [[MJRefreshBackNormalFooter alloc] init];
    tableView.mj_footer = self.backNormalFooter;
    [self.backNormalFooter setRefreshingBlock:refreshBlock];
}


- (void)dealloc
{
    LOG(@"♻️控制器释放了");
}


@end
