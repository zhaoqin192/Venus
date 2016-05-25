//
//  FoodPaymentCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/17.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodPaymentCell.h"

@interface FoodPaymentCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@end

@implementation FoodPaymentCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"FoodPaymentCell";
    FoodPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodPaymentCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.selectedImage.image = [UIImage imageNamed:@"selected"];
    } else {
        self.selectedImage.image = [UIImage imageNamed:@"unselected"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:YES];
}

@end
