//
//  NewestFrameModel.h
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewestFrameModel : NSObject

@property (nonatomic,strong) NewestModel *newestModel;

@property (nonatomic,assign,readonly) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
