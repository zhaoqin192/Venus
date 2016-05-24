//
//  FoodCommitCell.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodCommitCell.h"

@implementation FoodCommitCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodCommitCell";
    FoodCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodCommitCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
