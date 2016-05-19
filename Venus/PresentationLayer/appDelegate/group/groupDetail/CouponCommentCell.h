//
//  CouponCommentCell.h
//  Venus
//
//  Created by zhaoqin on 5/17/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDWeiXinPhotoContainerView;

@interface CouponCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet SDWeiXinPhotoContainerView *pictureContainView;
@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)updateCollection;

@end
