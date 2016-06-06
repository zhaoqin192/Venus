//
//  BrandDetailHeadViewCell.m
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailHeadViewCell.h"

@implementation BrandDetailHeadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imageBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"商城店铺背景"]]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
