//
//  WXCategoryViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXCategoryViewController.h"
#import "CategoryCell.h"
#import "ReusableView.h"

@interface WXCategoryViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *myCollectionView;
@end

@implementation WXCategoryViewController

static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部分类";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureNavigationBar];
    [self configureCollectionView];
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 10) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CategoryCell class])];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.myCollectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [self.myCollectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
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
        return 8;
    }
    else {
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CategoryCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd",indexPath.row);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        ReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        return footer;
    }
    
    ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    header.backgroundColor = [UIColor whiteColor];
    header.text = indexPath.section == 0 ? @"美食" : @"购物";
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

@end
