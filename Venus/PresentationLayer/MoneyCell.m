//
//  MoneyCell.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MoneyCell.h"
#import "CouponModel.h"

@interface MoneyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;

@end

@implementation MoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFoodModel:(CouponModel *)foodModel {
    _foodModel = foodModel;
    CGFloat price = [foodModel.price floatValue];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:foodModel.pictureUrl]];
    self.nameLabel.text = foodModel.abstract;
    self.numLabel.text = [NSString stringWithFormat:@"已售:%@",foodModel.purchaseNum];
    self.realPriceLabel.text = [NSString stringWithFormat:@"%.2f元",price/100];
}

@end
