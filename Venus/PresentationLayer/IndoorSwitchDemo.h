//
//  IndoorSwitchDemo.h
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface IndoorSwitchDemo :  UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKOverlay,UITableViewDataSource,UITableViewDelegate>
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKGroundOverlay* ground;
    BMKGroundOverlay* ground2;
    BMKPointAnnotation* pointAnnotation;
    BMKAnnotationView* newAnnotation;
    UITableView *_floorTableView;
}

@end
