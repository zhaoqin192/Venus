//
//  PersonalCouponViewController.m
//  Venus
//
//  Created by zhaoqin on 5/25/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "PersonalCouponViewController.h"
#import "CouponUseViewController.h"
#import "CouponPayViewController.h"
#import "CouponCommentViewController.h"
#import "CouponRefundViewController.h"

@interface PersonalCouponViewController ()

@property (weak, nonatomic) IBOutlet UIButton *useButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) CouponUseViewController *useVC;
@property (nonatomic, strong) CouponPayViewController *payVC;
@property (nonatomic, strong) CouponCommentViewController *commentVC;
@property (nonatomic, strong) CouponRefundViewController *refundVC;

@end

@implementation PersonalCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = @"我的团购劵";
    
    self.useVC = [[CouponUseViewController alloc] init];
    [self addChildViewController:self.useVC];
    
    self.payVC = [[CouponPayViewController alloc] init];
    [self addChildViewController:self.payVC];
    
    self.commentVC = [[CouponCommentViewController alloc] init];
    [self addChildViewController:self.commentVC];
    
    self.refundVC = [[CouponRefundViewController alloc] init];
    [self addChildViewController:self.refundVC];
    
    self.useVC.view.frame = CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45);
    [self.view addSubview:self.useVC.view];
    
    self.selectButton = self.useButton;
    
    [self onClickEvent];
    
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
    [[self.useButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectButton == self.useButton) {
            return;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        [self.useButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
        self.selectButton = self.useButton;
        self.useVC.view.frame = CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45);
        [self.view addSubview:self.useVC.view];
    }];
    
    [[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectButton == self.payButton) {
            return;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        [self.payButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
        self.selectButton = self.payButton;
        self.payVC.view.frame = CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45);
        [self.view addSubview:self.payVC.view];

    }];
    
    [[self.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.selectButton == self.commentButton) {
            return;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
        self.selectButton = self.commentButton;
        self.commentVC.view.frame = CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45);
        [self.view addSubview:self.commentVC.view];
        
    }];
    
    [[self.refundButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.selectButton == self.refundButton) {
            return;
        }
        [self.selectButton setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        [self.refundButton setTitleColor:[UIColor colorWithHexString:@"A6873B"] forState:UIControlStateNormal];
        self.selectButton = self.refundButton;
        self.refundVC.view.frame = CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45);
        [self.view addSubview:self.refundVC.view];
        
    }];

    
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
