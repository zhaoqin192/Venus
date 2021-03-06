//
//  CouponOrderTableViewCell.h
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
