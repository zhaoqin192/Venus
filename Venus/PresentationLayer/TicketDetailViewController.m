//
//  TicketDetailViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "TicketHeaderCell.h"
#import "TicketInformationCell.h"
#import "TicketCountCell.h"
#import "TicketDateCell.h"
#import "TicketCommitCell.h"

@interface TicketDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation TicketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configureTableView {
    self.myTableView.backgroundColor = GMBgColor;
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TicketHeaderCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketInformationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TicketInformationCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketCountCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TicketCountCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketDateCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TicketDateCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketCommitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TicketCommitCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            TicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketHeaderCell class])];
            return cell;
            break;
        }
        case 1:{
            TicketInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketInformationCell class])];
            return cell;
        }
        case 2:{
            TicketCountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketCountCell class])];
            return cell;
        }
        case 3:{
            TicketDateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketDateCell class])];
            return cell;
        }
        case 4:{
            TicketCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TicketCommitCell class])];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 320;
            break;
        case 1:
            return 100;
            break;
        case 2:
            return 76;
            break;
        case 3:
            return 240;
            break;
        case 4:
            return 200;
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}






@end
