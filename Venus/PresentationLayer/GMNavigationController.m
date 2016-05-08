//
//  GMNavigationController.m
//  Venus
//
//  Created by EdwinZhou on 16/5/8.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMNavigationController.h"

@interface GMNavigationController ()

@end

@implementation GMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
