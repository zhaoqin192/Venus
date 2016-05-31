//
//  GMMeTakeAwayRefundReasonCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayRefundReasonCell.h"

@implementation GMMeTakeAwayRefundReasonCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayRefundReasonCell";
    GMMeTakeAwayRefundReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayRefundReasonCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
