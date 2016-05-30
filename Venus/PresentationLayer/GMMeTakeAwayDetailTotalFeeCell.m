//
//  GMMeTakeAwayDetailTotalFeeCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayDetailTotalFeeCell.h"

@implementation GMMeTakeAwayDetailTotalFeeCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayDetailTotalFeeCell";
    GMMeTakeAwayDetailTotalFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayDetailTotalFeeCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:NO];
   
}

@end
