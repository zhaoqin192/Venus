//
//  GMMeShowIconViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeShowIconViewController.h"

@interface GMMeShowIconViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GMMeShowIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头像";
    if (self.imgUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
} 

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
