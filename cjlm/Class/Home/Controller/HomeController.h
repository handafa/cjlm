//
//  HomeController.h
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeController : BaseViewController <SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@property (nonatomic,strong) NSMutableArray *childArray;

@end

NS_ASSUME_NONNULL_END
