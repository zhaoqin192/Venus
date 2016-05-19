//
//  CouponModel.h
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *purchaseNum;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *asPrice;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSString *phone;


@end
