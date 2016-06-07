//
//  BrandDetailViewModel.h
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandDetailViewModel : NSObject

@property (nonatomic, strong) RACSubject *commentSuccessObject;
@property (nonatomic, strong) RACSubject *commentFailureObject;
@property (nonatomic, strong) RACSubject *commentLoadMoreObject;
@property (nonatomic, strong) RACSubject *detailSuccessObject;
@property (nonatomic, strong) RACSubject *detailFailureObject;
@property (nonatomic, strong) RACSubject *kindSuccessObject;
@property (nonatomic, strong) RACSubject *kindFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) NSInteger commentCurrentPage;
@property (nonatomic, assign) NSInteger commentTotalPage;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, assign) NSInteger kindCurrentPage;
@property (nonatomic, assign) NSInteger kindTotalPage;
@property (nonatomic, strong) NSMutableArray *kindArray;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, strong) NSMutableArray *showArray;

- (void)fetchCommentWithStoreID:(NSNumber *)storeID
                           page:(NSInteger)page;

- (void)loadMoreCommentWithStoreID:(NSNumber *)storeID
                              page:(NSInteger)page;

- (void)fetchDetailWithStoreID:(NSNumber *)storeID;

- (void)fetchAllKindsWithStoreID:(NSNumber *)storeID
                            page:(NSInteger)page;

- (void)sendCommentWithStoreID:(NSNumber *)storeID
                        cotent:(NSString *)content;

@end
