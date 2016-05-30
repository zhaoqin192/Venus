//
//  GMMeTakeAwayDetailTotalFeeCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMeTakeAwayDetailTotalFeeCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@end
