//
//  GMMeTakeAwayCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayCell.h"

@implementation GMMeTakeAwayCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayCell";
    GMMeTakeAwayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayCell" owner:nil options:nil] firstObject];
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
