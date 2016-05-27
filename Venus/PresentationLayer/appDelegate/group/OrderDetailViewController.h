//
//  OrderDetailViewController.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponOrderModel;

@interface OrderDetailViewController : UIViewController

@property (nonatomic, strong) CouponOrderModel *orderModel;

//0表示待使用，1表示待付款，2表示待评价，3表示退款
@property (nonatomic, strong) NSNumber *state;

@end
