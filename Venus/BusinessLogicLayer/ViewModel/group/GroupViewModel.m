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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"MenuArray.archive"];
    NSMutableArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (cachedArray != nil) {
        self.typeArray = cachedArray;
        [self.menuSuccessObject sendNext:nil];
    }
   
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

- (void)cachedMenuData {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"MenuArray.archive"];
    
    [NSKeyedArchiver archiveRootObject:self.typeArray toFile:archivePath];
    
}

- (void)fetchCouponDataWithType:(NSString *)type
                           sort:(NSString *)sort
                           page:(NSNumber *)page {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"CouponArray.archive"];
    NSMutableArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (cachedArray != nil) {
        self.couponArray = cachedArray;
        [self.couponSuccessObject sendNext:nil];
    }
    
    @weakify(self)
    [NetworkFetcher groupFetchCouponsWithType:type sort:sort page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"coupon.id",
                         @"name": @"storeName",
                         @"address": @"storeAddress",
                         @"price": @"coupon.price",
                         @"purchaseNum": @"coupon.purchaseNum",
                         @"pictureUrl": @"coupon.picUrl",
                         @"asPrice": @"coupon.asPrice",
                         @"abstract": @"coupon.abstract",
                         @"startTime": @"coupon.startTime",
                         @"endTime": @"coupon.endTime"
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
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)cachedCouponData {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"CouponArray.archive"];
    
    NSArray *array = nil;
    
    if (self.couponArray.count > 10) {
        array = [self.couponArray subarrayWithRange:NSMakeRange(0, 9)];
    }else {
        array = self.couponArray;
    }
    [NSKeyedArchiver archiveRootObject:array toFile:archivePath];
    
}


- (void)loadMoreCouponDataWithType:(NSString *)type
                              sort:(NSString *)sort
                              page:(NSNumber *)page {
    
    @weakify(self)
    [NetworkFetcher groupFetchCouponsWithType:type sort:sort page:page capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [CouponModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"coupon.id",
                         @"name": @"storeName",
                         @"address": @"storeAddress",
                         @"price": @"coupon.price",
                         @"purchaseNum": @"coupon.purchaseNum",
                         @"pictureUrl": @"coupon.picUrl",
                         @"asPrice": @"coupon.asPrice",
                         @"abstract": @"coupon.abstract"
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
        [self.errorObject sendNext:@"网络异常"];

    }];
    
    
}


@end
