//
//  NewestFrameModel.m
//  Project
//
//  Created by 韦瑀 on 2019/11/12.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#define kImageWidth    (SCREEN_WIDTH - 2*ScaleX(15) - 2*ScaleX(8))/3

#import "NewestFrameModel.h"

@implementation NewestFrameModel

- (void)setNewestModel:(NewestModel *)newestModel
{
    _newestModel = newestModel;
    
    UIView *contentView = [UIView new];
    //头像
    UIImageView *avatar = [HELPER imageViewWithSuperView:contentView backgroundColor:COLOR(clearColor) image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@16);
        make.top.equalTo(@22);
    }];
    [contentView layoutIfNeeded];
    
    //昵称
    [HELPER labelWithSuperView:contentView backgroundColor:COLOR(clearColor) text:@"捕捉辉煌的瞬间" textAlignment:NSTextAlignmentLeft textColor:TITLE_BLACK fontSize:14 numberOfLines:1 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.top.equalTo(avatar.mas_top).offset(2);
        make.left.equalTo(avatar.mas_right).offset(12);
    }];
    
    //正文
    TYAttributedLabel *textLbl = [[TYAttributedLabel alloc] initWithFrame:FRAME(ScaleX(16), avatar.mj_bottom+12, SCREEN_WIDTH-ScaleX(32), 0)];
    textLbl.font = FONT(14);
    textLbl.text = newestModel.message_fmt;//赋值
    textLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    [contentView addSubview:textLbl];
    //获取文本的原始高度
    [textLbl sizeToFit];
    CGFloat heightOriginal = textLbl.mj_h;
    //文本最初最多只显示3行
    textLbl.numberOfLines = 3;
    [textLbl sizeToFit];
    
    UIButton *btnShowFullText;
    if (heightOriginal > textLbl.mj_h) {//文本多于3行
        //展开全文 按钮
        btnShowFullText = [HELPER buttonWithSuperView:contentView andNormalTitle:@"展开全文" andNormalTextColor:RGBOF(0x3c8cd6) andTextFont:0 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
        btnShowFullText.frame = FRAME(textLbl.mj_x, textLbl.mj_bottom+3, 80, 20);
        btnShowFullText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //展开全文 与 收起 互换
        if (newestModel.isFullTextShown == YES) {
            textLbl.numberOfLines = 0;
            [textLbl sizeToFit];
            
            btnShowFullText.mj_y = textLbl.mj_bottom+3;
        }else{
            textLbl.numberOfLines = 3;
        }
    }
    
    
    
    CGFloat y;
    if ([HELPER isZeroLengthWithString:newestModel.message_fmt]) {//没有正文
        y = avatar.mj_bottom+13;
    }else{
        if (heightOriginal > textLbl.mj_h) {//文本多于3行
            y = btnShowFullText.mj_bottom + 10;
        }else{
            y = textLbl.mj_bottom + 10;
        }
    }
    
    if (newestModel.isFullTextShown == YES) {//文本展开时
        y = btnShowFullText.mj_bottom + 10;
    }
    for (NSInteger i = 0; i < newestModel.file_url.count; i ++) {
        NSInteger row = i/3;
        NSInteger column = i%3;
        //图片
        UIImageView *imageView = [HELPER imageViewWithSuperView:contentView backgroundColor:COLOR(clearColor) image:nil andMasonryBlock:nil];
        imageView.frame = FRAME(ScaleX(15) + (kImageWidth+ScaleX(8))*column, y + (kImageWidth+ScaleX(8))*row, kImageWidth, kImageWidth);
        if (i == newestModel.file_url.count-1) {
            y = imageView.mj_bottom + 10;
        }
    }
    
        //分割线
        UIImageView *splitLine = [HELPER imageViewWithSuperView:contentView backgroundColor:SPLIT_COLOR image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@1);
            make.top.equalTo(@(y));
        }];
    
        //点赞 按钮
        UIButton *btnLike = [HELPER buttonWithSuperView:contentView andNormalTitle:newestModel.votes andNormalTextColor:COLOR(clearColor) andTextFont:12 andNormalImage:IMG(@"like_btn_normal") backgroundColor:COLOR(clearColor) addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.left.equalTo(@(ScaleX(53)));
            make.top.equalTo(splitLine.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];
        
        //评论部分
        [contentView layoutIfNeeded];
        TYAttributedLabel *lblComments = [[TYAttributedLabel alloc] initWithFrame:CGRectIntegral(FRAME(ScaleX(16), btnLike.mj_bottom+15, SCREEN_WIDTH - 2*ScaleX(16), 0))];
        lblComments.linesSpacing = 0;
        [contentView addSubview:lblComments];
        
        for (NSInteger i = 0; i < (newestModel.comment.count>4 ? 4 : newestModel.comment.count); i ++) {
            // 属性文本生成器
            TYTextContainer *textContainer = [[TYTextContainer alloc]init];
            textContainer.text = [NSString stringWithFormat:@"%@：%@",newestModel.comment[i][@"nickname"],newestModel.comment[i][@"message_fmt"]];
            textContainer.textAlignment = NSTextAlignmentLeft;
            textContainer.font = FONT(13);
            textContainer.numberOfLines = 1;
            textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            // 每条评论
            TYAttributedLabel *lblEachComment = [[TYAttributedLabel alloc] initWithFrame:FRAME(0, 0, lblComments.mj_w, 28)];
            lblEachComment.textContainer = textContainer;
            // 追加每条评论
            [lblComments appendView:lblEachComment];
        }
        //查看全部 按钮
        UIButton *btnSeeAll;
        if (newestModel.comment.count > 4) {
            btnSeeAll = [HELPER buttonWithSuperView:nil andNormalTitle:@"查看全部" andNormalTextColor:RGBOF(0x3c8cd6) andTextFont:0 andNormalImage:nil backgroundColor:COLOR(clearColor) addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside andMasonryBlock:nil];
            btnSeeAll.frame = FRAME(0, 0, 60, 20);
            btnSeeAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [lblComments appendView:btnSeeAll];
        }
    [lblComments sizeToFit];
    [contentView layoutIfNeeded];
    
    if (newestModel.comment.count > 0) {// 有评论时
        _cellHeight = lblComments.mj_bottom + 20;
    }else{// 无评论时
        _cellHeight = btnLike.mj_bottom + 20;
    }
}

@end
