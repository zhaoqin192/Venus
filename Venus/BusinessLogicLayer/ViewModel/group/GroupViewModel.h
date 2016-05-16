//
//  GroupViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/15/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouponModel;

@interface GroupViewModel : NSObject

@property (nonatomic, strong) RACSubject *menuSuccessObject;
@property (nonatomic, strong) RACSubject *menuFailureObject;
@property (nonatomic, strong) RACSubject *couponSuccessObject;
@property (nonatomic, strong) RACSubject *couponFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSArray *sortArray;
@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;

- (void)fetchMenuData;

- (void)fetchCouponDataWithType:(NSString *)type
                           sort:(NSString *)sort
                           page:(NSNumber *)page;

- (void)loadMoreCouponDataWithType:(NSString *)type
                              sort:(NSString *)sort
                              page:(NSNumber *)page;

@end
