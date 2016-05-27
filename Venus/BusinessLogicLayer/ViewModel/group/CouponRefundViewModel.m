//
//  CouponRefundViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponRefundViewModel.h"
#import "AppCacheManager.h"
#import "NetworkFetcher+Group.h"
#import "MJExtension.h"
#import "CouponOrderModel.h"

@implementation CouponRefundViewModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.refundSuccessObject = [RACSubject subject];
        self.refundFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
    
}

- (void)fetchRefundData {
    
    self.refundArray = [AppCacheManager fetchCacheDataWithFileName:@"CouponRefundData"];
    
    if (self.refundArray != nil) {
        [self.refundSuccessObject sendNext:nil];
    }
    
    [self refreshData];
}

- (void)cacheData {
    
    [AppCacheManager cacheDataWithData:self.refundArray fileName:@"CouponRefundData"];
    
}

- (void)refreshData {
    [NetworkFetcher groupFetchAccountOrderArrayWithStatus:@6 success:^(NSDictionary *response) {
        
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
            
            self.refundArray = [CouponOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
            [self.refundSuccessObject sendNext:nil];
            
        }
        else {
            
            [self.refundFailureObject sendNext:@"请求失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];
}


@end
