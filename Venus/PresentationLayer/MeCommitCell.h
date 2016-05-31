//
//  MeCommitCell.h
//  Venus
//
//  Created by 王霄 on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeShopCommit;
@class MeCouponCommit;
@class MeMiamiCommit;
@interface MeCommitCell : UITableViewCell
@property (nonatomic, strong) MeShopCommit *shopModel;
@property (nonatomic, strong) MeCouponCommit *couponModel;
@property (nonatomic, strong) MeMiamiCommit *miamiModel;
@end
