//
//  PersonalHomeHeaderView.h
//  cjlm
//
//  Created by 韦瑀 on 2019/11/21.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalHomeHeaderView : UIView

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *nicknameString;

@property (nonatomic,copy) NSString *follow_count;

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UIImageView *avatar;

@property (nonatomic,strong) UILabel *labelFollowNumber;

@property (nonatomic,strong) UILabel *nicknameLabel;

@end

NS_ASSUME_NONNULL_END
