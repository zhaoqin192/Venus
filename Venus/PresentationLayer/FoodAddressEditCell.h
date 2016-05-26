//
//  FoodAddressEditCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodAddressEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *project;
@property (weak, nonatomic) IBOutlet UITextField *content;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
