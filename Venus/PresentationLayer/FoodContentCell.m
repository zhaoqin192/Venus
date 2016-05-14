//
//  FoodContentCell.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodContentCell.h"
#import "FoodDetail.h"

@implementation FoodContentCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addCount:(id)sender {
    NSNumber *number = [NSNumber numberWithString:_count.text];
    NSInteger integer = [number integerValue];
    integer++;
    _count.text = [NSString stringWithFormat:@"%ld", (long)integer];
}

- (IBAction)minusCount:(id)sender {
    NSNumber *number = [NSNumber numberWithString:_count.text];
    NSInteger integer = [number integerValue];
    if (integer != 0) {
        integer--;
    }
    _count.text = [NSString stringWithFormat:@"%ld", (long)integer];
}

- (void)setFoodModel:(FoodDetail *)foodModel {
    _foodModel = foodModel;
    [self.pictureUrl sd_setImageWithURL:[NSURL URLWithString:foodModel.pic]];
    self.name.text = foodModel.name;
    self.price.text = [NSString stringWithFormat:@"%ld/份",(long)foodModel.price];
    self.sales.hidden = YES;
}

@end
