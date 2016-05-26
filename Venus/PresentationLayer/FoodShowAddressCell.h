//
//  FoodShowAddressCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodAddress;

@interface FoodShowAddressCell : UITableViewCell

@property (strong, nonatomic) FoodAddress *foodAddress;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
