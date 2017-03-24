//
//  ProductDetailV2PanelView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ProductDetailV2PanelView.h"

@interface ProductDetailV2PanelView()
{
    UIView *indicatorView;
    UIButton *prevButton;
}

@end

@implementation ProductDetailV2PanelView

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
//    self.backgroundColor = [UIColor colorWithRed:226.0f/255 green:226.0f/255 blue:226.0f/255 alpha:1.0];
    
    UIImageView *vs1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    UIImageView *vs2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    UIImageView *vs3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalSeparator.png"]];
    
    vs1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/4, 15, 2, self.frame.size.height - 30);
    vs2.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2, 15, 2, self.frame.size.height - 30);
    vs3.frame = CGRectMake(3 * [UIScreen mainScreen].bounds.size.width/4, 15, 2, self.frame.size.height - 30);
//    [self addSubview:vs1];
//    [self addSubview:vs2];
//    [self addSubview:vs3];
    
    float fontSize = 12;
//    if()
//    {
//        
//    }
    float gap = ([UIScreen mainScreen].bounds.size.width - 320) / 5;
    
    UIButton *overviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overviewButton setTitle:NSLocalizedString(kOverView, nil) forState:UIControlStateNormal];
    [overviewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [overviewButton setBackgroundColor:[UIColor whiteColor]];
    overviewButton.frame = CGRectMake(0, 0, 68 + gap, self.frame.size.height);
    overviewButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    overviewButton.tag = 0;
    [overviewButton addTarget:self action:@selector(overViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    prevButton = overviewButton;
    [self addSubview:overviewButton];
    
    UIButton *explanationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [explanationButton setBackgroundColor:[UIColor whiteColor]];
    [explanationButton setTitle:NSLocalizedString(kDetails, nil) forState:UIControlStateNormal];
    [explanationButton setTitleColor:themeColor forState:UIControlStateNormal];
    explanationButton.frame = CGRectMake(overviewButton.frame.size.width, 0, 56 + gap, self.frame.size.height);
    explanationButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    explanationButton.tag = 1;
    [explanationButton addTarget:self action:@selector(explanationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:explanationButton];
    
    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsButton setBackgroundColor:[UIColor whiteColor]];
    [newsButton setTitle:NSLocalizedString(kNews, nil) forState:UIControlStateNormal];
    [newsButton setTitleColor:themeColor forState:UIControlStateNormal];
    newsButton.frame = CGRectMake(explanationButton.frame.origin.x + explanationButton.frame.size.width, 0, 40 + gap, self.frame.size.height);
    newsButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    newsButton.tag = 2;
    [newsButton addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newsButton];
    
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reviewButton setBackgroundColor:[UIColor whiteColor]];
    [reviewButton setTitle:@"REVIEWS" forState:UIControlStateNormal];
    [reviewButton setTitleColor:themeColor forState:UIControlStateNormal];
    reviewButton.frame = CGRectMake(newsButton.frame.origin.x + newsButton.frame.size.width, 0, 60 + gap, self.frame.size.height);
    reviewButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    reviewButton.tag = 3;
    [reviewButton addTarget:self action:@selector(reviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reviewButton];
    
    UIButton *alternateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alternateButton setBackgroundColor:[UIColor whiteColor]];
    [alternateButton setTitle:@"ALTERNATIVES" forState:UIControlStateNormal];
    [alternateButton setTitleColor:themeColor forState:UIControlStateNormal];
    alternateButton.frame = CGRectMake(reviewButton.frame.origin.x + reviewButton.frame.size.width, 0, 90 + gap, self.frame.size.height);
    alternateButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    alternateButton.tag = 4;
    [alternateButton addTarget:self action:@selector(alternativeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alternateButton];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, [UIScreen mainScreen].bounds.size.width/4, 5)];
    indicatorView.backgroundColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
//    [self addSubview:indicatorView];
}

-(void)overViewButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(delegate)
    {
        [delegate overViewButtonAction];
    }
}

-(void)explanationButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(delegate)
    {
        [delegate explanataionButtonAction];
    }
}

-(void)newsButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(delegate)
    {
        [delegate newsButtonAction];
    }
}

-(void)alternativeButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(delegate)
    {
        [delegate alternativeButtonAction];
    }
}

-(void)reviewButtonAction:(UIButton*)button
{
    [self moveIndicatorViewAccotdingToButton:button];
    if(delegate)
    {
        [delegate reviewButtonAction];
    }
}

-(void)moveIndicatorViewAccotdingToButton:(UIButton*)button
{
    if(prevButton)
    {
        [prevButton setTitleColor:themeColor forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    prevButton = button;
}

@end
