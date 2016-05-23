//
//  FoodContentCell.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodDetail;
@class FoodOrderViewBaseItem;
@interface FoodContentCell : UITableViewCell

@property (strong, nonatomic) FoodOrderViewBaseItem *baseItem;

@property (weak, nonatomic) IBOutlet UIImageView *pictureUrl;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet GMLabel *price;
@property (weak, nonatomic) IBOutlet GMLabel *count;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (nonatomic, strong) FoodDetail *foodModel;
@property (assign, nonatomic) NSInteger foodCount;
@property (nonatomic, assign) BOOL isDisplay;
@end
