//
//  GMMeTakeAwayRefundReasonCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMeTakeAwayRefundReasonCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
