//
//  FoodTrolleyTableViewCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodTrolleyTableViewCell.h"
#import "FoodOrderViewBaseItem.h"

@interface FoodTrolleyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *foodName;




@end

@implementation FoodTrolleyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodTrolleyTableViewCell";
    FoodTrolleyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodTrolleyTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setFood:(FoodOrderViewBaseItem *)food {
    _food = food;
    _foodName.text = food.name;
    _foodTotalPrice.text = [NSString stringWithFormat:@"￥%.2f",(CGFloat)(food.unitPrice * food.orderCount)];
    _foodCount.text = [NSString stringWithFormat:@"%li",(long)food.orderCount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getters and setters

@end
