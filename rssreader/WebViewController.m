//
//  WebViewController.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>
@property (copy, nonatomic) NSString* url;
@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonatomic) UIToolbar* toolBar;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.newsURL];
    [self.webView loadRequest:request];
}

#pragma mark - SetUp

- (void) setUp {
    self.title = @"TUT.BY";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50]
                                              ]];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    UIBarButtonItem* stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
    UIBarButtonItem* forwarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardAction)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIBarButtonItem* launchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(launchAction)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.items = @[forwarButton, flexibleSpace, refreshButton, flexibleSpace, stopButton, flexibleSpace, backButton, flexibleSpace, launchButton];
    [self.view addSubview:self.toolBar];
    
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.toolBar.topAnchor constraintEqualToAnchor:self.webView.bottomAnchor],
                                              [self.toolBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.toolBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.toolBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]];
}

- (void) refreshAction {
    [self.webView reload];
}

- (void) stopAction {
    [self.webView stopLoading];
}

- (void) forwardAction {
    [self.webView goForward];
}

- (void) backAction {
    [self.webView goBack];
}

- (void) launchAction {
    [[UIApplication sharedApplication] openURL:self.newsURL options:@{} completionHandler:nil];
}

@end

