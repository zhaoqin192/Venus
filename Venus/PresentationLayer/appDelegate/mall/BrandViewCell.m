//
//  BrandViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandViewCell.h"
#import "BrandCollectionViewCell.h"
#import "MallBrandModel.h"

@interface BrandViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation BrandViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.brandArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MallBrandModel *model = [self.brandArray objectAtIndex:indexPath.row];
    
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BrandCollectionViewCell className] forIndexPath:indexPath];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBrandView" object:self userInfo:@{@"brandModel": [self.brandArray objectAtIndex:indexPath.item]}];
    
}

@end
