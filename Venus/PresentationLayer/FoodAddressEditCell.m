//
//  FoodAddressEditCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddressEditCell.h"

@implementation FoodAddressEditCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodAddressEditCell";
    FoodAddressEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodAddressEditCell" owner:nil options:nil] firstObject];
    }
    return cell;
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
