//
//  CouponUseViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponUseViewModel.h"
#import "AppCacheManager.h"
#import "NetworkFetcher+Group.h"
#import "MJExtension.h"
#import "CouponOrderModel.h"


@implementation CouponUseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.useSuccessObject = [RACSubject subject];
        self.useFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}


- (void)fetchUseData {
    
    self.useArray = [AppCacheManager fetchCacheDataWithFileName:@"CouponUseData"];
    
    if (self.useArray != nil) {
        [self.useSuccessObject sendNext:nil];
    }
    
    [self refreshData];
}

- (void)cacheData {
    
    [AppCacheManager cacheDataWithData:self.useArray fileName:@"CouponUseData"];
    
}

- (void)refreshData {
    [NetworkFetcher groupFetchAccountOrderArrayWithStatus:@7 success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponOrderModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"orderID": @"orderId",
                         @"accountID": @"wmId",
                         @"storeID": @"storeId",
                         @"couponID": @"couponId",
                         @"pictureURL": @"couponPicUrl",
                         @"endTime": @"couponEndTime",
                         @"resume": @"abstract",
                         @"count": @"num",
                         @"totalPrice": @"price",
                         @"creatTime": @"orderCreateTime"
                         };
            }];
            
            self.useArray = [CouponOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
            [self.useSuccessObject sendNext:nil];
            
        }
        else {
            
            [self.useFailureObject sendNext:@"请求失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];
}


@end
