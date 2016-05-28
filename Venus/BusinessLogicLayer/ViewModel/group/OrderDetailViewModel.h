//
//  OrderDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouponOrderModel;

@interface OrderDetailViewModel : NSObject

@property (nonatomic, strong) RACSubject *detailSuccessObject;
@property (nonatomic, strong) RACSubject *detailFailureObject;
@property (nonatomic, strong) RACSubject *paymentSuccessObject;
@property (nonatomic, strong) RACSubject *paymentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *codeArray;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *asPrice;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) CouponOrderModel *couponModel;

- (void)fetchDetailDataWithOrderID:(NSString *)orderID;


- (void)paymentWithOrderID:(NSString *)orderID;


@end
