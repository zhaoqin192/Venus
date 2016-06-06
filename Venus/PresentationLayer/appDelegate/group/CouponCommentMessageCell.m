//
//  CouponCommentMessageCell.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentMessageCell.h"
#import "CouponCommentImageCollectionCell.h"

@interface CouponCommentMessageCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property (nonatomic, assign) CGFloat cellSize;

@end

@implementation CouponCommentMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.cellSize = 80.0 / 375 * kScreenWidth;
    
}

- (void)textViewDidChange:(UITextView *)textView {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"contentChanged" object:nil userInfo:@{@"content": self.textView.text}];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageArray.count < 8) {
        return self.imageArray.count + 1;
    }
    else {
        return 8;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCommentImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CouponCommentImageCollectionCell className] forIndexPath:indexPath];
    if (indexPath.item == self.imageArray.count && self.imageArray.count < 8) {
        [cell.imageButton setImage:[UIImage imageNamed:@"addPicture"] forState:UIControlStateNormal];
        
        cell.isAdd = YES;
    }
    else {
        [cell.imageButton setImage:[self.imageArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        cell.isAdd = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cellSize, self.cellSize);
}


@end
