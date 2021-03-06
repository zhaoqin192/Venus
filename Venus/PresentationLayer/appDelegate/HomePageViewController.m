//
//  HomePageViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "HomePageViewController.h"
#import "SDCycleScrollView.h"
#import "HomeMenuCell.h"
#import "HomeNewsCell.h"
#import "HomeIntroduceCell.h"
#import "HomeCategoryCell.h"
#import "DatabaseManager.h"
#import "AccountDao.h"
#import "Account.h"
#import "GMLoginViewController.h"
#import "NetworkFetcher+Home.h"
#import "PictureManager.h"
#import "Picture.h"
#import "WebViewController.h"
#import "AdvertisementManager.h"
#import "Adversitement.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "FoodViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

#import "BeautifulFoodViewController.h"
#import "MoneyCardViewController.h"
#import "FoodViewController.h"
#import "GroupViewController.h"
#import "RDVTabBarController.h"
#import "MallViewController.h"
#import "HomeViewModel.h"
#import "GMNavigationController.h"
#import "HomeSearchViewController.h"
#import "MBProgressHUD.h"
#import "HomeNewsViewController.h"
#import "CouponViewController.h"
#import "CouponModel.h"
#import "BrandDetailViewController.h"
#import "KindDetailViewController.h"
#import "MerchandiseModel.h"
#import "FoodDetailViewController.h"
#import "BeautifulDetailViewController.h"

@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate,QRCodeReaderDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SDCycleScrollView *scrollAdView;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (nonatomic, copy) NSMutableArray *scrollArray;
@property (nonatomic, copy) NSMutableArray *recommendArray;
@property (nonatomic, strong) PictureManager *pictureManager;
@property (nonatomic, strong) AdvertisementManager *advertisementManager;
@property (nonatomic, copy) NSMutableArray *advertisementArray;
@property (nonatomic, copy) NSString *buttonURL;
@property (weak, nonatomic) IBOutlet UIButton *QCodeButton;
@property (strong, nonatomic) QRCodeReaderViewController *reader;
@property (nonatomic, strong) HomeViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (nonatomic, assign) BOOL marqueeLabelIsActive;
@property (nonatomic, strong) NSMutableArray *boutiqueArray;
@property (nonatomic, strong) NSArray *boutiqueObjectArray;

@end


static const NSString *PICTUREURL = @"http://www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";



@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.backgroundColor = GMRedColor;
    [self configureTableView];
    

    self.navigationController.navigationBar.barTintColor = GMRedColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = GMBrownColor;
    
    [self.QCodeButton bk_whenTapped:^{
        if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
            static QRCodeReaderViewController *reader = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                reader = [QRCodeReaderViewController new];
            });
            reader.delegate = self;
            
            [reader setCompletionWithBlock:^(NSString *resultAsString) {
                NSLog(@"Completion with result: %@", resultAsString);
            }];
            
            [self presentViewController:reader animated:YES completion:NULL];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    self.searchBar.delegate = self;
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.layer.cornerRadius = 14;
        //searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    self.searchBar.placeholder = @"Search";
    
    [self bindViewModel];
    
    [self.viewModel login];

    
    [self.viewModel fetchHeadline];
    
    [self netWorkRequest];

    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar {
    
    UIStoryboard *group = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    HomeSearchViewController *vc = (HomeSearchViewController *)[group instantiateViewControllerWithIdentifier:@"HomeSearchViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    return NO;
}

- (void)bindViewModel {
 
    self.viewModel = [[HomeViewModel alloc] init];
    
    [self.viewModel.loginSuccessObject subscribeNext:^(id x) {
        
    }];
    
    @weakify(self)
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [self.viewModel.headlineSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
 
    [[self.notificationButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"当前没有新的信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelButton];
        @strongify(self)
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showAdvertisement" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        NSDictionary *userInfo = notification.userInfo;
        @strongify(self)
        [self parseStringAndPushViewController:userInfo[@"advertisementURL"]];
    }];

}

- (void)parseStringAndPushViewController:(NSString *)string {
    [self.viewModel parseURL:string];
    switch (self.viewModel.type) {
        case UNISHOP:{
            BeautifulDetailViewController *beautifulDetailVC = [[BeautifulDetailViewController alloc] init];
            beautifulDetailVC.shopId = [[NSNumber numberWithString:self.viewModel.typeID] integerValue];
            [self.navigationController pushViewController:beautifulDetailVC animated:YES];
        }
            break;
        case SHOP:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
            BrandDetailViewController *brandDetailVC = (BrandDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BrandDetailViewController"];
            brandDetailVC.storeID = [NSNumber numberWithString:self.viewModel.typeID];
            [self.navigationController pushViewController:brandDetailVC animated:YES];
        }
            break;
        case ITEM:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
            KindDetailViewController *kindDetaiVC = (KindDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"KindDetailViewController"];
            MerchandiseModel *model = [[MerchandiseModel alloc] init];
            model.identifier = self.viewModel.typeID;
            kindDetaiVC.merchandiseModel = model;
            [self.navigationController pushViewController:kindDetaiVC animated:YES];
        }
            break;
        case COUPON:{
            UIStoryboard *group = [UIStoryboard storyboardWithName:@"group" bundle:nil];
            CouponViewController *couponVC = (CouponViewController *)[group instantiateViewControllerWithIdentifier:@"CouponViewController"];
            CouponModel *model = [[CouponModel alloc] init];
            model.identifier = self.viewModel.typeID;
            couponVC.couponModel = model;
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case FOOD:{
            FoodDetailViewController *foodDetailVC = [[FoodDetailViewController alloc] init];
            foodDetailVC.restaurantID = [[NSNumber numberWithString:self.viewModel.typeID] integerValue];
            [self.navigationController pushViewController:foodDetailVC animated:YES];
        }
            break;
        case WEB:{
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = string;
            webVC.titilString = @"广告推荐";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    if (self.view.isHidden) {
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        [self presentViewController:vc animated:NO completion:^{
            self.view.hidden = NO;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)netWorkRequest {
    
    _pictureManager = [PictureManager sharedInstance];
    
    [NetworkFetcher homeFetcherLoopPictureWithSuccess:^{
        
        _scrollArray = [[NSMutableArray alloc] init];
        for (Picture *picture in _pictureManager.loopPictureArray) {
            NSString *urlPath = [PICTUREURL stringByAppendingString:picture.pictureUrl];
            [_scrollArray addObject:urlPath];
        }
        self.scrollAdView.imageURLStringsGroup = _scrollArray;
        
    } failure:^(NSString *error) {
        
    }];
    
    [NetworkFetcher homeFetcherRecommmendWithSuccess:^{
        
        _recommendArray= [[NSMutableArray alloc] init];
        for (Picture *picture in _pictureManager.recommendPictureArray) {
            NSString *urlPath = [PICTUREURL stringByAppendingString:picture.pictureUrl];
            [_recommendArray addObject:urlPath];
        }
        [_tableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
    
    [NetworkFetcher homeFetcherListADWithSuccess:^{
       
        _advertisementManager = [AdvertisementManager sharedInstance];
        _advertisementArray = _advertisementManager.advertisementArray;
        
        [_tableView reloadData];
        
    } failure:^(NSString *error) {
        
    }];
    
    @weakify(self)
    [NetworkFetcher homeFetcherBoutiqueWithSuccess:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            self.boutiqueObjectArray = [Picture mj_objectArrayWithKeyValuesArray:response[@"result"]];
            self.boutiqueArray = [[NSMutableArray alloc] init];
            for (Picture *picture in _boutiqueObjectArray) {
                [self.boutiqueArray addObject:[PICTUREURL stringByAppendingString:picture.pictureUrl]];
            }
            [self.tableView reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = error;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (NSMutableArray *)menuArray{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNewsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeNewsCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeIntroduceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeIntroduceCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeCategoryCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.scrollAdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16) delegate:self placeholderImage:[UIImage imageNamed:@""]];

    self.scrollAdView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.tableView.tableHeaderView = self.scrollAdView;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    Picture *picture = [self.pictureManager.loopPictureArray objectAtIndex:index];
    [self parseStringAndPushViewController:picture.url];
}

#pragma mark <TableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4 + _advertisementArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            static NSString *cellIndentifier = @"menucell";
            HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:self.menuArray];
            }
            __weak typeof(self)weakSelf = self;
            cell.buttonClickedWithTag = ^(NSInteger *tag){
                switch ((int)tag) {
                    case 10:{
                        NSLog(@"官网");
                        break;
                    }
                    case 11:{
                        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
                        vc.myTitle = @"美食";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                    case 12:{
                        UIStoryboard *mall = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
                        MallViewController *mallVC = (MallViewController *)[mall instantiateViewControllerWithIdentifier:@"mall"];
                        [weakSelf.navigationController pushViewController:mallVC animated:YES];
                        NSLog(@"官网");
                        break;
                    }
                    case 13:{
                        NSLog(@"丽人");
                        break;
                    }
                    case 14:{
                        NSLog(@"娱乐");
                        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
                        vc.identify = 10051;
                        vc.myTitle = @"娱乐";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                    case 15:{
                        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
                        vc.identify = 10048;
                        vc.myTitle = @"酒店";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        NSLog(@"酒店");
                        break;
                    }
                    case 16:{
                        NSLog(@"会议");
                        break;
                    }
                    case 17:{
                        FoodViewController *vc = [[FoodViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                    case 18:{
                        UIStoryboard *group = [UIStoryboard storyboardWithName:@"group" bundle:nil];
                        GroupViewController *vc = (GroupViewController *)[group instantiateViewControllerWithIdentifier:@"group"];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                    case 19:{
                        NSLog(@"生活服务");
                        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
                        vc.identify = 10050;
                        vc.myTitle = @"生活服务";
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                }
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeNewsCell class])];
            cell.headlineArray = self.viewModel.headlineArray;
            if (cell.headlineArray.count > 0) {
                [cell showHeadline];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.list = _recommendArray;
            @weakify(self)
            cell.buttonClicked = ^(UIButton *button){
                Picture *picture = _pictureManager.recommendPictureArray[button.tag];
                @strongify(self)
                [self parseStringAndPushViewController:picture.url];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case 3:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.myTitle.text = @"热门单品";
            cell.list = self.boutiqueArray;
            @weakify(self)
            cell.buttonClicked = ^(UIButton *button){
                Picture *picture = self.boutiqueObjectArray[button.tag];
                @strongify(self)
                [self parseStringAndPushViewController:picture.url];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:{
            HomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCategoryCell class])];
            Adversitement *advertisement = _advertisementArray[indexPath.row - 4];
            cell.adversitement = advertisement;
            [cell reloadData];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        HomeNewsViewController *homeNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:[HomeNewsViewController className]];
        homeNewsVC.headlineArray = self.viewModel.headlineArray;
        [self.navigationController pushViewController:homeNewsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 200;
            break;
        case 1:
            return 50;
            break;
        case 2:
        case 3:
            return 140.0f / 375 * kScreenWidth + 60;
            break;
        default:
            return kScreenWidth/375*444;
            break;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",result);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
