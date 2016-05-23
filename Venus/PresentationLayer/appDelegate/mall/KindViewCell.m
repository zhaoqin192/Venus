//
//  KindViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "KindViewCell.h"
#import "KindCollectionViewCell.h"
#import "MallKindModel.h"

@interface KindViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation KindViewCell

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


#pragma mark -UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.kindArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MallKindModel *model = [self.kindArray objectAtIndex:indexPath.row];
    
    KindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KindCollectionViewCell className] forIndexPath:indexPath];
    
    cell.name.text = model.name;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    
    return cell;
}




@end
