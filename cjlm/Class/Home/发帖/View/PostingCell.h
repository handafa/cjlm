//
//  PostingCell.h
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostingCell : BaseTableViewCell <HXPhotoViewDelegate>

@property (nonatomic,copy) void(^photoViewChangeHeightBlock)(CGFloat height);

@property (nonatomic,copy) void(^photoViewAddPhotoBlock)(NSArray *photos);// 添加图片

@end

NS_ASSUME_NONNULL_END
