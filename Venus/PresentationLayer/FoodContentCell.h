//
//  FoodContentCell.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureUrl;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet GMLabel *price;
@property (weak, nonatomic) IBOutlet GMLabel *count;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *add;

@end
