//
//  NewestCell.h
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewestCell : BaseTableViewCell <TYAttributedLabelDelegate>

@property (nonatomic,strong) NSMutableArray *arrayNewest;

@property (nonatomic,copy) void(^jumpToPersonalHomepageBlock)(NewestModel *model);// 点击头像和昵称跳转到个人主页

@property (nonatomic,copy) void(^blockShowFullText)(NewestModel *model);//展开全文block

@property (nonatomic,copy) void(^checkImageBlock)(NSArray *imgUrls, NSArray *imageViews, NSInteger tag);//点击查看图片

@property (nonatomic,copy) void(^checkMoreBlock)(NewestModel *model);// 点击 更多 按钮

@property (nonatomic,copy) void(^seeAllCommentsBlock)(NewestModel *model);// 查看全部事件

@property (nonatomic,copy) void(^commentBlock)(NewestModel *model);// 评论事件

@property (nonatomic,copy) void(^handleCommentBlock)(NewestModel *model, NSString *cid, NSString *uid);// 操作评论

@property (nonatomic,copy) void(^giveLikeBlock)(NewestModel *model);// 点赞事件


///正文
@property (nonatomic,strong) TYAttributedLabel *textLbl;

///展开全文 按钮
@property (nonatomic,strong) UIButton *btnShowFullText;

///查看全部评论btn
@property (nonatomic,strong) UIButton *btnSeeAll;

@property (nonatomic,strong) NSMutableArray *arrayImgUrl;
@property (nonatomic,strong) NSMutableArray *arrayimgView;

@end

NS_ASSUME_NONNULL_END
