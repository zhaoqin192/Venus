//
//  FoodContentCell.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodContentCell.h"
#import "FoodDetail.h"

@interface FoodContentCell()



@end

@implementation FoodContentCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFoodCount:(NSInteger)foodCount {
    _foodCount = foodCount;
    _count.text = [NSString stringWithFormat:@"%ld", (long)foodCount];
}

- (void)setFoodModel:(FoodDetail *)foodModel {
    _foodModel = foodModel;
    [self.pictureUrl sd_setImageWithURL:[NSURL URLWithString:foodModel.pic]];
    self.name.text = foodModel.name;
    self.price.text = [NSString stringWithFormat:@"%ld/份",(long)foodModel.price];
    self.sales.hidden = YES;
}

@end
