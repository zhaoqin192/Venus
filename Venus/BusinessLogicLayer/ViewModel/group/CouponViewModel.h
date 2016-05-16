//
//  CouponViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/16/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewModel : UITableViewController

@property (nonatomic, strong) RACSubject *couponSuccessObject;
@property (nonatomic, strong) RACSubject *couponFailureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (void)fetchCouponDetailWithStoreID:(NSString *)storeID;

@end
