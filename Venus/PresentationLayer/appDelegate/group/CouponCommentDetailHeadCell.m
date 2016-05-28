//
//  CouponCommentDetailHeadCell.m
//  Venus
//
//  Created by zhaoqin on 5/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "CouponCommentDetailHeadCell.h"


@implementation CouponCommentDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.starView addTarget:self action:@selector(starValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)starValueChanged:(HCSStarRatingView *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"starValueChanged" object:nil userInfo:@{@"value": [NSNumber numberWithFloat:sender.value]}];
    
}

@end
