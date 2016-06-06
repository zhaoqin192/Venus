//
//  KindDetailMessageCell.h
//  Venus
//
//  Created by zhaoqin on 6/5/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KindDetailMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)loadURL:(NSString *)url;

@end
