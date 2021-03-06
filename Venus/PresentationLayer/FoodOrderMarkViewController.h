//
//  FoodOrderMarkViewController.h
//  Venus
//
//  Created by EdwinZhou on 16/5/25.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FoodOrderMarkViewControllerDelegate <NSObject>
@required
- (void)didGetRemark:(NSString *)remark;

@end

@interface FoodOrderMarkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *currentCommentCount;
@property (weak, nonatomic) id<FoodOrderMarkViewControllerDelegate> delegate;
@property (copy, nonatomic) NSString *markContent;

@end
