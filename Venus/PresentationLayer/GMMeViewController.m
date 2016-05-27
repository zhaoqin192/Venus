//
//  GMMeViewController.m
//  Venus
//
//  Created by 王霄 on 16/5/4.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeViewController.h"
#import "GMMeCell.h"
#import "GMMeOrderCell.h"
#import "GMMeInformationViewController.h"
#import "AccountDao.h"
#import "DatabaseManager.h"
#import "Account.h"
#import "GMLoginViewController.h"
#import "GMMeShowIconViewController.h"
#import "GMMeCommitViewController.h"
#import "PersonalCouponViewController.h"

@interface GMMeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *imgUrl;
@end

@implementation GMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.userInteractionEnabled = YES;
    [self.iconView bk_whenTapped:^{
        GMMeShowIconViewController *vc = [[GMMeShowIconViewController alloc] init];
        vc.imgUrl = self.imgUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self configureTableView];
    [self onClickEvent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
    if (![accountDao isLogin]) {
        GMLoginViewController *vc = [[GMLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    [self configureHeadView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)configureHeadView {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] fetchSessionManager];
    NSURL *url = [NSURL URLWithString:[URL_PREFIX stringByAppendingString:@"/terra/customer/info"]];
    NSDictionary *parameters = nil;
    
    [manager GET:url.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        AccountDao *accountDao = [[DatabaseManager sharedInstance] accountDao];
        Account *account = [accountDao fetchAccount];
        account.avatar = responseObject[@"headimg"];
        self.imgUrl = responseObject[@"headimg"];
        account.sex = [responseObject[@"gender"] isEqualToString:@"male"] ? @(1) : @(0);
        account.nickName = responseObject[@"nickname"];
        account.birthday = responseObject[@"birthday"];
        account.realName = responseObject[@"realname"];
        [accountDao save];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
        self.nameLabel.text = account.nickName;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)configureTableView {
    self.tableView.backgroundColor = GMBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GMMeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GMMeCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GMMeOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GMMeOrderCell class])];
}


- (void)onClickEvent {
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showCoupon" object:nil]
    takeUntil:[self rac_willDeallocSignal]]
    subscribeNext:^(id x) {
       
        @strongify(self)
        UIStoryboard *couponOrder = [UIStoryboard storyboardWithName:@"group" bundle:nil];
        PersonalCouponViewController *vc = (PersonalCouponViewController *)[couponOrder instantiateViewControllerWithIdentifier:@"personal"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"showTake" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id x) {
         @strongify(self)
         GMMeCommitViewController *vc = [[GMMeCommitViewController alloc] init];
         [self.navigationController pushViewController:vc animated:YES];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"information"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"information"];
            }
            cell.textLabel.text = @"我的首页";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 1:{
            GMMeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeOrderCell class])];
            return cell;
            break;
        }
        case 2:{
            GMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeCell class])];
            switch (indexPath.row) {
                case 0:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的评价"];
                    cell.myLabel.text = @"我的评价";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    break;
                }
                case 1:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的收藏"];
                    cell.myLabel.text = @"我的收藏";
                    cell.contentView.backgroundColor = GMBgColor;
                    return cell;
                    break;
                }
                case 2:{
                    cell.myImageView.image = [UIImage imageNamed:@"客户服务"];
                    cell.myLabel.text = @"客户服务";
                    cell.contentView.backgroundColor = GMBgColor;
                    return cell;
                    break;
                }
                case 3:{
                    cell.myImageView.image = [UIImage imageNamed:@"账户中心"];
                    cell.myLabel.text = @"账户中心";
                    cell.contentView.backgroundColor = GMBgColor;
                    return cell;
                    break;
                }
                case 4:{
                    cell.myImageView.image = [UIImage imageNamed:@"我的邀请"];
                    cell.myLabel.text = @"我的邀请";
                    cell.contentView.backgroundColor = GMBgColor;
                    return cell;
                    break;
                }
            }
        }
        case 3:{
            GMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GMMeCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.myImageView.image = [UIImage imageNamed:@"关于我们"];
            cell.myLabel.text = @"关于我们";
            return cell;
            break;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            GMMeInformationViewController *vc = [[GMMeInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 98;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}



@end
