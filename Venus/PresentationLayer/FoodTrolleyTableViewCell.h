//
//  FoodTrolleyTableViewCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodForOrdering;

@interface FoodTrolleyTableViewCell : UITableViewCell

@property (strong, nonatomic) FoodForOrdering *food;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
