//
//  CouponUseViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponUseViewModel : NSObject

@property (nonatomic, strong) RACSubject *useSuccessObject;
@property (nonatomic, strong) RACSubject *useFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;
@property (nonatomic, strong) NSMutableArray *useArray;

- (void)fetchUseData;

- (void)cacheData;

- (void)refreshData;


@end
