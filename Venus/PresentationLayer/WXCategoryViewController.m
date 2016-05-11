//
//  WXCategoryViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXCategoryViewController.h"
#import "CategoryCell.h"

@interface WXCategoryViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *myCollectionView;
@end

@implementation WXCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部分类";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self configureNavigationBar];
    [self configureCollectionView];
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 10) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = GMBgColor;
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CategoryCell class])];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.view addSubview:self.myCollectionView];
}

- (void)configureNavigationBar {
    self.navigationController.navigationBar.barTintColor = GMRedColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = GMBrownColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:GMBrownColor};
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    else {
        return 10;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CategoryCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        reusableview = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    return reusableview;
}

@end
