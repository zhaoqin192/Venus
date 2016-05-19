//
//  FoodTrolleyTableViewCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodTrolleyTableViewCell.h"
#import "FoodForOrdering.h"

@interface FoodTrolleyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *foodCount;


@end

@implementation FoodTrolleyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodTrolleyTableViewCell";
    FoodTrolleyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodTrolleyTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setFood:(FoodForOrdering *)food {
    _food = food;
    _foodTotalPrice.text = [NSString stringWithFormat:@"￥%f",food.foodTotalPrice];
    _foodName.text = food.foodName;
    _foodCount.text = [NSString stringWithFormat:@"%li",(long)food.foodCount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
