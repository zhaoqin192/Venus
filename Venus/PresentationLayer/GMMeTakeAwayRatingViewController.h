//
//  GMMeTakeAwayRatingViewController.h
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMeTakeAwayRatingViewController : UIViewController



@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *storeIconURL;
@property (assign, nonatomic) long orderID;
@property (assign, nonatomic) long storeID;
@property (assign, nonatomic) NSInteger deliveryTime;

@end
