//
//  CouponCommentCell.m
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentCell.h"
#import "ImageCollectionViewCell.h"

@interface CouponCommentCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGFloat cellSize;
@end

@implementation CouponCommentCell

- (void)awakeFromNib {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.cellSize = 56.0 / 375 * kScreenWidth;
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    self.avatarImage.layer.masksToBounds = YES;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageCollectionViewCell className] forIndexPath:indexPath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cellSize, self.cellSize);
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collection clicked");
}


@end
