//
//  SearchResultWebViewController.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/11/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "SearchResultWebViewController.h"

@interface SearchResultWebViewController () <UIWebViewDelegate>
{
    UIWebView *webView;
    UIView *progressView;
}

@end

@implementation SearchResultWebViewController

@synthesize urlString;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    customNavigationBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, customNavigationBar.frame.size.height/2 - 45/2, 45, 45);;
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar addSubview:backButton];
    [self.view addSubview:customNavigationBar];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [customNavigationBar addSubview:separatorLine];
    
    progressView = [[UIView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height - 2, 0, 2)];
    progressView.backgroundColor = themeColor;
    [customNavigationBar addSubview:progressView];
    
    NSURL *targetURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    NSLog(@"url requested %@", urlString);
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, customNavigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self progressbarAnimate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)progressbarAnimate
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.25];
    
    CGRect frame = progressView.frame;
    frame.size.width = 3*[UIScreen mainScreen].bounds.size.width/4;
    progressView.frame = frame;
    
    [UIView commitAnimations];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    if(!webView.isLoading)
    {
        [UIView animateWithDuration:5 animations:^{
            CGRect frame = progressView.frame;
            frame.size.width = [UIScreen mainScreen].bounds.size.width;
            progressView.frame = frame;
        } completion:^(BOOL finished) {
            if(finished)
            {
                progressView.hidden = YES;
            }
        }];
    }
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error
{
    if(!webView.isLoading)
    {
        [UIView animateWithDuration:5 animations:^{
            CGRect frame = progressView.frame;
            frame.size.width = [UIScreen mainScreen].bounds.size.width;
            progressView.frame = frame;
        } completion:^(BOOL finished) {
            if(finished)
            {
                progressView.hidden = YES;
            }
        }];
    }
}

@end
