//
//  FoodCommitViewController.m
//  Venus
//
//  Created by 王霄 on 16/4/21.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "FoodCommitViewController.h"
#import "FoodCommitCell.h"
#import "NetworkFetcher+Food.h"
#import "Restaurant.h"
#import "CommentManager.h"
#import "Comment.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FoodCommitViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) CommentManager *commentManager;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation FoodCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    _commentManager = [CommentManager sharedManager];
    
    //设置多余的seperator
    [self.myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.myTableView.separatorColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
    
    [NetworkFetcher foodFetcherCommentListWithID:_restaurant.identifier level:@"0" success:^{
        _commentArray = _commentManager.commentArray;
        [_myTableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

- (void)configureTableView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = CGRectMake(0, 0, width, height);
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

#pragma mark <UITableView>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *comment = _commentArray[indexPath.row];
    FoodCommitCell *cell = [FoodCommitCell cellWithTableView:tableView];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatar]];
    cell.nickName.text = comment.nickName;
    cell.content.text = comment.content;
    cell.costTime.text = [NSString stringWithFormat:@"配送时间%@", comment.costTime];
    cell.createTime.text = [self stringToDate:comment.createTime];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

// 分割线不靠左补全
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myTableView) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


-(NSString*)stringToDate:(NSString *)sdateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//在这里a代表上下午
    
    NSTimeInterval time70 = [sdateStr doubleValue]/1000; //time70表示秒数，我们需要转换，1秒为1000毫秒 在这里我们除以1000,转换一下
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time70];
    
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    return str;
}




@end
