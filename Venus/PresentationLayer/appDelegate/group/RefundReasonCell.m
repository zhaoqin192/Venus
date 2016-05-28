//
//  RefundReasonCell.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "RefundReasonCell.h"

@interface RefundReasonCell()

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation RefundReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         if (self.isSelected) {
             self.isSelected = NO;
             [self.selectButton setImage:[UIImage imageNamed:@"unselect_rectange"] forState:UIControlStateNormal];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelReason" object:nil userInfo:@{@"reason": self.reasonLabel.text}];
         }
         else {
             self.isSelected = YES;
             [self.selectButton setImage:[UIImage imageNamed:@"select_rectange"] forState:UIControlStateNormal];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"selectReason" object:nil userInfo:@{@"reason": self.reasonLabel.text}];
         }
     }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
