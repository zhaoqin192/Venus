//
//  BrandDetailShowCell.m
//  Venus
//
//  Created by zhaoqin on 6/7/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailShowCell.h"
#import "SDCycleScrollView.h"

NSString *const BrandDetailShowCellIdentifier = @"BrandDetailShowCell";

@interface BrandDetailShowCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollAdView;

@end

@implementation BrandDetailShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.scrollAdView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(8, 8, kScreenWidth - 16, 140) delegate:self placeholderImage:[UIImage imageNamed:@"default"]];
    self.scrollAdView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:self.scrollAdView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showArrayLoad:(NSArray *)array {
    self.scrollAdView.imageURLStringsGroup = array;
}

@end
