//
//  CouponPayTableViewCell.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponPayTableViewCell.h"

@implementation CouponPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    @weakify(self)
    [[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payment" object:nil userInfo:@{@"orderModel": self.orderModel}];
        
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
