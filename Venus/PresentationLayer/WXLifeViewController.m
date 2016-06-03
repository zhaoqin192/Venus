//
//  WXLifeViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/11.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "WXLifeViewController.h"
#import "MallViewController.h"
#import "BeautifulFoodViewController.h"
#import "FoodViewController.h"
#import "GroupViewController.h"

@interface WXLifeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopWidth;
@property (weak, nonatomic) IBOutlet UIImageView *shopView;
@property (weak, nonatomic) IBOutlet UIImageView *foodView;
@property (weak, nonatomic) IBOutlet UIImageView *takeawayView;
@property (weak, nonatomic) IBOutlet UIImageView *couponView;
@end

@implementation WXLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSize];
    [self.view layoutIfNeeded];
    
    self.shopView.userInteractionEnabled = YES;
    self.foodView.userInteractionEnabled = YES;
    self.takeawayView.userInteractionEnabled = YES;
    self.couponView.userInteractionEnabled = YES;
    
    __weak typeof(self)weakSelf = self;
    
    [self.shopView bk_whenTapped:^{
        UIStoryboard *mall = [UIStoryboard storyboardWithName:@"mall" bundle:nil];
        MallViewController *mallVC = (MallViewController *)[mall instantiateViewControllerWithIdentifier:@"mall"];
        [weakSelf.navigationController pushViewController:mallVC animated:YES];
    }];
    
    [self.foodView bk_whenTapped:^{
        BeautifulFoodViewController *vc = [[BeautifulFoodViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.takeawayView bk_whenTapped:^{
        FoodViewController *vc = [[FoodViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.couponView bk_whenTapped:^{
        UIStoryboard *group = [UIStoryboard storyboardWithName:@"group" bundle:nil];
        GroupViewController *vc = (GroupViewController *)[group instantiateViewControllerWithIdentifier:@"group"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self configureSize];
}

- (void)configureSize {
    NSInteger width = 150;
    if (kScreenHeight == 568) {
        width = 80;
    }
    if (kScreenHeight == 667) {
        width = 130;
    }
    self.takeWidth.constant = self.shopWidth.constant = self.couponWidth.constant = self.foodWidth.constant = self.takeHeight.constant = self.shopHeight.constant = self.couponHeight.constant = self.foodHeight.constant = width;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
