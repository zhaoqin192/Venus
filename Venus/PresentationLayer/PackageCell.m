//
//  PackageCell.m
//  Venus
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "PackageCell.h"

@implementation PackageCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = GMBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
