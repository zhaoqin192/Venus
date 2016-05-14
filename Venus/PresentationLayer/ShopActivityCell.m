//
//  ShopActivityCell.m
//  Venus
//
//  Created by 王霄 on 16/4/29.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopActivityCell.h"
#import "Activity.h"

@interface ShopActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

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

- (void)setActivityModel:(Activity *)activityModel {
    _activityModel = activityModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:activityModel.img_url]];
    self.nameLabel.text = activityModel.name;
}

@end
