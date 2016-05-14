//
//  BeautyDetailHeaderView.m
//  Venus
//
//  Created by 王霄 on 16/4/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "BeautyDetailHeaderView.h"
#import "XFSegementView.h"
#import "BeautifulFood.h"

@interface BeautyDetailHeaderView ()<TouchLabelDelegate>{
    XFSegementView *segementView;
}
@property (weak, nonatomic) IBOutlet GMLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *waiView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation BeautyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSegmentView];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureSegmentView];
    }
    return self;
}

- (void)configureSegmentView{
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 296, [UIScreen mainScreen].bounds.size.width, 40)];
    segementView.titleArray = @[@"店铺首页",@"全部宝贝",@"评价"];
    segementView.titleColor = [UIColor lightGrayColor];
    segementView.haveRightLine = YES;
    segementView.separateColor = [UIColor grayColor];
    [segementView.scrollLine setBackgroundColor:GMBrownColor];
    segementView.titleSelectedColor = GMBrownColor;
    segementView.touchDelegate = self;
    segementView.backgroundColor = [UIColor whiteColor];
    [segementView selectLabelWithIndex:0];
    [self addSubview:segementView];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    if (self.segmentButtonClicked) {
        self.segmentButtonClicked(index);
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
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:foodModel.shopLogo]];
    self.nameLabel.text = foodModel.shopName;
    self.phoneNumLabel.text = [NSString stringWithFormat:@"店铺电话：%@",foodModel.phone];
    self.locationLabel.text = [NSString stringWithFormat:@"店铺地址：%@",foodModel.location];
}

@end
