//
//  AddNewTagView.m
//  cjlm
//
//  Created by 韦瑀 on 2019/12/23.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "AddNewTagView.h"

@implementation AddNewTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 顶部分割线
    [HELPER imageViewWithSuperView:self backgroundColor:COLOR(groupTableViewBackgroundColor) image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@8);
        make.left.top.right.equalTo(@0);
    }];
    
    self.labelTextField = [HELPER textFieldWithSuperView:self textAlignment:NSTextAlignmentLeft fontSize:14 textColor:TITLE_BLACK backgroundColor:COLOR(clearColor) placeholder:@"请输入标签名（限3个，最多八个中文长度）" placeholderColor:PLACEHOLDER_COLOR placeholderFont:12 andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.left.equalTo(@(ScaleX(12)));
        make.top.equalTo(@18);
        make.right.equalTo(@(-ScaleX(80)));
        make.height.equalTo(@18);
    }];
    
    // 添加标签button
    [HELPER buttonWithSuperView:self andNormalTitle:@"添加" andNormalTextColor:COLOR(whiteColor) andTextFont:14 andNormalImage:nil backgroundColor:THEME_RED addTarget:self action:@selector(addNewTag) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(40, 25));
        make.centerY.equalTo(self.labelTextField.mas_centerY);
        make.right.equalTo(@(-ScaleX(12)));
    }].layer.cornerRadius = 4;
    // 分割线
    [HELPER imageViewWithSuperView:self backgroundColor:COLOR(groupTableViewBackgroundColor) image:nil andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
        make.height.equalTo(@8);
        make.left.right.equalTo(@0);
        make.top.equalTo(@48);
    }];
}

#pragma mark - 添加标签
- (void)addNewTag
{
    if ([HELPER isZeroLengthWithString:self.labelTextField.text] == YES) {
        [HELPER showInfoHUDWithMessage:@"标签名不能为空"];
        return;
    }
    
    if ([HELPER gaugeLengthWithString:self.labelTextField.text] > 16) {
        [HELPER showInfoHUDWithMessage:@"标签过长"];
        return;
    }
    
    if (self.labelArray.count == 3) {
        [HELPER showInfoHUDWithMessage:@"最多添加3个标签"];
        return;
    }
    
    [self.labelArray addObject:self.labelTextField.text];
    self.labelTextField.text = @"";
    
    [self setupLabelView];
}

- (void)setupLabelView
{
    if (self.labelView.subviews) {
        for (UIView *view in self.labelView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat x = ScaleX(12);
    CGFloat y = 8;
    for (NSInteger i = 0; i < self.labelArray.count; i++) {
        // 标签名
        NSString *tagName = self.labelArray[i];
        // 标签大小
        CGSize size = [HELPER sizeForString:tagName fontOfSize:14 contentWidth:SCREEN_WIDTH bold:NO paragraphStyle:nil];
        CGFloat width = size.width+15;
        CGFloat height = size.height+8;
        
        if (x + width + ScaleX(10) > SCREEN_WIDTH) {
            x = ScaleX(12);
            y += height + 8;
        }
        
        UILabel *label = [HELPER labelWithSuperView:self.labelView backgroundColor:COLOR(whiteColor) text:tagName textAlignment:NSTextAlignmentCenter textColor:RGBOF(0x999999) fontSize:14 numberOfLines:1 andMasonryBlock:nil];
        label.frame = FRAME(x, y, width, height);
        label.layer.borderColor = RGBOF(0xceced9).CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = height/2;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        label.tag = 100 + i;
        // 删除按钮
        UIButton *deleteButton = [HELPER buttonWithSuperView:self.labelView andNormalTitle:nil andNormalTextColor:COLOR(clearColor) andTextFont:0 andNormalImage:IMG(@"icon_delete") backgroundColor:COLOR(clearColor) addTarget:self action:@selector(removeTag:) forControlEvents:UIControlEventTouchUpInside andMasonryBlock:^(MASConstraintMaker * _Nonnull make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.equalTo(label.mas_right).offset(-5);
            make.centerY.equalTo(label.mas_top);
        }];
        deleteButton.tag = label.tag;
        
        if (x + width + ScaleX(10) <= SCREEN_WIDTH) {
            x += width+ScaleX(10);
        }
        
        if (i == self.labelArray.count - 1) {
            y += height + 8;
        }
    }
    
    if (self.labelArray.count == 0) {
        self.labelView.mj_h = 0;
    }else{
        self.labelView.mj_h = y;
    }
}

#pragma mark - 删除标签
- (void)removeTag:(UIButton *)sender
{
    [self.labelArray removeObjectAtIndex:sender.tag - 100];
    [self setupLabelView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect oldFrame = CGRectNull;
        CGRect newFrame = CGRectNull;

        oldFrame = [[change objectForKey:@"old"] CGRectValue];
        newFrame = [[change objectForKey:@"new"] CGRectValue];
        if (self.labelViewHeightChangeBlock) {
            self.labelViewHeightChangeBlock(newFrame.size.height - oldFrame.size.height);
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (UIView *)labelView
{
    if (!_labelView) {
        _labelView = [[UIView alloc] initWithFrame:FRAME(0, 56, SCREEN_WIDTH, 0)];
        _labelView.backgroundColor = COLOR(whiteColor);
        [self addSubview:_labelView];
        
        [_labelView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _labelView;
}


@end
