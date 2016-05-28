//
//  CouponOrderTableViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponOrderTableViewCell.h"

@implementation CouponOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"EFEFF4"]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
