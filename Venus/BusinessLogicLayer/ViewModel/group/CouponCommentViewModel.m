//
//  CouponCommentViewModel.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentViewModel.h"
#import "AppCacheManager.h"
#import "NetworkFetcher+Group.h"
#import "MJExtension.h"
#import "CouponOrderModel.h"

@implementation CouponCommentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.commentSuccessObject = [RACSubject subject];
        self.commentFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
    }
    return self;
}

- (void)fetchCommentData {
    
    self.commentArray = [AppCacheManager fetchCacheDataWithFileName:@"CouponComment"];
    
    if (self.commentArray != nil) {
        [self.commentSuccessObject sendNext:nil];
    }
    
    [self refreshData];
    
}

- (void)cacheData {
    
    [AppCacheManager cacheDataWithData:self.commentArray fileName:@"CouponComment"];
    
}

- (void)refreshData {
  
    [NetworkFetcher groupFetchAccountOrderArrayWithStatus:@4 success:^(NSDictionary *response) {
        
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
            
            self.commentArray = [CouponOrderModel mj_objectArrayWithKeyValuesArray:response[@"orders"]];
            [self.commentSuccessObject sendNext:nil];
            
        }
        else {
            
            [self.commentFailureObject sendNext:@"请求失败"];
            
        }
        
    } failure:^(NSString *error) {
        
        [self.errorObject sendNext:@"网络异常"];
        
    }];
    
}

@end
