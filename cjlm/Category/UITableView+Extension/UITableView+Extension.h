//
//  UITableView+Extension.h
//  yzw
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 瑀 韦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extension)

- (void)tableViewShowMessage:(NSString *)message forDataCount:(NSUInteger)dataCount;

- (void)tableViewShowImage:(UIImage *)image withMessage:(NSString *)message withStyle:(NSInteger)style forDataCount:(NSUInteger)dataCount;

@end

NS_ASSUME_NONNULL_END
