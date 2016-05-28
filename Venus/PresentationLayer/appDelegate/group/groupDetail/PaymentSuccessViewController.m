//
//  PaymentSuccessViewController.m
//  Venus
//
//  Created by zhaoqin on 5/28/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "PersonalCouponViewController.h"
#import "OrderDetailViewController.h"
#import "CouponOrderModel.h"
#import "GroupViewController.h"

@interface PaymentSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation PaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self onClickEvent];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(backToCouponView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)onClickEvent {
    
    @weakify(self)
    [[self.checkButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        orderDetailVC.orderModel = [[CouponOrderModel alloc] init];
        orderDetailVC.orderModel.orderID = self.orderID;
        //声明状态为待使用
        orderDetailVC.state = @0;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    
}

- (void)backToCouponView {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *viewController in allViewControllers) {
        
        if ([viewController isKindOfClass:[GroupViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
    }
    
    
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
