//
//  BrandDetailCell.h
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const BrandDetailCellIdentifier;
extern NSString *const BrandDetailWebViewHeight;

@interface BrandDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadURL:(NSString *)url;

@end
