//
//  MerchandiseCollectionViewCell.h
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchandiseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
