//
//  MoneyCell.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MoneyCell.h"
#import "WXCoupon.h"

@interface MoneyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

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

- (void)setFoodModel:(WXCoupon *)foodModel {
    _foodModel = foodModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:foodModel.picUrl]];
    self.nameLabel.text = foodModel.abstract;
    self.priceLabel.text = [NSString stringWithFormat:@"面值%ld元",(long)foodModel.asPrice];
    self.numLabel.text = [NSString stringWithFormat:@"已售%ld",(long)foodModel.purchaseNum];
}

@end
