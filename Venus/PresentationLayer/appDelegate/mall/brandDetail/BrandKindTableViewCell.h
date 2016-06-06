//
//  BrandKindTableViewCell.h
//  Venus
//
//  Created by zhaoqin on 6/3/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MerchandiseModel;

@interface BrandKindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (nonatomic, strong) NSString *leftIdentifier;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (nonatomic, strong) NSString *rightIdentifier;

- (void)insertLeftModel:(MerchandiseModel *)leftModel;

- (void)insertLeftModel:(MerchandiseModel *)leftModel rightModel:(MerchandiseModel *)rightModel;

@end
