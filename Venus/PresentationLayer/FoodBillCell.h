//
//  FoodBillCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodBillCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@end
