//
//  WebViewController.m
//  Venus
//
//  Created by zhaoqin on 4/27/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end


@implementation WebViewController


- (void)viewDidLoad {
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _webView.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}




@end
