//
//  WebViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDWebViewController.h"
#import <WebKit/WebKit.h>
#import "Constants.h"
#import "GDNetworkController.h"

@interface GDWebViewController () <WKNavigationDelegate> {
    WKWebView *webView;
    NSObject *context;
    UIProgressView *progress;
}

@end

@implementation GDWebViewController

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSString *requestString = [URL absoluteString];
    NSString *lastPathComponent = [URL lastPathComponent];
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)aContext {
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:aContext];
    if (aContext != (__bridge void *)(context)) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:aContext];
        return;
    }
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        progress.progress = [newValue floatValue];
        if (progress.progress == 1) {
            progress.progress = 0;
            [UIView animateWithDuration:0.2 animations:^{
                progress.alpha = 0;
            }];
        } else if (progress.alpha == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                progress.alpha = 1;
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = newValue;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *navBar = self.navigationController.navigationBar;
    progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navBar.frame), CGRectGetWidth(self.view.frame), 4)];
    progress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navBar addSubview:progress];
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    context = [NSObject new];
    void *ctx = (__bridge void *)(context);
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:ctx];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:ctx];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_mode == GDWebViewModeAuthorize) {
        _URLString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?client_id=%@&redirect_uri=%@&scope=no_expiry", kClientID, kRedirectURI];
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URLString]]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [progress removeFromSuperview];
}

- (void)dealloc {
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView removeObserver:self forKeyPath:@"title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
