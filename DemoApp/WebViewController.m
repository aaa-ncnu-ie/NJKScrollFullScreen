//
//  WebViewController.m
//
//  Copyright (c) 2014 Satoshi Asano. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+NJKFullScreenSupport.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self.webView viewController:self];

    self.webView.scrollView.delegate = _scrollProxy;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/macbook-pro/"]]];
}

@end
