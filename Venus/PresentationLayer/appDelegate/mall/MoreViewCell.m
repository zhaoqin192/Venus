//
//  MoreViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "MoreViewCell.h"
#import "MoreCollectionViewCell.h"
#import "MallKindModel.h"

@interface MoreViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.moreArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MallKindModel *model = [self.moreArray objectAtIndex:indexPath.row];
    
    MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MoreCollectionViewCell className] forIndexPath:indexPath];
    
    cell.title.text = model.name;
    
    return cell;
    
}

@end
