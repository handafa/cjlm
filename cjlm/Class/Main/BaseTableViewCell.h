//
//  BaseTableViewCell.h
//  Ruijin
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *dataIndexPath;

-(void)cellAddData;

@end

NS_ASSUME_NONNULL_END
