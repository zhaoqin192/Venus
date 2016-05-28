//
//  GMMeTakeAwayCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OrderState) {
    waitingPay = 0,
    payingSucceed,
    waitingDelivery,
    deliveringSucceed,
    orderDone,
    orderDoneAndEvaluated,
    payingFailed,
    orderRevoked,
    takingOrderFailed,
    refundSucceed,
    refunding
} ;

@interface GMMeTakeAwayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (copy, nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) OrderState orderState;
@property (weak, nonatomic) IBOutlet UIButton *oneMoreOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@end
