//
//  BMKBaseIndoorMapInfo.h
//  MapComponent
//
//  Created by baidu on 15/12/1.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef BMKBaseIndoorMapInfo_h
#define BMKBaseIndoorMapInfo_h

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

///此类表示室内图基础信息
@interface BMKBaseIndoorMapInfo : NSObject
{
    NSString*    _strID;            // 室内图ID
    NSString*    _strFloor;         // 当前楼层
    NSMutableArray*     _arrStrFloors;     // 所有楼层信息
}
///缩放级别:[3~19]
@property (nonatomic, retain) NSString* strID;
///旋转角度
@property (nonatomic, retain) NSString* strFloor;
///俯视角度:[-45~0]
@property (nonatomic, retain) NSMutableArray* arrStrFloors;

@end

#endif /* BMKBaseIndoorMapInfo_h */
