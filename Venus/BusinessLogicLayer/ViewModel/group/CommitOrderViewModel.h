//
//  CommitOrderViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitOrderViewModel : NSObject

@property (nonatomic, assign) NSInteger countNumber;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) RACSubject *countObject;
@property (nonatomic, strong) RACSubject *orderSuccessObject;
@property (nonatomic, strong) RACSubject *orderFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, assign) NSInteger selectPay;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *orderID;

- (void)initPrice:(NSNumber *)price;

- (void)addCount;

- (void)subtractCount;

- (id)commitButtonIsValid;

- (void)createOrderWithCouponID:(NSString *)couponID
                        storeID:(NSString *)storeID
                            num:(NSNumber *)num;


@end
