//
//  GroupViewModel.m
//  Venus
//
//  Created by zhaoqin on self.capacity/1self.capacity/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "GroupViewModel.h"
#import "NetworkFetcher+Group.h"
#import "GroupCategory.h"
#import "CouponModel.h"

@interface GroupViewModel ()

@property (nonatomic, assign) NSInteger capacity;

@end


@implementation GroupViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuSuccessObject = [RACSubject subject];
        self.menuFailureObject = [RACSubject subject];
        self.couponSuccessObject = [RACSubject subject];
        self.couponFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.type = nil;
        self.sort = @"time";
        self.sortArray = [NSArray arrayWithObjects:@"发布时间", @"价格", @"销量", nil];
        self.currentPage = 1;
        self.totalPage = 1;
        self.capacity = 10;
    }
    return self;
}

-(void)fetchMenuData {
    
    @weakify(self)
    [NetworkFetcher groupFetchMenuDataWithSuccess:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
         
            [GroupCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id"
                         };
            }];
            @strongify(self)
            self.typeArray = [GroupCategory mj_objectArrayWithKeyValuesArray:response[@"categories"]];
            
            GroupCategory *groupCategory = [[GroupCategory alloc] init];
            groupCategory.identifier = nil;
            groupCategory.name = @"全部";
            
            [self.typeArray insertObject:groupCategory atIndex:0];
            [self.menuSuccessObject sendNext:nil];
            
        }
    } failure:^(NSString *error) {
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}


- (void)fetchCouponDataWithType:(NSString *)type
                           sort:(NSString *)sort
                           page:(NSNumber *)page {
    
    @weakify(self)
    [NetworkFetcher groupFetchCouponsWithType:type sort:sort page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
       
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"storeId",
                         @"name": @"storeName",
                         @"price": @"coupon.price",
                         @"purchaseNum": @"coupon.purchaseNum",
                         @"pictureUrl": @"coupon.picUrl",
                         @"asPrice": @"coupon.asPrice"
                         };
            }];
            NSInteger totalpage = [response[@"totalNum"] integerValue];
            @strongify(self)
            if (totalpage % self.capacity == 0) {
                self.totalPage = totalpage / self.capacity;
            }
            else {
                self.totalPage = totalpage / self.capacity + 1;
            }
            self.currentPage = [page integerValue];
            self.couponArray = [CouponModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.couponSuccessObject sendNext:nil];
            
        }
        
    } failure:^(NSString *error) {
        
    }];
    
}

- (void)loadMoreCouponDataWithType:(NSString *)type
                              sort:(NSString *)sort
                              page:(NSNumber *)page {
    
    @weakify(self)
    [NetworkFetcher groupFetchCouponsWithType:type sort:sort page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"storeId",
                         @"name": @"storeName",
                         @"price": @"coupon.price",
                         @"purchaseNum": @"coupon.purchaseNum",
                         @"pictureUrl": @"coupon.picUrl",
                         @"asPrice": @"coupon.asPrice"
                         };
            }];
            @strongify(self)
            NSInteger totalpage = [response[@"totalNum"] integerValue];
            if (totalpage % self.capacity == 0) {
                self.totalPage = totalpage / self.capacity;
            }
            else {
                self.totalPage = totalpage / self.capacity + 1;
            }
            
            [self.couponArray addObjectsFromArray:[CouponModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
            [self.couponSuccessObject sendNext:nil];
            
        }
        
    } failure:^(NSString *error) {
        
    }];
    
    
}


@end
