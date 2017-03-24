//
//  TermsViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/11/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController () <UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation TermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *targetURL = [NSURL URLWithString:termsPdfAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 35, 35);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closeButton.tiff"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
