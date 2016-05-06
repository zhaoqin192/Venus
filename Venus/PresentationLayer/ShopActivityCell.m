//
//  ShopActivityCell.m
//  Venus
//
//  Created by 王霄 on 16/4/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopActivityCell.h"

@implementation ShopActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
