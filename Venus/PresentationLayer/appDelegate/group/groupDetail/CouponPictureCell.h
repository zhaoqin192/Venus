//
//  CouponPictureCell.h
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponPictureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *abstract;
@property (weak, nonatomic) IBOutlet UILabel *asPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sales;

@end
