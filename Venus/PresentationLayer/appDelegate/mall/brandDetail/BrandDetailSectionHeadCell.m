//
//  BrandDetailSectionHeadCell.m
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailSectionHeadCell.h"

@interface BrandDetailSectionHeadCell()

@property (nonatomic, strong) UIView *selectView;


@end

@implementation BrandDetailSectionHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectView = self.detailView;
    UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapAction)];
    [self.detailView addGestureRecognizer:detailTap];
    
    UITapGestureRecognizer *kindTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kindTapAction)];
    [self.kindView addGestureRecognizer:kindTap];
    
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction)];
    [self.commentView addGestureRecognizer:commentTap];
}

- (void)detailTapAction {
    if (self.selectView == self.detailView) {
        return;
    }
    [self detailSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBrandDetail" object:nil];
}

- (void)kindTapAction {
    if (self.selectView == self.kindView) {
        return;
    }
    [self kindSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBrandKind" object:nil];
}

- (void)commentTapAction {
    if (self.selectView == self.commentView) {
        return;
    }
    [self commentSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBrandComment" object:nil];
}

- (void)clearAllTap {
    self.detailImage.image = [UIImage imageNamed:@"店铺"];
    [self.detailButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    
    self.kindImage.image = [UIImage imageNamed:@"全部宝贝"];
    [self.kindButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    
    self.commentImage.image = [UIImage imageNamed:@"评价"];
    [self.commentButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
}

- (void)detailSelected {
    [self clearAllTap];
    self.detailImage.image = [UIImage imageNamed:@"店铺选中"];
    [self.detailButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
    self.selectView = self.detailView;
}

- (void)kindSelected {
    [self clearAllTap];
    self.kindImage.image = [UIImage imageNamed:@"全部宝贝选中"];
    [self.kindButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
    self.selectView = self.kindView;
}

- (void)commentSelected {
    [self clearAllTap];
    self.commentImage.image = [UIImage imageNamed:@"评价选中"];
    [self.commentButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
    self.selectView = self.commentView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
