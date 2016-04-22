//
//  HomeIntroduceCell.h
//  Venus
//
//  Created by 王霄 on 16/4/18.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeIntroduceCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) void(^buttonClicked)(UIButton *button);
@end
