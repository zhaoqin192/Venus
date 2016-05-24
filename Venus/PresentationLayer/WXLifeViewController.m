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
@property (weak, nonatomic) IBOutlet UIImageView *shopView;
@property (weak, nonatomic) IBOutlet UIImageView *foodView;
@property (weak, nonatomic) IBOutlet UIImageView *takeawayView;
@property (weak, nonatomic) IBOutlet UIImageView *couponView;
@end

@implementation WXLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
