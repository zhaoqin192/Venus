//
//  GMMeTakeAwayDetailInfoCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/30.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMeTakeAwayDetailInfoCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;

@end
