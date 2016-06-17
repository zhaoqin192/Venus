//
//  HomeCategoryCell.h
//  Venus
//
//  Created by 王霄 on 16/4/19.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Adversitement;

@interface HomeCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *mainPicture;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UILabel *button1Label;
@property (weak, nonatomic) IBOutlet UILabel *button2Label;
@property (weak, nonatomic) IBOutlet UILabel *button3Label;
@property (weak, nonatomic) IBOutlet UILabel *button4Label;
@property (weak, nonatomic) IBOutlet UILabel *button5Label;
@property (weak, nonatomic) IBOutlet UILabel *button6Label;
@property (nonatomic, strong) Adversitement *adversitement;

- (void)reloadData;

@end
