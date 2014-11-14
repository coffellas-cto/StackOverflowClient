//
//  WebViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "Constants.h"
#import "GDNetworkController.h"

@interface WebViewController () <WKNavigationDelegate> {
    WKWebView *webView;
}

@end

@implementation WebViewController

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSString *requestString = [navigationAction.request.URL absoluteString];
    NSString *lastPathComponent = [navigationAction.request.URL lastPathComponent];
    if ([lastPathComponent isEqualToString:@"login_success"]) {
        NSArray *components = [requestString componentsSeparatedByString:@"="];
        if ([components count] > 1) {
            NSString *token = components[1];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"oauth_token"];
            [GDNetworkController setToken:token];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_mode == GDWebViewModeAuthorize) {
        _URLString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?client_id=%@&redirect_uri=%@&scope=no_expiry", kClientID, kRedirectURI];
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URLString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
