//
//  FoodAddressSelectionViewController.h
//  Venus
//
//  Created by EdwinZhou on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodAddressSelectionViewController;

@protocol FoodAddressSelectionViewControllerDelegate <NSObject>

- (void)foodAddressSelectionViewController:(FoodAddressSelectionViewController *)vc didSelectIndex:(NSInteger)index;

@end

@interface FoodAddressSelectionViewController : UIViewController

@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) NSString *restaurantID;
@property (weak, nonatomic) id<FoodAddressSelectionViewControllerDelegate> delegate;

@end
