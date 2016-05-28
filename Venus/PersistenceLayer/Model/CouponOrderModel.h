//
//  CouponOrderModel.h
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponOrderModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, strong) NSString *couponID;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSString *resume;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *totalPrice;
@property (nonatomic, strong) NSNumber *creatTime;
@property (nonatomic, strong) NSString *storeName;

@end
