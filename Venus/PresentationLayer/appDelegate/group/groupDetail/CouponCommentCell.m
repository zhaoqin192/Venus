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

@property (nonatomic, assign) CGFloat superWidth;

@end

@implementation CouponCommentCell


- (void)awakeFromNib {
    
//    self.collection.delegate = self;
//    self.collection.dataSource = self;
    
//    self.superWidth = (self.collection.width - 20) / 3;
    
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row]]];
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.superWidth, self.superWidth);
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collection clicked");
}

- (void)updateCollection {
    
    NSArray *array = [self.imageArray copy];
    
    [self.imageArray insertObjects:array atIndex:0];
    [self.imageArray insertObjects:array atIndex:0];
    [self.imageArray insertObjects:array atIndex:0];
    [self.imageArray insertObjects:array atIndex:0];
    [self.imageArray insertObjects:array atIndex:0];
    
}



@end
