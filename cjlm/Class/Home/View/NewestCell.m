//
//  NewestCell.m
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#define kImageWidth    (SCREEN_WIDTH - 2*ScaleX(15) - 2*ScaleX(8))/3

#import "NewestCell.h"
#import "PersonalHomeController.h"
#import "TriangleView.h"

@implementation NewestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellAddData
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    
    //头像
    UIImageView *avatar = [HELPER imageViewWithSuperView:self.contentView backgroundColor:COLOR(clearColor) image:IMG(@"avatar_default_logined") andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@16);
        make.top.equalTo(@22);
    }];
    [self.contentView layoutIfNeeded];
    [HELPER addSpecifiedRoundedCornersToView:avatar withCornerType:UIRectCornerAllCorners withCornerRadii:CGSizeMake(20, 20) borderWidth:0 borderColor:nil];
//    [avatar sd_setImageWithURL:[NSURL URLWithString:@"https://xinlikj.oss-cn-shanghai.aliyuncs.com/youni/logo1564637889577.jpg"]];//赋值
    avatar.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPersonalHomepage)]];
    
    //昵称
    UILabel *lblNickName = [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:model.nickname textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:14 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.top.equalTo(avatar.mas_top).offset(2);
        make.left.equalTo(avatar.mas_right).offset(12);
    }];
    lblNickName.userInteractionEnabled = YES;
    [lblNickName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPersonalHomepage)]];
    
    //发布时间
    NSString *pubdate = [HELPER timestampConversion:10 timestamp:model.create_date];
    if ([[[HELPER getCurrentDateString] componentsSeparatedByString:@" "][0] isEqualToString:[pubdate componentsSeparatedByString:@" "][0]]) {//当天时间
        pubdate = [pubdate componentsSeparatedByString:@" "][1];
    }else{
        pubdate = [pubdate componentsSeparatedByString:@" "][0];
    }
    [HELPER labelWithSuperView:self.contentView backgroundColor:COLOR(clearColor) text:pubdate textAlignment:NSTextAlignmentRight textColor:RGBOF(0x9e9e9e) fontSize:12 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(lblNickName.mas_centerY);
        make.right.equalTo(@-20);
    }];
    
    //正文
    _textLbl = [[TYAttributedLabel alloc] initWithFrame:FRAME(ScaleX(16), avatar.mj_bottom+12, SCREEN_WIDTH-ScaleX(32), 0)];
    _textLbl.font = FONT(14);
    _textLbl.text = model.message_fmt;//赋值
    _textLbl.backgroundColor = COLOR(clearColor);
    _textLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLbl.textColor = SUBTITLE_BLACK;
    [self.contentView addSubview:_textLbl];
    //获取文本的原始高度
    [_textLbl sizeToFit];
    CGFloat heightOriginal = _textLbl.mj_h;
    //文本最初最多只显示3行
    _textLbl.numberOfLines = 3;
    [_textLbl sizeToFit];
    
    if (heightOriginal > _textLbl.mj_h) {//文本多于3行
        //展开全文 按钮
        _btnShowFullText = [HELPER buttonWithSuperView:self.contentView andNormalTitle:@"展开全文" andNormalTextColor:RGBOF(0x3c8cd6) andTextFont:13 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(showFullText:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        _btnShowFullText.frame = FRAME(_textLbl.mj_x, _textLbl.mj_bottom+3, 80, 20);
        _btnShowFullText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //展开全文 与 收起 互换
        if (model.isFullTextShown == YES) {
            _textLbl.numberOfLines = 0;
            [_textLbl sizeToFit];
            
            _btnShowFullText.mj_y = _textLbl.mj_bottom+3;
            [_btnShowFullText setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            _textLbl.numberOfLines = 3;
            
            [_btnShowFullText setTitle:@"展开全文" forState:UIControlStateNormal];
        }
    }
    
    
    
    CGFloat y;
    if ([HELPER isZeroLengthWithString:model.message_fmt]) {//没有正文
        y = avatar.mj_bottom+13;
    }else{
        if (heightOriginal > _textLbl.mj_h) {//文本多于3行
            y = _btnShowFullText.mj_bottom + 10;
        }else{
            y = _textLbl.mj_bottom + 10;
        }
    }
    
    if (model.isFullTextShown == YES) {//文本展开时
        y = _btnShowFullText.mj_bottom + 10;
    }
    for (NSInteger i = 0; i < model.file_url.count; i ++) {
        NSInteger row = i/3;
        NSInteger column = i%3;
        //图片
        UIImageView *imageView = [HELPER imageViewWithSuperView:self.contentView backgroundColor:COLOR(clearColor) image:nil andMasonryBlock:nil];
        imageView.frame = FRAME(ScaleX(15) + (kImageWidth+ScaleX(8))*column, y + (kImageWidth+ScaleX(8))*row, kImageWidth, kImageWidth);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMAGE_PATH,model.file_url[i][@"file_url"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMG(@"icon_placeholder")];//赋值
        if (i == model.file_url.count-1) {
            y = imageView.mj_bottom + 10;
        }
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = 500 + i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)]];
        [self.arrayimgView addObject:imageView];
        [self.arrayImgUrl addObject:urlStr];
    }
    
    // 标签
//    NSArray *labelArray = @[@"地下城与勇士",@"魔兽世界",@"穿越火线",@"冰封王座",@"英雄无敌3死亡阴影",@"传奇",@"帝国",@"红警三之尤里的复仇"];
//
//    CGFloat labelX = ScaleX(15);
//    for (NSInteger i = 0; i < labelArray.count; i ++) {
//        NSString *label = [NSString stringWithFormat:@"#%@#",labelArray[i]];
//        CGSize size = [HELPER sizeForString:label fontOfSize:14 contentWidth:SCREEN_WIDTH bold:NO paragraphStyle:nil];
//        CGFloat buttonWidth = size.width+10;
//        CGFloat buttonHeight = size.height;
//
//        if (labelX + buttonWidth + ScaleX(15) > SCREEN_WIDTH) {
//            labelX = 15;
//            y += buttonHeight + 8;
//        }
//
//        UIButton *button = [HELPER buttonWithSuperView:self.contentView andNormalTitle:label andNormalTextColor:COLOR(redColor) andTextFont:14 andNormalImage:nil backgroundColor:COLOR(blueColor) addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
//        button.frame = FRAME(labelX, y, buttonWidth, buttonHeight);
//
//        if (labelX + buttonWidth + ScaleX(15) <= SCREEN_WIDTH) {
//            labelX += buttonWidth + 5;
//        }
//
//        if (i == labelArray.count - 1) {
//            y += buttonHeight + 10;
//        }
//    }
    
    //分割线
    UIImageView *splitLine = [HELPER imageViewWithSuperView:self.contentView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
        make.top.equalTo(@(y));
    }];
    
    //点赞 按钮
    UIButton *btnLike = [HELPER buttonWithSuperView:self.contentView andNormalTitle:model.votes andNormalTextColor:SUBTITLE_BLACK andTextFont:12 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(giveLike:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(53)));
        make.top.equalTo(splitLine.mas_bottom).offset(5);
        make.height.equalTo(@30);
    }];
    if ([[NSString stringWithFormat:@"%@",model.vote_status] isEqualToString:@"0"]) {// 未点赞状态
        [btnLike setImage:IMG(@"like_btn_normal") forState:UIControlStateNormal];
    }else  if ([[NSString stringWithFormat:@"%@",model.vote_status] isEqualToString:@"1"]) {// 已点赞状态
        [btnLike setImage:IMG(@"like_btn_select") forState:UIControlStateNormal];
    }
    //未登录状态下
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
        [btnLike setImage:IMG(@"like_btn_normal") forState:UIControlStateNormal];
    }
    
    //评论 按钮
    UIButton *buttonComment = [HELPER buttonWithSuperView:self.contentView andNormalTitle:[NSString stringWithFormat:@"评论(%lu)",(unsigned long)model.comment.count] andNormalTextColor:TITLE_BLACK andTextFont:12 andNormalImage:IMG(@"icon_comment") backgroundColor:COLOR(clearColor) addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(btnLike.mas_right).offset(ScaleX(64));
        make.centerY.equalTo(btnLike.mas_centerY);
        make.height.equalTo(@30);
    }];
    
    //更多 按钮
    [HELPER buttonWithSuperView:self.contentView andNormalTitle:nil andNormalTextColor:COLOR(clearColor) andTextFont:0 andNormalImage:IMG(@"icon_more") backgroundColor:COLOR(clearColor) addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.right.equalTo(@(-ScaleX(15)));
        make.centerY.equalTo(btnLike.mas_centerY);
        make.height.equalTo(@30);
    }];
    
#pragma mark - 评论部分
    [self.contentView layoutIfNeeded];
    TYAttributedLabel *lblComments = [[TYAttributedLabel alloc] initWithFrame:CGRectIntegral(FRAME(ScaleX(16), btnLike.mj_bottom+15, SCREEN_WIDTH - 2*ScaleX(16), 0))];
    lblComments.linesSpacing = 0;
    [self.contentView addSubview:lblComments];
    
    NSArray *colorArray = @[RGBOF(0xf8f8f8),RGBOF(0xf5f3f3)];
    for (NSInteger i = 0; i < (model.comment.count>4 ? 4 : model.comment.count); i ++) {
        // 属性文本生成器
        TYTextContainer *textContainer = [[TYTextContainer alloc]init];
        textContainer.text = [NSString stringWithFormat:@"%@：%@",model.comment[i][@"nickname"],model.comment[i][@"message_fmt"]];
        textContainer.textAlignment = NSTextAlignmentLeft;
        textContainer.textColor = RGBOF(0x666666);
        textContainer.font = FONT(13);
        textContainer.numberOfLines = 1;
        textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        // 评论用户名染成蓝色
        TYLinkTextStorage *linkTextStorage = [[TYLinkTextStorage alloc]init];
        linkTextStorage.range = NSMakeRange(0, [model.comment[i][@"nickname"] length]);
        linkTextStorage.textColor = RGBOF(0x3c8cd6);
        linkTextStorage.linkData = model.comment[i][@"nickname"];
        linkTextStorage.underLineStyle = kCTUnderlineStyleNone;//取消下划线
        [textContainer addTextStorage:linkTextStorage];
        CGSize sizeRange = [HELPER sizeForString:model.comment[i][@"nickname"] fontOfSize:13 contentWidth:SCREEN_WIDTH bold:NO paragraphStyle:nil];
        // 每条评论
        TYAttributedLabel *lblEachComment = [[TYAttributedLabel alloc] initWithFrame:FRAME(0, 0, lblComments.mj_w, 28)];
        lblEachComment.verticalAlignment = TYVerticalAlignmentCenter;
        lblEachComment.delegate = self;
        lblEachComment.backgroundColor = colorArray[i%2];
        lblEachComment.textContainer = textContainer;
        lblEachComment.userInteractionEnabled = YES;
        [HELPER buttonWithSuperView:lblEachComment andNormalTitle:nil andNormalTextColor:COLOR(clearColor) andTextFont:0 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(handleComment:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@(sizeRange.width));
            make.width.equalTo(@(lblComments.mj_w-sizeRange.width));
        }].tag = 600 + i;
        // 追加每条评论
        [lblComments appendView:lblEachComment];
    }
    //查看全部 按钮
    if (model.comment.count > 4) {
        _btnSeeAll = [HELPER buttonWithSuperView:nil andNormalTitle:@"查看全部" andNormalTextColor:RGBOF(0x3c8cd6) andTextFont:13 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:@selector(toCheckAllComments) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        _btnSeeAll.frame = FRAME(0, 0, 60, 20);
        _btnSeeAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [lblComments appendView:_btnSeeAll];
    }
    [lblComments sizeToFit];
    //评论上方的三角形箭头
    if (model.comment.count > 0) {
        TriangleView *triangle = [[TriangleView alloc] initWithColor:RGBOF(0xf8f8f8) style:triangleViewIsoscelesTop];
        [self.contentView addSubview:triangle];
        [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 10));
            make.bottom.equalTo(lblComments.mas_top);
            make.centerX.equalTo(buttonComment.mas_centerX);
        }];
    }
    
    //底部分割线
    [HELPER imageViewWithSuperView:self.contentView backgroundColor:RGBOF(0xfbfbfb) image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@10);
    }];
}


#pragma mark - 点击头像和昵称跳转到个人主页
- (void)jumpToPersonalHomepage
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (self.jumpToPersonalHomepageBlock) {
        self.jumpToPersonalHomepageBlock(model);
    }
}


#pragma mark - 展开全文事件
- (void)showFullText:(UIButton *)sender
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (model.isFullTextShown == NO) {
        model.isFullTextShown = YES;
    }else{
        model.isFullTextShown = NO;
    }
    
    if (self.blockShowFullText) {
        self.blockShowFullText(model);
    }
}


#pragma mark - 点击查看图片
- (void)tapOnImageView:(UITapGestureRecognizer *)tapGes
{
    if (self.checkImageBlock) {
        self.checkImageBlock(self.arrayImgUrl.copy, self.arrayimgView.copy, tapGes.view.tag-500);
    }
}


#pragma mark - 操作评论
- (void)handleComment:(UIButton *)sender
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    NSString *uid = model.comment[sender.tag - 600][@"uid"];
    NSString *cid = model.comment[sender.tag - 600][@"cid"];
    if (self.handleCommentBlock) {
        self.handleCommentBlock(model, cid, uid);
    }
}


#pragma mark - 点击更多
- (void)moreAction:(UIButton *)sender
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (self.checkMoreBlock) {
        self.checkMoreBlock(model);
    }
}


#pragma mark - 查看全部事件
- (void)toCheckAllComments
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (self.seeAllCommentsBlock) {
        self.seeAllCommentsBlock(model);
    }
}


#pragma mark - 评论事件
- (void)comment
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (self.commentBlock) {
        self.commentBlock(model);
    }
}


#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    
    BaseViewController *currentVC = (BaseViewController *)[self mj_superViewController];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
        [currentVC needAccountForLogin];
        return;
    }
    
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        id linkStr = ((TYLinkTextStorage*)textStorage).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            NSString *uid;
            for (NSDictionary *dict in model.comment) {
                if ([dict[@"nickname"] isEqualToString:linkStr]) {
                    uid = dict[@"uid"];
                    break;
                }
            }
            PersonalHomeController *personalHomeVC = [PersonalHomeController new];
            personalHomeVC.ID = uid;
            personalHomeVC.nickname = linkStr;
            personalHomeVC.hidesBottomBarWhenPushed = YES;
            [currentVC.navigationController pushViewController:personalHomeVC animated:YES];
        }
    }
}


#pragma mark - 点赞/取消点赞
- (void)giveLike:(UIButton *)sender
{
    BaseViewController *currentVC = (BaseViewController *)[self mj_superViewController];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"] == NO) {
        [currentVC needAccountForLogin];
        return ;
    }
    
    NewestModel *model = self.arrayNewest[self.dataIndexPath.row];
    if (self.giveLikeBlock) {
        self.giveLikeBlock(model);
    }
}


#pragma mark - Lazy Load
- (NSMutableArray *)arrayImgUrl
{
    if (!_arrayImgUrl) {
        _arrayImgUrl = [NSMutableArray array];
    }
    return _arrayImgUrl;
}

- (NSMutableArray *)arrayimgView
{
    if (!_arrayimgView) {
        _arrayimgView = [NSMutableArray array];
    }
    return _arrayimgView;
}

@end
