//
//  BrandDetailSectionHeadView.h
//  Venus
//
//  Created by zhaoqin on 6/7/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const BrandDetailSectionHeadViewDetail;
extern NSString *const BrandDetailSectionHeadViewKind;
extern NSString *const BrandDetailSectionHeadViewComment;

@interface BrandDetailSectionHeadView : UIView

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *kindView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIImageView *kindImage;
@property (weak, nonatomic) IBOutlet UIButton *kindButton;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

- (void)detailSelected;

- (void)kindSelected;

- (void)commentSelected;

@end
