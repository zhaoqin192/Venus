//
//  SearchHotTableViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/29/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "SearchHotTableViewCell.h"
#import "SearchHotCollectionViewCell.h"

@interface SearchHotTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *hotArray;

@end

@implementation SearchHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.hotArray = [NSArray arrayWithObjects:@"特惠套餐", @"双人餐", @"女装", @"男装", @"火锅", nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.hotArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHotCollectionViewCell" forIndexPath:indexPath];
    [cell.titleLabel setTitle:[self.hotArray objectAtIndex:indexPath.item]  forState:UIControlStateNormal];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 100.0f / 375 * kScreenWidth;
    CGFloat height = 30.0f / 667 * kScreenHeight;
    return CGSizeMake(width, height);
    
}

@end
