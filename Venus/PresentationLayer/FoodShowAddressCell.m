//
//  FoodShowAddressCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodShowAddressCell.h"
#import "FoodAddress.h"

@implementation FoodShowAddressCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodShowAddressCell";
    FoodShowAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodShowAddressCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:YES];
}

#pragma mark - getters and setters
- (void)setFoodAddress:(FoodAddress *)foodAddress {
    _foodAddress = foodAddress;
    _name.text = foodAddress.linkmanName;
    _address.text = foodAddress.address;
    _phoneNumber.text = foodAddress.phoneNumber;
}

@end
