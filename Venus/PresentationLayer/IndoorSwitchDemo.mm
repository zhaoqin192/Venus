//  IndoorSwitchDemo.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "IndoorSwitchDemo.h"
#import "MapFloorCell.h"
#import "MapHeadView.h"
#import "WXMapShopView.h"
#import "WXMapShopModel.h"
#import "BeautifulDetailViewController.h"
#import "BrandDetailViewController.h"

@interface IndoorSwitchDemo ()<BMKMapViewDelegate> {
    BMKMapView * _mapView;
    BMKLocationService* _locService;
    
    BMKOfflineMap* _offlineMap;
    IBOutlet UIButton* addBtn;
    UIButton* stopBtn;
    BMKBaseIndoorMapInfo* _baseIndoorMapInfo;
}
@property (nonatomic, copy) NSArray *newsArray;
@property (nonatomic, copy) NSArray *newsPointArray;
@property (nonatomic, copy) NSArray *discountArray;
@property (nonatomic, copy) NSArray *discountPointArray;
@property (nonatomic, copy) NSString *selectType;
@property (nonatomic, strong) WXMapShopView *shopView;
@property (nonatomic, strong) MapHeadView *headView;
@end

@implementation IndoorSwitchDemo
CLLocationCoordinate2D coor;
BMKUserLocation* userLoc;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
//	_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,20,414,800)];
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,0,414,736)];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _mapView.autoresizesSubviews = YES;
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:_mapView];
    _locService = [[BMKLocationService alloc]init];
    _offlineMap = [[BMKOfflineMap alloc]init];
    CGPoint pt;
    pt = CGPointMake(100,100);
    [_mapView setCompassPosition:pt];
    
    CLLocationCoordinate2D coor;
    coor.longitude = 116.465249;
    coor.latitude = 39.918066;
    [_mapView setCenterCoordinate:coor];
    [_mapView setZoomLevel:22];
    
    _baseIndoorMapInfo= [[BMKBaseIndoorMapInfo alloc]init];
    _floorTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 180 - 90 , 36, 108)];
    _floorTableView.delegate = self;
    _floorTableView.dataSource = self;
    _floorTableView.layer.cornerRadius = _floorTableView.width/2;
    _floorTableView.layer.masksToBounds = YES;
    _floorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _floorTableView.backgroundColor = [UIColor colorWithRed:166./255 green:135./255 blue:59./255 alpha:0.6];
    _floorTableView.showsVerticalScrollIndicator = NO;
    _floorTableView.layer.borderWidth = 1;
    _floorTableView.layer.borderColor = GMBrownColor.CGColor;
    [self.view addSubview:_floorTableView];
    _floorTableView.hidden = true;
    [_mapView setBaseIndoorEnabled:YES];
    [_floorTableView registerNib:[UINib nibWithNibName:NSStringFromClass([[MapFloorCell class] class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MapFloorCell class])];
    
    [self configureTitleView];
    [self loadData];
    [self configureShopView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self.navigationController setNavigationBarHidden:YES];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)configureShopView {
    self.shopView = [WXMapShopView shopView];
    self.shopView.frame = CGRectMake(18, CGRectGetMaxY(self.headView.frame), [UIScreen mainScreen].bounds.size.width - 36, 180);
    [self.view addSubview:self.shopView];
    self.shopView.hidden = YES;
    __weak typeof(self)weakSelf = self;
    self.shopView.goButtonClicked = ^{
        if (self.shopView.model.type == 2) {
            BeautifulDetailViewController *vc = [[BeautifulDetailViewController alloc] init];
            vc.shopId = weakSelf.shopView.model.identify;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else {
            UIStoryboard *kind = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
            BrandDetailViewController *vc = (BrandDetailViewController *)[kind instantiateViewControllerWithIdentifier:[BrandDetailViewController className]];
            vc.storeID = @(weakSelf.shopView.model.identify);
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

- (void)configureTitleView {
    self.headView = [MapHeadView headView];
    self.headView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 64);
    [self.view addSubview:self.headView];
    __weak typeof(self)weakSelf = self;
    self.headView.newsLabelTapped = ^{
        if ([weakSelf.selectType isEqualToString:@"新品打折"]) {
            return ;
        }
        weakSelf.selectType = @"新品打折";
        [_mapView removeAnnotations:weakSelf.discountPointArray];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WXMapShopModel *model in self.newsArray) {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = model.lat;
            coor.longitude = model.lon;
            annotation.coordinate = coor;
            annotation.title = model.name;
            [tempArray addObject:annotation];
            [_mapView addAnnotation:annotation];
        }
        self.newsPointArray = [tempArray copy];
    };
    
    self.headView.discountLabelTapped = ^{
        if ([weakSelf.selectType isEqualToString:@"满减优惠"]) {
            return ;
        }
        weakSelf.selectType = @"满减优惠";
        [_mapView removeAnnotations:self.newsPointArray];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (WXMapShopModel *model in self.discountArray) {
            BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor1;
            coor1.latitude = model.lat;
            coor1.longitude = model.lon;
            annotation1.coordinate = coor1;
            annotation1.title = model.name;
            [tempArray addObject:annotation1];
            [_mapView addAnnotation:annotation1];
        }
        self.discountPointArray = [tempArray copy];
    };
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pinID = @"PIN";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (newAnnotationView == nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
        }
        newAnnotationView.annotation = annotation;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        if ([self.selectType isEqualToString:@"新品打折"]) {
            newAnnotationView.image = [UIImage imageNamed:@"新品带投影"];
        }
        else {
            newAnnotationView.image = [UIImage imageNamed:@"满减带投影"];
        }
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//        newAnnotationView.rightCalloutAccessoryView = btn;
        
        return newAnnotationView;
    }
    return nil;
}

//- (void)click{
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.title = @"具体活动介绍页面";
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)loadData {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/bazaar/mall/shopping"]];
    NSDictionary *parameters = @{@"build":@(1),@"floor":@(1)};
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
                [WXMapShopModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"desp": @"description",
                             @"identify" : @"id"
                             };
                }];
        self.newsArray = [WXMapShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"new"]];
        self.discountArray = [WXMapShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"discount"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource&Delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapFloorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MapFloorCell class])];
    NSString *title = [NSString stringWithFormat:@"%@",[_baseIndoorMapInfo.arrStrFloors objectAtIndex:indexPath.row]];
    [cell.contentLabel setText:title];
    [cell.contentLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.contentLabel setFont:[UIFont systemFontOfSize:18]];
    cell.contentView.backgroundColor = [UIColor colorWithRed:166./255 green:135./255 blue:59./255 alpha:0.6];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _baseIndoorMapInfo.arrStrFloors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *floor = [NSString stringWithFormat:@"%@",[_baseIndoorMapInfo.arrStrFloors objectAtIndex:indexPath.row]];
    //进行楼层切换
    NSLog(@"%@",floor);
    [_mapView switchBaseIndoorMapFloor:[_baseIndoorMapInfo.arrStrFloors objectAtIndex:indexPath.row] withID:_baseIndoorMapInfo.strID];
}
//普通态
-(void)startLocation
{
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}
//停止定位
-(void)stopLocation
{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserHeading");
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation");
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}
- (void)willStartLocatingUser
{
    NSLog(@"willStartLocatingUser");
}
- (void)didStopLocatingUser
{
    NSLog(@"didStopLocatingUser");
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError=%d",error.code);
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    if ([self.selectType isEqualToString:@"新品打折"]) {
        NSInteger index = [self.newsPointArray indexOfObject:view.annotation];
        WXMapShopModel *model = self.newsArray[index];
        self.shopView.model = model;
    }
    else {
        NSInteger index = [self.discountPointArray indexOfObject:view.annotation];
        WXMapShopModel *model = self.discountArray[index];
        self.shopView.model = model;
    }
    self.shopView.hidden = NO;
    if (![view.annotation isKindOfClass:[BMKUserLocation class]]) {
        BMKPinAnnotationView* pinView = (BMKPinAnnotationView *)view;
        pinView.pinColor = BMKPinAnnotationColorGreen;
        pinView.animatesDrop = YES;
        pinView.draggable = YES;
        if ([self.selectType isEqualToString:@"新品打折"]) {
            pinView.image = [UIImage imageNamed:@"新品带投影"];
        }
        else {
            pinView.image = [UIImage imageNamed:@"满减带投影"];
        }
    }
}

- (void)BaseIndoorMapMode:(BMKMapView *)mapView withIn:(BOOL)bFlag withInfo:(BMKBaseIndoorMapInfo* )info
{
    NSLog(@"BaseIndoorMapMode");
    if(info!=nil&&info.arrStrFloors.count>0)
    {
        _floorTableView.hidden = false;
        _baseIndoorMapInfo.strID = info.strID;
        _baseIndoorMapInfo.strFloor = info.strFloor;
        _baseIndoorMapInfo.arrStrFloors = info.arrStrFloors;
        
        [_floorTableView reloadData];
        
        NSLog(@"_baseIndoorMapInfo.strID=%@",info.strID);
        NSLog(@"_baseIndoorMapInfo.strFloor=%@",info.strFloor);
        NSLog(@"_baseIndoorMapInfo.arrStrFloors=%@",info.arrStrFloors);
        
    }else{
        _floorTableView.hidden = true;
    }
}

#pragma mark 底图手势操作
/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    //_showMsgLabel.text = showmeg;
    NSLog(@"*****%@",showmeg);
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    self.shopView.hidden = YES;
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    //_showMsgLabel.text = showmeg;
    NSLog(@"*****%@",showmeg);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.shopView.hidden = YES;
}

@end
