//
//  MoreViewCell.h
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSArray *moreArray;

@end
