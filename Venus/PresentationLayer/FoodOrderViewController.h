//
//  FoodOrderViewController.h
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodOrderViewController : UIViewController

@property (copy, nonatomic) NSString *restaurantIdentifier;
@property (strong, nonatomic) NSMutableArray *sections;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

- (instancetype)initWithRestaurantIdentifier:(NSString *)identifier;

@end
