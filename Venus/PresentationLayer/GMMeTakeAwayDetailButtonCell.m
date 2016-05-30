//
//  GMMeTakeAwayDetailButtonCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayDetailButtonCell.h"

@implementation GMMeTakeAwayDetailButtonCell


+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayDetailButtonCell";
    GMMeTakeAwayDetailButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayDetailButtonCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

@end
