//
//  FoodPaymentCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *paymentWay;
@property (assign, nonatomic) BOOL isSelected;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
