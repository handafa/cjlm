//
//  PostingCell.m
//  Project
//
//  Created by 韦瑀 on 2019/11/13.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "PostingCell.h"

@interface PostingCell ()

@property (nonatomic,strong) HXPhotoView *photoView;
@property (nonatomic,strong) HXPhotoManager *photoManager;

@end

@implementation PostingCell

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
    [self.contentView addSubview:self.photoView];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    if (photoView != self.photoView) {
        return;
    }
    
    if (self.photoViewChangeHeightBlock) {
        self.photoViewChangeHeightBlock(frame.size.height);
    }
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal
{
    if (self.photoViewAddPhotoBlock) {
        self.photoViewAddPhotoBlock(photos);
    }
}

#pragma mark - Lazy Load
- (HXPhotoView *)photoView
{
    if (!_photoView) {
        _photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH - 24, 0) manager:self.photoManager];
        _photoView.spacing = 6;
        _photoView.previewStyle = HXPhotoViewPreViewShowStyleDefault;
        _photoView.collectionView.editEnabled = YES;
        _photoView.hideDeleteButton = NO;
        _photoView.showAddCell = YES;
        _photoView.delegate = self;
    }
    return _photoView;
}

- (HXPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.movableCropBox = YES;
    }
    return _photoManager;
}

@end
