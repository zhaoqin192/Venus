//
//  MeCommitCell.m
//  Venus
//
//  Created by 王霄 on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "MeCommitCell.h"
#import "MeShopCommit.h"
#import "MeCouponCommit.h"

@interface MeCommitCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MeCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.myDetailLabel.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(MeShopCommit *)shopModel {
    _shopModel = shopModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:shopModel.logo]];
    self.nameLabel.text = shopModel.name;
    self.myDetailLabel.hidden = YES;
    self.contentLabel.text = shopModel.content;
    self.timeLabel.text = [self convertTime:@(shopModel.time)];
    [self configureScoreView:shopModel.score];
}

- (void)setCouponModel:(MeCouponCommit *)couponModel {
    _couponModel = couponModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:couponModel.picUrl]];
    self.nameLabel.text = couponModel.abstract;
    self.myDetailLabel.hidden = NO;
    self.myDetailLabel.text = couponModel.des;
    self.contentLabel.text = couponModel.content;
    self.timeLabel.text = [self convertTime:@(couponModel.time)];
    [self configureScoreView:couponModel.score];
}

- (NSString *)convertTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue] / 1000];
    return [date stringWithFormat:@"yyyy-MM-dd"];
}

- (void)configureScoreView:(NSInteger )score {
    for (UIImageView *imageView in self.scoreView.subviews) {
        imageView.image = [UIImage imageNamed:@"Star 灰"];
    }
    for (UIView *view in self.scoreView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            if (imageView.tag <= score) {
                imageView.image = [UIImage imageNamed:@"Star 1"];
            }
        }
    }
}

@end
