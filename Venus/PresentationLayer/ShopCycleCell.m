//
//  ShopCycleCell.m
//  Venus
//
//  Created by 王霄 on 16/4/27.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopCycleCell.h"
#import "SDCycleScrollView.h"

@interface ShopCycleCell()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleView;

@end

@implementation ShopCycleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *lineView = [self.contentView viewWithTag:10];
    lineView.backgroundColor = GMBrownColor;
    self.cycleView.localizationImageNamesGroup = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
