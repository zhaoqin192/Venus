//
//  BeautyDetailHeaderView.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautyDetailHeaderView.h"
#import "BeautifulFood.h"

@interface BeautyDetailHeaderView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet UIView *babyView;
@property (weak, nonatomic) IBOutlet UIView *shopView;
@property (weak, nonatomic) IBOutlet GMLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *waiView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *locateView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation BeautyDetailHeaderView

- (void)awakeFromNib {
    [self configureSegmentView];
}

- (void)configureSegmentView {
    self.selectView = self.shopView;
    [self configureSelectWithView:self.shopView select:YES];
    [self configureSelectWithView:self.babyView select:NO];
    [self configureSelectWithView:self.commitView select:NO];
    
    self.shopView.userInteractionEnabled = YES;
    [self.shopView bk_whenTapped:^{
        NSLog(@"shop");
        [self configureViewTapped:self.shopView];
    }];
    
    self.babyView.userInteractionEnabled = YES;
    [self.babyView bk_whenTapped:^{
        NSLog(@"babay");
        [self configureViewTapped:self.babyView];
    }];
    
    self.commitView.userInteractionEnabled = YES;
    [self.commitView bk_whenTapped:^{
        [self configureViewTapped:self.commitView];
    }];
    
    [self.homeButton bk_whenTapped:^{
        if (self.homeButtonClicked) {
            self.homeButtonClicked();
        }
    }];
}

- (void)setIsNoWaiView:(BOOL)isNoWaiView {
    _isNoWaiView = isNoWaiView;
    if (_isNoWaiView) {
        self.topConstraint.constant = 0;
    }
    else {
        self.topConstraint.constant = 54;
        [self.waiView bk_whenTapped:^{
            if (self.waiViewTapped) {
                self.waiViewTapped();
            }
        }];
    }
    [self layoutIfNeeded];
}

- (void)configureViewTapped:(UIView *)view {
    NSLog(@"configure tapped");
    if (self.selectView == view) {
        return ;
    }
    else {
        NSLog(@"%d",view.tag/10 -1);
        [self configureSelectWithView:self.selectView select:NO];
        self.selectView = view;
        [self configureSelectWithView:self.selectView select:YES];
        if (self.segmentButtonClicked) {
            self.segmentButtonClicked(view.tag/10 -1);
        }
    }
}

- (void)configureSelectWithView:(UIView *)view select:(BOOL)select {
    if (select) {
        UILabel *label = [view viewWithTag:view.tag + 2];
        [label setTextColor:GMBrownColor];
        UIView *lineView = [view viewWithTag:view.tag + 3];
        lineView.backgroundColor = GMBrownColor;
        lineView.hidden = NO;
        UIImageView *imageView = [view viewWithTag:view.tag + 1];
        imageView.image = [UIImage imageNamed:@"店铺选中"];
        if (view.tag == 20) {
            imageView.image = [UIImage imageNamed:@"全部宝贝选中"];
        }
        if (view.tag == 30) {
            imageView.image = [UIImage imageNamed:@"评价选中"];
        }
    }
    else {
        UILabel *label = [view viewWithTag:view.tag + 2];
        [label setTextColor:GMFontColor];
        UIView *lineView = [view viewWithTag:view.tag + 3];
        lineView.hidden = YES;
        UIImageView *imageView = [view viewWithTag:view.tag + 1];
        imageView.image = [UIImage imageNamed:@"店铺"];
        if (view.tag == 20) {
            imageView.image = [UIImage imageNamed:@"全部宝贝"];
        }
        if (view.tag == 30) {
            imageView.image = [UIImage imageNamed:@"评价"];
        }
    }
}

+ (instancetype)headView {
    BeautyDetailHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BeautyDetailHeaderView class]) owner:nil options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (IBAction)returnButtonClicked:(id)sender {
    if (self.returnButtonClicked) {
        self.returnButtonClicked();
    }
}

- (void)setFoodModel:(BeautifulFood *)foodModel {
    _foodModel = foodModel;
   // [self.iconView sd_setImageWithURL:[NSURL URLWithString:foodModel.shopLogo]];
    self.nameLabel.text = foodModel.shopName;
    self.phoneNumLabel.text = [NSString stringWithFormat:@"%@",foodModel.phone];
    self.locationLabel.text = [NSString stringWithFormat:@"%@",foodModel.location];
}

@end
