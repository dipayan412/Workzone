//
//  PanelView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/9/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "PanelView.h"

@interface PanelView()
{
    UIView *indicatorView;
}

@end

@implementation PanelView

@synthesize delegate;
@synthesize userInfoButtonAction;
@synthesize diseaseButtonAction;
@synthesize allergyButtonAction;

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
    float buttonHeight = self.frame.size.height/4;
    float buttonWidth = self.frame.size.width;
    
//    UIControl *backButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    backButtonAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ThemeColorBackButton.png"]];
////    backButtonAction.backgroundColor = [UIColor greenColor];
//    [backButtonAction addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:backButtonAction];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 60/2 - 45/2, 45, 45);;
    [backButton setBackgroundImage:[UIImage imageNamed:@"ThemeColorBackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    userInfoButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, buttonHeight, buttonWidth, buttonHeight)];
    userInfoButtonAction.backgroundColor = [UIColor clearColor];
    [userInfoButtonAction addTarget:self action:@selector(userInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    userInfoButtonAction.tag = 1;
    [self addSubview:userInfoButtonAction];
    
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    userInfoLabel.text = NSLocalizedString(kProfilePanelInfo, nil);
    userInfoLabel.textColor = themeColor;
    userInfoLabel.backgroundColor = [UIColor clearColor];
    userInfoLabel.numberOfLines = 2;
    userInfoLabel.minimumScaleFactor = 0.5f;
    userInfoLabel.adjustsFontSizeToFitWidth = YES;
    [userInfoButtonAction addSubview:userInfoLabel];
    
    UIControl *productButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, userInfoButtonAction.frame.origin.y + userInfoButtonAction.frame.size.height, buttonWidth, buttonHeight)];
    productButtonAction.backgroundColor = [UIColor clearColor];
    [productButtonAction addTarget:self action:@selector(productButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    productButtonAction.tag = 2;
//    [self addSubview:productButtonAction];
    
    UILabel *productButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonHeight, buttonWidth)];
    productButtonLabel.text = @"Products";
    productButtonLabel.textColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
    productButtonLabel.backgroundColor = [UIColor clearColor];
    productButtonLabel.numberOfLines = 2;
    productButtonLabel.minimumScaleFactor = 0.5f;
    productButtonLabel.adjustsFontSizeToFitWidth = YES;
    [productButtonAction addSubview:productButtonLabel];
    
    diseaseButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, userInfoButtonAction.frame.origin.y + userInfoButtonAction.frame.size.height, buttonWidth, buttonHeight)];
    diseaseButtonAction.backgroundColor = [UIColor clearColor];
    [diseaseButtonAction addTarget:self action:@selector(diseaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    diseaseButtonAction.tag = 2;
    [self addSubview:diseaseButtonAction];
    
    UILabel *diseaseButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    diseaseButtonLabel.text = NSLocalizedString(kProfilePanelDisease, nil);
    diseaseButtonLabel.textColor = themeColor;
    diseaseButtonLabel.backgroundColor = [UIColor clearColor];
    diseaseButtonLabel.numberOfLines = 1;
    diseaseButtonLabel.minimumScaleFactor = 0.5f;
    diseaseButtonLabel.adjustsFontSizeToFitWidth = YES;
    [diseaseButtonAction addSubview:diseaseButtonLabel];
    
    allergyButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, diseaseButtonAction.frame.origin.y + diseaseButtonAction.frame.size.height, buttonWidth, buttonHeight)];
    allergyButtonAction.backgroundColor = [UIColor clearColor];
    [allergyButtonAction addTarget:self action:@selector(allergyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    allergyButtonAction.tag = 3;
    [self addSubview:allergyButtonAction];
    
    UILabel *allergyButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    allergyButtonLabel.text = NSLocalizedString(kProfilePanelAllergy, nil);
    allergyButtonLabel.textColor = themeColor;
    allergyButtonLabel.backgroundColor = [UIColor clearColor];
    allergyButtonLabel.numberOfLines = 2;
    allergyButtonLabel.minimumScaleFactor = 0.5f;
    allergyButtonLabel.adjustsFontSizeToFitWidth = YES;
    [allergyButtonAction addSubview:allergyButtonLabel];
    
    UIControl *allergyProductButtonAction = [[UIControl alloc] initWithFrame:CGRectMake(0, allergyButtonAction.frame.origin.y + allergyButtonAction.frame.size.height, buttonWidth, buttonHeight)];
    allergyProductButtonAction.backgroundColor = [UIColor clearColor];
    [allergyProductButtonAction addTarget:self action:@selector(allergyProductButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    allergyProductButtonAction.tag = 5;
//    [self addSubview:allergyProductButtonAction];
    
    UILabel *allergyProductButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonHeight, buttonWidth)];
    allergyProductButtonLabel.text = @"Allergic Products";
    allergyProductButtonLabel.textColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
    allergyProductButtonLabel.backgroundColor = [UIColor clearColor];
    allergyProductButtonLabel.numberOfLines = 2;
    allergyProductButtonLabel.minimumScaleFactor = 0.5f;
    allergyProductButtonLabel.adjustsFontSizeToFitWidth = YES;
    [allergyProductButtonAction addSubview:allergyProductButtonLabel];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth - 5, userInfoButtonAction.frame.origin.y, 5, buttonHeight)];
    indicatorView.backgroundColor = themeColor;
    [self addSubview:indicatorView];
}

-(void)backButtonAction
{
    if(delegate)
    {
        [delegate backButtonAction];
    }
}

-(void)userInfoButtonAction:(UIControl*)control
{
    [self moveIndicatorViewAccotdingToControl:control];
    if(delegate)
    {
        [delegate userInfoButtonAction];
    }
}

-(void)productButtonAction:(UIControl*)control
{
    [self moveIndicatorViewAccotdingToControl:control];
    if(delegate)
    {
        [delegate productButtonAction];
    }
}

-(void)diseaseButtonAction:(UIControl*)control
{
    [self moveIndicatorViewAccotdingToControl:control];
    if(delegate)
    {
        [delegate diseaseButtonAction];
    }
}

-(void)allergyButtonAction:(UIControl*)control
{
    [self moveIndicatorViewAccotdingToControl:control];
    if(delegate)
    {
        [delegate allergyButtonAction];
    }
}

-(void)allergyProductButtonAction:(UIControl*)control
{
    [self moveIndicatorViewAccotdingToControl:control];
    if(delegate)
    {
        [delegate allergyProductButtonAction];
    }
}

-(void)moveIndicatorViewAccotdingToControl:(UIControl*)control
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = indicatorView.frame;
    frame.origin.y = control.tag * control.frame.size.height;
    indicatorView.frame = frame;
    
    [UIView commitAnimations];
}

@end
