//
//  ShopHomeViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/27.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "ShopHomeViewController.h"
#import "ShopCycleCell.h"
#import "HomeIntroduceCell.h"

@interface ShopHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCycleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShopCycleCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeIntroduceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeIntroduceCell class])];
    self.myTableView.tableFooterView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
        imageView.backgroundColor = [UIColor blueColor];
        imageView;
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            ShopCycleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopCycleCell class])];
            return cell;
        }
            break;
        case 1:{
            HomeIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeIntroduceCell class])];
            cell.list = [@[@"1",@"2",@"3",@"4"] mutableCopy];
            cell.buttonClicked = ^(UIButton *button){
                NSLog(@"%ld",(long)button.tag);
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 150;
            break;
        case 1:
            return 150;
            break;
        default:
            break;
    }
    return 0;
}

@end
