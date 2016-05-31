//
//  GMMeTakeAwayRatingStarCell.h
//  Venus
//
//  Created by EdwinZhou on 16/5/31.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface GMMeTakeAwayRatingStarCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end
