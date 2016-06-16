//
//  OrderDescribeCell.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDescribeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailButton;

@end
