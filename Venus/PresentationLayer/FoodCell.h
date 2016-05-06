//
//  FoodCell.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet UILabel *basePrice;
@property (weak, nonatomic) IBOutlet UILabel *packFee;
@property (weak, nonatomic) IBOutlet UILabel *costTime;

@end
