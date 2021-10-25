//
//  BaseTableViewHeaderFooterView.h
//  Project
//
//  Created by 韦瑀 on 2019/11/14.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewHeaderFooterView : UIView

@property (nonatomic,assign) NSInteger dataSection;

- (void)headerFooterViewAddData;

@end

NS_ASSUME_NONNULL_END
