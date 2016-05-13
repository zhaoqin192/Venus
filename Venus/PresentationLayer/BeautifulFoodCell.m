//
//  BeautifulFoodCell.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautifulFoodCell.h"
#import "BeautifulFood.h"

@interface BeautifulFoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *despLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuanView;
@property (weak, nonatomic) IBOutlet UIImageView *waiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waiConstraint;

@end

@implementation BeautifulFoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BeautifulFood *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.shopLogo]];
    self.nameLabel.text = model.shopName;
    self.locationLabel.text = [NSString stringWithFormat:@"店铺地址：%@",model.location];
    if (self.model.desp.length != 0) {
        self.activityView.hidden = NO;
        self.despLabel.hidden = NO;
        self.despLabel.text = model.desp;
    }
    else {
        self.activityView.hidden = YES;
        self.despLabel.hidden = YES;
    }
    self.tuanView.hidden = model.miami == 1 ? NO : YES;
    self.waiView.hidden = model.couponz == 1 ? NO : YES;
    if (model.miami == 0 && model.couponz == 1) {
        self.waiConstraint.constant = 10;
    }
    else {
        self.waiConstraint.constant = 33;
    }
}

@end
