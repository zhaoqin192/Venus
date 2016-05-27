//
//  GMMeOrderCell.m
//  Venus
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeOrderCell.h"

@interface GMMeOrderCell ()

@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UIButton *takeawayButton;
@end

@implementation GMMeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *lineView = [self.contentView viewWithTag:10];
    lineView.backgroundColor = GMBgColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self onClickEvent];
}

- (void)onClickEvent {
    [[self.couponButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCoupon" object:nil];
    }];
    [[self.takeawayButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"showTake" object:nil];
     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
