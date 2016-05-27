//
//  CouponPayViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponPayViewModel : NSObject

@property (nonatomic, strong) RACSubject *paySuccessObject;
@property (nonatomic, strong) RACSubject *payFailureObject;
@property (nonatomic, strong) RACSubject *paymentSuccessObject;
@property (nonatomic, strong) RACSubject *paymentFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *payArray;

- (void)fetchPayData;

- (void)cacheData;

- (void)refreshData;

- (void)createOrderWithCouponID:(NSString *)couponID
                        storeID:(NSString *)storeID
                            num:(NSNumber *)num;

@end
