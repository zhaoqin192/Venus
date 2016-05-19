//
//  FoodAddAddressCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodAddAddressCell.h"

@implementation FoodAddAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:YES];
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodAddAddressCell";
    FoodAddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodAddAddressCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
