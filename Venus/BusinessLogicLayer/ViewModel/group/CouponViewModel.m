//
//  CouponViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponViewModel.h"

@implementation CouponViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.couponSuccessObject = [RACSubject subject];
        self.couponFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchCouponDetailWithStoreID:(NSString *)storeID {
    
    
    
}


@end
