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
    
    
    [NetworkFetcher foodFetcherCommentListWithID:_restaurant.identifier level:@"0" success:^{
        _commentArray = _commentManager.commentArray;
        [_myTableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

- (void)configureTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FoodCommitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FoodCommitCell class])];
}

#pragma mark <UITableView>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *comment = _commentArray[indexPath.row];
    FoodCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FoodCommitCell class])];
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

-(NSString*)stringToDate:(NSString *)sdateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];//在这里a代表上下午
    
    NSTimeInterval time70 = [sdateStr doubleValue]/1000; //time70表示秒数，我们需要转换，1秒为1000毫秒 在这里我们除以1000,转换一下
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time70];
    
    NSString *str = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    return str;
}




@end
