//  IndoorSwitchDemo.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "IndoorSwitchDemo.h"
@interface IndoorSwitchDemo ()<BMKMapViewDelegate> {
    BMKMapView * _mapView;
    BMKLocationService* _locService;
    
    BMKOfflineMap* _offlineMap;
    IBOutlet UIButton* addBtn;
    UIButton* stopBtn;
    BMKBaseIndoorMapInfo* _baseIndoorMapInfo;
}

@end

@implementation IndoorSwitchDemo
CLLocationCoordinate2D coor;
BMKUserLocation* userLoc;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
//	_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,20,414,800)];
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,0,414,736)];
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.autoresizesSubviews = YES;
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:_mapView];
    _locService = [[BMKLocationService alloc]init];
    _offlineMap = [[BMKOfflineMap alloc]init];
    CGPoint pt;
    pt = CGPointMake(100,100);
    [_mapView setCompassPosition:pt];
    
    CLLocationCoordinate2D coor;
    coor.longitude = 116.648965;
    coor.latitude = 39.912109;
    [_mapView setCenterCoordinate:coor];
    [_mapView setZoomLevel:18];
    
    _baseIndoorMapInfo= [[BMKBaseIndoorMapInfo alloc]init];
    _floorTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, 62, 300)];
    _floorTableView.delegate = self;
    _floorTableView.dataSource = self;
    [self.view addSubview:_floorTableView];
    _floorTableView.hidden = true;
    [_mapView setBaseIndoorEnabled:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

#pragma mark - UITableViewDataSource&Delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FloorCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FloorCell"];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@",[_baseIndoorMapInfo.arrStrFloors objectAtIndex:indexPath.row]];
    [cell.textLabel setText:title];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont systemFontOfSize:21]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setHighlightedTextColor:[UIColor blackColor]];
    [cell setSelectedBackgroundView:[[UIView alloc] init]];
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _baseIndoorMapInfo.arrStrFloors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *floor = [NSString stringWithFormat:@"F%ld",(long)indexPath.row];
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
    if (![view.annotation isKindOfClass:[BMKUserLocation class]]) {
        BMKPinAnnotationView* pinView = (BMKPinAnnotationView *)view;
        pinView.pinColor = BMKPinAnnotationColorGreen;
        pinView.animatesDrop = YES;
        pinView.draggable = YES;
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
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    //_showMsgLabel.text = showmeg;
    NSLog(@"*****%@",showmeg);
}

@end
