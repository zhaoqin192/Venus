//
//  MapFloorCell.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MapFloorCell.h"

@implementation MapFloorCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
        [self.textLabel setTextColor:GMBrownColor];
    }
    else {
        self.contentView.backgroundColor = [UIColor colorWithRed:166./255 green:135./255 blue:59./255 alpha:0.6];
        [self.textLabel setTextColor:[UIColor blackColor]];
    }
}

@end
