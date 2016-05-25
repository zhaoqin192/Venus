//
//  FoodTrolleyTableViewCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodOrderViewBaseItem;

@interface FoodTrolleyTableViewCell : UITableViewCell

@property (strong, nonatomic) FoodOrderViewBaseItem *food;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *foodCount;
@property (weak, nonatomic) IBOutlet UILabel *foodTotalPrice;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
