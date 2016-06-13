//
//  RefundCodeCell.m
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "RefundCodeCell.h"

@interface RefundCodeCell()

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation RefundCodeCell

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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CodeSubtraction" object:nil userInfo:@{@"code": self.codeIdentifier}];
        }
        else {
            self.isSelected = YES;
            [self.selectButton setImage:[UIImage imageNamed:@"select_rectange"] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CodeAdd" object:nil userInfo:@{@"code": self.codeIdentifier}];
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
