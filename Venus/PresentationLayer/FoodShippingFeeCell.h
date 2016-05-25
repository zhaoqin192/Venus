//
//  FoodShippingFeeCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodShippingFeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
