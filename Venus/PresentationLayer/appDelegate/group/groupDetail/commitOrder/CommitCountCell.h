//
//  CommitCountCell.h
//  Venus
//
//  Created by zhaoqin on 5/19/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *subtractionButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
