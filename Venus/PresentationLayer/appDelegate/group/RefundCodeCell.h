//
//  RefundCodeCell.h
//  Venus
//
//  Created by zhaoqin on 5/26/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) NSString *codeIdentifier;
@end
