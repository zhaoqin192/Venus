//
//  BrandKindTableViewCell.m
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandKindTableViewCell.h"
#import "MerchandiseModel.h"

@implementation BrandKindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *leftGap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
    [self.leftView addGestureRecognizer:leftGap];
    
    UITapGestureRecognizer *rightGap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
    [self.rightView addGestureRecognizer:rightGap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDetail:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (view == self.leftView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDetail" object:nil userInfo:@{@"identifier": self.leftIdentifier}];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showDetail" object:nil userInfo:@{@"identifier": self.rightIdentifier}];
    }
}

- (void)insertLeftModel:(MerchandiseModel *)leftModel {
    
    self.rightView.hidden = YES;
    
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:leftModel.pictureURL] placeholderImage:[UIImage imageNamed:@"default"]];
    self.leftTitleLabel.text = leftModel.name;
    self.leftPriceLabel.text = [NSString stringWithFormat:@"￥%@", leftModel.price];
    self.leftIdentifier = leftModel.identifier;
}

- (void)insertLeftModel:(MerchandiseModel *)leftModel rightModel:(MerchandiseModel *)rightModel {
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:leftModel.pictureURL] placeholderImage:[UIImage imageNamed:@"default"]];
    self.leftTitleLabel.text = leftModel.name;
    self.leftPriceLabel.text = [NSString stringWithFormat:@"￥%@", leftModel.price];
    self.leftIdentifier = leftModel.identifier;
    
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:rightModel.pictureURL] placeholderImage:[UIImage imageNamed:@"default"]];
    self.rightTitleLabel.text = rightModel.name;
    self.rightPriceLabel.text = [NSString stringWithFormat:@"￥%@", rightModel.price];
    self.rightIdentifier = rightModel.identifier;
}

@end
