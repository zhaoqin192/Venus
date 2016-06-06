//
//  KindDetailViewController.m
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "KindDetailViewController.h"
#import "MerchandiseModel.h"
#import "KindDetailHeadCell.h"
#import "KindDetailMessageCell.h"
#import "KindDetailViewModel.h"
#import "MBProgressHUD.h"

@interface KindDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KindDetailViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumber *webViewHeight;
@property (nonatomic, assign) BOOL webViewActive;
@end


@implementation KindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详情";
    
    self.webViewHeight = @176;
    
    [self bindViewModel];
    
    [self.viewModel fetchDetailWithID:[NSNumber numberWithString:self.merchandiseModel.identifier]];
    
}

- (void)bindViewModel {
    
    self.viewModel = [[KindDetailViewModel alloc] init];
    @weakify(self)
    [self.viewModel.detailSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.viewModel.detailFailureObject subscribeNext:^(id x) {
        
    }];
    
    [self.viewModel.errorObject subscribeNext:^(NSString *message) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        [hud hide:YES afterDelay:1.5f];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"fetchHeight" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        NSDictionary *userInfo = notification.userInfo;
        self.webViewHeight = userInfo[@"height"];
        if (!self.webViewActive) {
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            self.webViewActive = YES;
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KindDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[KindDetailHeadCell className]];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.viewModel.headImage] placeholderImage:[UIImage imageNamed:@"default"]];
        cell.titleLabel.text = self.viewModel.itemName;
        cell.marketPriceLabel.text = [NSString stringWithFormat:@"市场价￥:%@", self.viewModel.marketPrice];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.viewModel.price];
        return cell;
    }
    else {
        KindDetailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[KindDetailMessageCell className]];
        if (self.viewModel.detailURL) {
//            [cell loadURL:[@"http://www.chinaworldstyle.com" stringByAppendingString:self.viewModel.detailURL]];
            [cell loadURL:@"http://www.baidu.com"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 450;
    }
    else {
        return [self.webViewHeight floatValue];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        return 10;
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
