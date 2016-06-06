//
//  BrandDetailCell.m
//  Venus
//
//  Created by zhaoqin on 6/6/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "BrandDetailCell.h"

NSString *const BrandDetailCellIdentifier = @"BrandDetailCell";
NSString *const BrandDetailWebViewHeight = @"BrandDetailWebViewHeight";


@interface BrandDetailCell ()<UIWebViewDelegate>
@property (nonatomic, assign) BOOL allowLoad;
@end

@implementation BrandDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.allowLoad = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadURL:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    CGFloat width = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.width"] floatValue];
    CGRect frame = self.webView.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.webView.frame = frame;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BrandDetailWebViewHeight object:nil userInfo:@{@"height": [NSNumber numberWithFloat:height]}];
    self.allowLoad = NO;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return self.allowLoad;
}

@end
