//
//  ShopAllViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/27.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopAllViewController.h"
#import "ShopAllCell.h"

@interface ShopAllViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@end

@implementation ShopAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
}

- (void)configureCollectionView {
    self.myCollectionView.backgroundColor = GMBgColor;
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopAllCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ShopAllCell class])];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopAllCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ShopAllCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2 - 5, 260);
}

@end
