//
//  RA_NewsDetailViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_NewsDetailViewController.h"

@interface RA_NewsDetailViewController ()

@property (nonatomic, retain) NSString *receivedUrl;

@end

@implementation RA_NewsDetailViewController

@synthesize receivedUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUrlString:(NSString*)_url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.receivedUrl = _url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // creating the request and showing it on the webView. This link is from the previous page's selected feed's link
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.receivedUrl]];
    [containerWebView loadRequest:req];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [containerWebView stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark webview delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //if loading started show network is working
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //if loading completed show network is not working
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
