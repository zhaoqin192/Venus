//
//  GMMeTakeAwayCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakeAwayOrder;

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
    refundSeries
};

typedef NS_ENUM(NSUInteger, refundState) {
    noRefund = -1,
    refundSucceed = 0,
    refunding
};

@interface GMMeTakeAwayCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (copy, nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) OrderState orderState;
@property (assign, nonatomic) refundState refundState;

@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (strong, nonatomic) TakeAwayOrder *order;

#pragma mark - buttons
@property (weak, nonatomic) IBOutlet UIButton *leftOneMoreOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *rightOneMoreOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;
@property (weak, nonatomic) IBOutlet UIButton *changeStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *rightCancelorderButton;



@end
