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

@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate,QRCodeReaderDelegate>

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

@end


static const NSString *PICTUREURL = @"http://www.chinaworldstyle.com/hestia/files/image/OnlyForTest/";



@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Account *account = [[[DatabaseManager sharedInstance] accountDao] fetchAccount];
    if(account.token == nil){
        self.view.hidden = YES;
    }
    
    self.titleView.backgroundColor = GMRedColor;
    [self configureTableView];
    
    [self netWorkRequest];
//    self.hidesBottomBarWhenPushed = YES;
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
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    self.tableView.tableHeaderView = ({
        self.scrollAdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 220) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        self.scrollAdView;
    });
}

- (void)configureScrollView{

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    WebViewController *webVC = [[WebViewController alloc] init];
    Picture *picture = _pictureManager.loopPictureArray[index];
    webVC.url = picture.url;
    [self.navigationController pushViewController:webVC animated:NO];
    
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
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        break;
                    }
                    case 12:{
                        NSLog(@"官网");
                        break;
                    }
                    case 13:{
                        NSLog(@"官网");
                        break;
                    }
                    case 14:{
                        NSLog(@"官网");
                        break;
                    }
                    case 15:{
                        NSLog(@"官网");
                        break;
                    }
                    case 16:{
                        NSLog(@"官网");
                        break;
                    }
                    case 17:{
                        NSLog(@"外卖");
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
                        NSLog(@"官网");
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.list = _recommendArray;
            cell.buttonClicked = ^(UIButton *button){
                
                WebViewController *webVC = [[WebViewController alloc] init];
                Picture *picture = _pictureManager.recommendPictureArray[button.tag];
                webVC.url = picture.url;
                [self.navigationController pushViewController:webVC animated:NO];
                
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case 3:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.myTitle.text = @"热门单品";
            cell.list = _recommendArray;
            cell.buttonClicked = ^(UIButton *button){
                
                WebViewController *webVC = [[WebViewController alloc] init];
                Picture *picture = _pictureManager.recommendPictureArray[button.tag];
                webVC.url = picture.url;
                [self.navigationController pushViewController:webVC animated:NO];
                
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:{
            HomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCategoryCell class])];
            Adversitement *advertisement = _advertisementArray[indexPath.row - 4];
            cell.title.text = advertisement.name;
            [cell.mainPicture sd_setImageWithURL:[NSURL URLWithString:[PICTUREURL stringByAppendingString:advertisement.pictureUrl]] placeholderImage:[UIImage imageNamed:@"1"]];
            
            for (int i = 0; i < advertisement.advertisementArray.count; i++) {
                Picture *picture = advertisement.advertisementArray[i];
                if ([[cell.contentView viewWithTag:i + 1] isKindOfClass:[UIButton class]]) {
                    UIButton *button = [cell.contentView viewWithTag:i+1];
                    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[PICTUREURL stringByAppendingString:picture.pictureUrl]] forState:UIControlStateNormal];
                    [button setTitle:picture.name forState:UIControlStateNormal];
                    _buttonURL = picture.url;
                    [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchDown];
                }
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
    return nil;
}

- (void)categoryButtonClicked:(UIButton *)sender{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = _buttonURL;
    [self.navigationController pushViewController:webVC animated:NO];
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
            return 150;
            break;
        default:
            return 450;
            break;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
