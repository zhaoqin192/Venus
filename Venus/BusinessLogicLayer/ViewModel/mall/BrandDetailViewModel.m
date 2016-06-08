//
//  BrandDetailViewModel.m
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailViewModel.h"
#import "NetworkFetcher+Mall.h"
#import "BrandDetailCommentModel.h"
#import "MerchandiseModel.h"

@interface BrandDetailViewModel ()

@property (nonatomic, assign) NSInteger capacity;
@end

@implementation BrandDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.commentSuccessObject = [RACSubject subject];
        self.commentFailureObject = [RACSubject subject];
        self.commentLoadMoreObject = [RACSubject subject];
        self.detailSuccessObject = [RACSubject subject];
        self.detailFailureObject = [RACSubject subject];
        self.kindSuccessObject = [RACSubject subject];
        self.kindFailureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.commentCurrentPage = 1;
        self.commentTotalPage = 1;
        self.kindCurrentPage = 1;
        self.kindTotalPage = 1;
        self.capacity = 10;
    }
    return self;
}

- (void)fetchCommentWithStoreID:(NSNumber *)storeID
                           page:(NSInteger)page {
    @weakify(self)
    [NetworkFetcher mallFetchCommentWithStoreID:storeID page:[NSNumber numberWithInteger:page] capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
         
            [BrandDetailCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"name": @"userName",
                            @"pictureURL": @"headImg"
                         };
            }];
            self.commentTotalPage = [response[@"pages"] integerValue];
            self.commentArray = [BrandDetailCommentModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
            
            [self.commentSuccessObject sendNext:nil];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)loadMoreCommentWithStoreID:(NSNumber *)storeID
                              page:(NSInteger)page {
    
    @weakify(self)
    [NetworkFetcher mallFetchCommentWithStoreID:storeID page:[NSNumber numberWithInteger:page] capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [BrandDetailCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"identifier": @"id",
                         @"name": @"userName",
                         @"pictureURL": @"headImg"
                         };
            }];
            self.commentTotalPage = [response[@"pages"] integerValue];
            NSArray *array = [BrandDetailCommentModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
            [self.commentArray addObjectsFromArray:array];
            [self.commentLoadMoreObject sendNext:[NSNumber numberWithInteger:array.count]];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)fetchDetailWithStoreID:(NSNumber *)storeID {
    @weakify(self)
    [NetworkFetcher mallFetchDetailWithStoreID:storeID success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            @strongify(self)
            NSDictionary *info = response[@"shopInfo"];
            self.storeName = info[@"shopName"];
            self.describe = info[@"description"];
            self.storeAddress = info[@"location"];
            self.logoURL = info[@"shopLogo"];
            self.detailURL = info[@"app"];
            self.showArray = [NSString mj_objectArrayWithKeyValuesArray:info[@"brandShowUrls"]];
            [self.detailSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)fetchAllKindsWithStoreID:(NSNumber *)storeID
                            page:(NSInteger)page {
    @weakify(self)
    [NetworkFetcher mallFetchAllKindsWithStoreID:storeID page:[NSNumber numberWithInteger:page] capacity:[NSNumber numberWithInteger:self.capacity] success:^(NSDictionary *response) {
        
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            
            [MerchandiseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                            @"identifier": @"id",
                            @"pictureURL": @"picUrl"
                         };
            }];
            self.kindArray = [MerchandiseModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
            [self.kindSuccessObject sendNext:nil];
        }
        
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}

- (void)sendCommentWithStoreID:(NSNumber *)storeID
                        cotent:(NSString *)content {
    @weakify(self)
    [NetworkFetcher mallSendCommentWithStoreID:storeID content:content success:^(NSDictionary *response) {
        @strongify(self)
        if ([response[@"errCode"] isEqualToNumber:@0]) {
            self.commentTotalPage = 1;
            self.commentCurrentPage = 1;
            [self fetchCommentWithStoreID:storeID page:self.commentCurrentPage];
        }
    } failure:^(NSString *error) {
        @strongify(self)
        [self.errorObject sendNext:@"网络异常"];
    }];
    
}


@end
