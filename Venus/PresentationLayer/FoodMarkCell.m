//
//  FoodMarkCell.m
//  Venus
//
//  Created by EdwinZhou on 16/6/5.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodMarkCell.h"

@implementation FoodMarkCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodMarkCell";
    FoodMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodMarkCell" owner:nil options:nil] firstObject];
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
