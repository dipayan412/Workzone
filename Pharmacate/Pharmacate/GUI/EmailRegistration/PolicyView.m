//
//  PolicyView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/7/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "PolicyView.h"

@interface PolicyView() <UIScrollViewDelegate, UITextViewDelegate, UIWebViewDelegate>
{
    UIButton *agreeButton;
}

@end

@implementation PolicyView

@synthesize delegate;

- (id)initWithFrame:(CGRect)rect
{
    if ((self = [super initWithFrame:rect]))
    {
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    UIControl *backGroundControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backGroundControl.backgroundColor = [UIColor lightGrayColor];
    backGroundControl.alpha = 0.3;
    [backGroundControl addTarget:self action:@selector(backgroundControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backGroundControl];
    
    UITextView *policyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height/2)];
//    policyTextView.backgroundColor = [UIColor redColor];
    policyTextView.text = @"The water receded and the fish died. \n They surfaced by the tens of \n thousands, belly-up, and the stench drifted in the air for weeks.The birds that had fed on the fish had little choice but to abandon Lake Poopó, once Bolivia’s second-largest but now just a dry, salty expanse. Many of the Uru-Murato people, who had lived off its waters for generations, left as well, joining a new global march of refugees fleeing not war or persecution, but climate change.The lake was our mother and our father, said Adrián Quispe, one of five brothers who were working as fishermen and raising families here in Llapallapani. Without this lake, where do we go?The water receded and the fish died. They surfaced by the tens of thousands, belly-up, and the stench drifted in the air for weeks.The birds that had fed on the fish had little choice but to abandon Lake Poopó, once Bolivia’s second-largest but now just a dry, salty expanse. Many of the Uru-Murato people, who had lived off its waters for generations, left as well, joining a new global march of refugees fleeing not war or persecution, but climate change.The lake was our mother and our father, said Adrián Quispe, one of five brothers who were working as fishermen and raising families here in Llapallapani. Without this lake, where do we go?The water receded and the fish died. They surfaced by the tens of thousands, belly-up, and the stench drifted in the air for weeks.The birds that had fed on the fish had little choice but to abandon Lake Poopó, once Bolivia’s second-largest but now just a dry, salty expanse. Many of the Uru-Murato people, who had lived off its waters for generations, left as well, joining a new global march of refugees fleeing not war or persecution, but climate change.The lake was our mother and our father, said Adrián Quispe, one of five brothers who were working as fishermen and raising families here in Llapallapani. Without this lake, where do we go?The water receded and the fish died. They surfaced by the tens of thousands, belly-up, and the stench drifted in the air for weeks.The birds that had fed on the fish had little choice but to abandon Lake Poopó, once Bolivia’s second-largest but now just a dry, salty expanse. Many of the Uru-Murato people, who had lived off its waters for generations, left as well, joining a new global march of refugees fleeing not war or persecution, but climate change.The lake was our mother and our father, said Adrián Quispe, one of five brothers who were working as fishermen and raising families here in Llapallapani. Without this lake, where do we go?";
    policyTextView.scrollEnabled = YES;
    policyTextView.editable = NO;
    policyTextView.font = [UIFont systemFontOfSize:19.0f];
    policyTextView.delegate = self;
//    [self addSubview:policyTextView];
    
    UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, policyTextView.frame.origin.y + policyTextView.frame.size.height, self.frame.size.width, 75)];
    buttonContainerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttonContainerView];
    
    agreeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    agreeButton.frame = CGRectMake(50, 12, 150, 50);
    [agreeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0f]];
    [agreeButton setTitle:@"Agree" forState:UIControlStateNormal];
    agreeButton.backgroundColor = [UIColor clearColor];
    agreeButton.enabled = NO;
    [agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainerView addSubview:agreeButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(self.frame.size.width - 150 - 50, 12, 150, 50);
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:21.0f]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [buttonContainerView addSubview:cancelButton];
    
    NSURL *targetURL = [NSURL URLWithString:@"http://www.auburn.edu/~robicfj/papers/prl110.213001.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    UIWebView *policyWebView = [[UIWebView alloc] initWithFrame:backGroundControl.frame];
    policyWebView.backgroundColor = [UIColor grayColor];
    policyWebView.delegate = self;
    [policyWebView loadRequest:request];
    [self addSubview:policyWebView];
}

-(void)backgroundControlAction
{
    if(delegate)
    {
        [delegate backgroundControlAction];
    }
}

-(void)agreeButtonAction
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        NSLog(@"bottom");
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"1");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    NSLog(@"%@",error);
}

@end
