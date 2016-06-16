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
#import "BeautyCategory.h"
#import "BeautifulFoodViewController.h"
#import "MallViewController.h"

@interface WXCategoryViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (nonatomic, copy) NSArray *shopArray;
@property (nonatomic, copy) NSArray *foodArray;
@end

@implementation WXCategoryViewController

static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部分类";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadShopData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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

- (void)loadShopData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/mallcategory/getFirstClass"]];
    NSDictionary *parameters = nil;
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.shopArray = [BeautyCategory mj_objectArrayWithKeyValuesArray:responseObject[@"cat"]];
        [self loadFoodData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"confirm code %@", error);
    }];
}

- (void)loadFoodData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/shop/getSecondCat?id=10000"]];
    NSDictionary *parameters = nil;
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject[@"errCode"] isEqual: @(0)]) {
            [PresentationUtility showTextDialog:self.view text:responseObject[@"msg"] success:nil];
            
            return ;
        }
        self.foodArray = [BeautyCategory mj_objectArrayWithKeyValuesArray:responseObject[@"cat"]];
        [self.myCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"confirm code %@", error);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.shopArray.count;
    }
    else {
        return self.foodArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CategoryCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        BeautyCategory *cat =self.shopArray[indexPath.row];
        cell.contentLabel.text = cat.name;
    }
    else {
        BeautyCategory *cat =self.foodArray[indexPath.row];
        cell.contentLabel.text = cat.name;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIStoryboard *mall = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
        MallViewController *mallVC = (MallViewController *)[mall instantiateViewControllerWithIdentifier:@"mall"];
        mallVC.selectCategory = [NSNumber numberWithInteger:indexPath.row];
        [self.navigationController pushViewController:mallVC animated:YES];
    }
    else {
        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
        vc.categoryIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        ReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        return footer;
    }
    
    ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    header.backgroundColor = [UIColor whiteColor];
    header.text = indexPath.section == 0 ? @"购物" : @"美食";
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
