//
//  BaseCollectionViewCell.h
//  Ruijin
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018 瑀 韦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath *dataIndexPath;

-(void)itemAddData;

@end

NS_ASSUME_NONNULL_END
