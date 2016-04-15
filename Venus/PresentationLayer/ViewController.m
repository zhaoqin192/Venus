//
//  ViewController.m
//  Venus
//
//  Created by zhaoqin on 4/14/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "ViewController.h"
#import "NetworkFetcher+User.h"

@interface ViewController ()
- (IBAction)login:(id)sender;
- (IBAction)qqLogin:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [NetworkFetcher userLoginWithAccount:@"" password:@"" success:^{
        
    } failure:^(NSString *error) {
        
    }];
    
    
}

- (IBAction)qqLogin:(id)sender {
}
@end
