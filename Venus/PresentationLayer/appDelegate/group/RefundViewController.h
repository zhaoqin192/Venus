//
//  RefundViewController.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponOrderModel;

@interface RefundViewController : UIViewController

@property (nonatomic, strong) NSArray *codeArray;
@property (nonatomic, strong) NSNumber *unitPrice;
@property (nonatomic, strong) CouponOrderModel *orderModel;

@end
