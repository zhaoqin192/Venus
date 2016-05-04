//
//  GMMeCell.m
//  Venus
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeCell.h"

@implementation GMMeCell

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
