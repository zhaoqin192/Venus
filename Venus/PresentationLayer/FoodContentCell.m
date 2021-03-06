//
//  FoodContentCell.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodContentCell.h"
#import "FoodDetail.h"
#import "FoodOrderViewBaseItem.h"

@interface FoodContentCell ()
@property (weak, nonatomic) IBOutlet UIView *countView;

@end

@implementation FoodContentCell

- (void)awakeFromNib {
    self.countView.hidden = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFoodCount:(NSInteger)foodCount {
    _foodCount = foodCount;
    _count.text = [NSString stringWithFormat:@"%ld", (long)foodCount];
}

- (void)setIsDisplay:(BOOL)isDisplay {
    _isDisplay = isDisplay;
    if (self.isDisplay) {
        self.countView.hidden = YES;
    }
}

- (void)setFoodModel:(FoodDetail *)foodModel {
    _foodModel = foodModel;
    [self.pictureUrl sd_setImageWithURL:[NSURL URLWithString:foodModel.pic]];
    self.name.text = foodModel.name;
    self.price.text = [NSString stringWithFormat:@"%ld/份",(long)foodModel.price];
    self.sales.hidden = YES;
}

- (void)setBaseItem:(FoodOrderViewBaseItem *)baseItem {
    _baseItem = baseItem;
    [self.pictureUrl sd_setImageWithURL:[NSURL URLWithString:baseItem.pictureURL]];
    self.name.text = baseItem.name;
    self.price.text = [NSString stringWithFormat:@"%.2f元/份",baseItem.unitPrice];
    self.sales.text = [NSString stringWithFormat:@"月销量%li",(long)baseItem.soldCount];
    self.count.text = [NSString stringWithFormat:@"%li",(long)baseItem.orderCount];
}

@end
