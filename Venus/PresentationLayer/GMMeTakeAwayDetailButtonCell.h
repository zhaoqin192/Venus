//
//  GMMeTakeAwayDetailButtonCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMeTakeAwayDetailButtonCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *oneMoreOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
