//
//  RootTabViewController.m
//  Mars
//
//  Created by 王霄 on 16/4/25.
//  Copyright © 2016年 Muggins_. All rights reserved.
//

#import "RootTabViewController.h"
#import "RDVTabBarItem.h"

#import "GMMeViewController.h"
#import "HomePageViewController.h"
#import "GMNavigationController.h"
#import "IndoorSwitchDemo.h"
#import "WXLifeViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
}

#pragma mark Private_M

- (void)setupViewControllers {
    GMMeViewController *meVC = [[GMMeViewController alloc] init];
    GMNavigationController *meNVC = [[GMNavigationController alloc] initWithRootViewController:meVC];
    
    HomePageViewController *homeVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController];
    GMNavigationController *homeNVC = [[GMNavigationController alloc] initWithRootViewController:homeVC];
    
    IndoorSwitchDemo *mapVC = [[IndoorSwitchDemo alloc] init];
    GMNavigationController *mapNVC = [[GMNavigationController alloc] initWithRootViewController:mapVC];
    
    WXLifeViewController *lifeVC = [[WXLifeViewController alloc] init];
    GMNavigationController *lifeNVC = [[GMNavigationController alloc] initWithRootViewController:lifeVC];
    
    UIViewController *vvc = [[UIViewController alloc] init];
    vvc.view.backgroundColor = [UIColor redColor];
    vvc.tabBarItem.badgeValue = @"1";
    [self setViewControllers:@[homeNVC,mapNVC,vvc,lifeNVC,meNVC]];
    [self customizeTabBarForController];
    self.delegate = self;
}

- (void)customizeTabBarForController {
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    NSArray *tabBarItemImages = @[@"首页", @"逛街", @"分类", @"生活圈",@"我的"];
    NSArray *tabBarItemTitles = @[@"首页", @"逛街", @"分类", @"生活圈",@"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@选中",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        item.selectedTitleAttributes = @{NSForegroundColorAttributeName:GMBrownColor};
        item.unselectedTitleAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        index++;
    }
}

#pragma mark RDVTabBarControllerDelegate

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
