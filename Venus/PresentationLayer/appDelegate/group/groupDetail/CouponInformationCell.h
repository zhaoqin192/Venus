//
//  CouponInformationCell.h
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *validity;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *useRuleLabel;

@end
