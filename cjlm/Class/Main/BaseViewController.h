//
//  BaseViewController.h
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshBlock)(void);

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UICollectionView *mainCollectionView;

@property (nonatomic,strong) MJRefreshNormalHeader *refreshNormalHeader;

@property (nonatomic,strong) MJRefreshBackNormalFooter *backNormalFooter;

@property (nonatomic,assign) int page;// 分页

/**
 设置tabBarItem
 */
- (void)setTabBarItemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title;

/**
 设置titleView的文字
 */
- (void)setTitleViewTitle:(NSString *)title;

/**
 设置leftBarButtonItem为返回按钮
 */
- (void)setLeftBackButton;

/**
 创建UITableView
 */
- (UITableView *)tableViewWithSuperView:(nullable UIView *)superView style:(UITableViewStyle)style backgroundColor:(UIColor *)bgColor target:(nullable id)target andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 创建UICollectionView
 */
- (UICollectionView *)collectionViewWithSuperView:(nullable UIView *)superView flowLayout:(UICollectionViewFlowLayout *)flowLayout backgroundColor:(UIColor *)bgColor target:(nullable id)target andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 创建WKWebView
 */
- (WKWebView *)WKWebViewWithSuperView:(nullable UIView *)superView requestURLStr:(NSString *)requestStr target:(nullable id)target andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
需要登录帐户
*/
- (void)needAccountForLogin;


#pragma mark - 上下拉刷新
/**
 下拉刷新的回调
 */
- (void)setTableRefreshHeaderWithTableView:(UITableView *)tableView refreshBlock:(RefreshBlock)refreshBlock;

/**
 上拉刷新的回调
 */
- (void)setTableRefreshFooterWithTableView:(UITableView *)tableView refreshBlock:(RefreshBlock)refreshBlock;


@end

NS_ASSUME_NONNULL_END
