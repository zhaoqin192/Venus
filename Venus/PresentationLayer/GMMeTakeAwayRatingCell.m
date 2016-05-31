//
//  GMMeTakeAwayRatingCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayRatingCell.h"

@implementation GMMeTakeAwayRatingCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayRatingCell";
    GMMeTakeAwayRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayRatingCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
