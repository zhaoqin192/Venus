//
//  BrandViewController.m
//  Venus
//
//  Created by zhaoqin on 5/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandViewController.h"
#import "UMMobClick/MobClick.h"


@interface BrandViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"品牌详情";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://www.chinaworldstyle.com" stringByAppendingString:self.detailURL]]];
    
    [self.webView loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [MobClick beginLogPageView:@"BrandViewController"];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [MobClick endLogPageView:@"BrandViewController"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
