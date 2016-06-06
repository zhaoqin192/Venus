//
//  FoodMarkCell.h
//  Venus
//
//  Created by EdwinZhou on 16/6/5.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodMarkCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *markContent;

@end
