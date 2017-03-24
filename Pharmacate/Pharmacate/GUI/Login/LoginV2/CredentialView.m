//
//  CredentialView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/29/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "CredentialView.h"

@interface CredentialView() <UITextFieldDelegate>
{
    UITextField *emailField;
    UITextField *passwordField;
    
    UIButton *checkBoxButton;
    UIButton *fbButton;
    UIButton *googleButton;
    UIButton *skipSignInButton;
    
    BOOL isCheckBoxSelected;
}

@end

@implementation CredentialView

@synthesize delegate;
@synthesize googleButtonFrame;

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
    self.backgroundColor = [UIColor whiteColor];
    
    isCheckBoxSelected = YES;
    
//    NSLog(@"%f",self.frame.size.width);
    float gap = 50;
    float buttonWidth = (self.frame.size.width - 3*gap) / 2;
    
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"facebookButton.png"] forState:UIControlStateNormal];
    fbButton.frame = CGRectMake(gap, 5, buttonWidth, buttonWidth*0.42);
    [fbButton addTarget:self action:@selector(facebookButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fbButton];
    
    googleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [googleButton setBackgroundImage:[UIImage imageNamed:@"googleButton.png"] forState:UIControlStateNormal];
    self.googleButtonFrame = CGRectMake(fbButton.frame.size.width + fbButton.frame.origin.x + gap, fbButton.frame.origin.y, buttonWidth, buttonWidth*0.42);
    googleButton.frame = CGRectMake(fbButton.frame.size.width + fbButton.frame.origin.x + gap, fbButton.frame.origin.y, buttonWidth, buttonWidth*0.42);
    [googleButton addTarget:self action:@selector(googleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:googleButton];
    
//    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitterButton.png"] forState:UIControlStateNormal];
//    twitterButton.frame = CGRectMake(self.googleButtonFrame.size.width + self.googleButtonFrame.origin.x + gap, fbButton.frame.origin.y, buttonWidth, buttonWidth*0.42);
//    [twitterButton addTarget:self action:@selector(twitterButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:twitterButton];
    
//    emailField = [[UITextField alloc] initWithFrame:CGRectMake(13, fbButton.frame.origin.y + fbButton.frame.size.height + 20, [UIScreen mainScreen].bounds.size.width - 26, 40)];
//    emailField.backgroundColor = [UIColor clearColor];
//    emailField.placeholder = [NSString stringWithFormat:@"Email Address"];
//    emailField.delegate = self;
//    emailField.borderStyle = UITextBorderStyleNone;
//    emailField.keyboardType = UIKeyboardTypeEmailAddress;
//    emailField.textAlignment = NSTextAlignmentCenter;
//    emailField.autocorrectionType = UITextAutocapitalizationTypeNone;
//    
//    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(13, emailField.frame.origin.y + emailField.frame.size.height + 20, [UIScreen mainScreen].bounds.size.width - 26, 40)];
//    passwordField.backgroundColor = [UIColor clearColor];
//    passwordField.placeholder = [NSString stringWithFormat:@"Password"];
//    passwordField.delegate = self;
//    passwordField.borderStyle = UITextBorderStyleNone;
//    passwordField.keyboardType = UIKeyboardTypeDefault;
//    passwordField.textAlignment = NSTextAlignmentCenter;
//    passwordField.secureTextEntry = YES;
//    
//    CALayer *border = [CALayer layer];
//    CGFloat borderWidth = 1;
//    border.borderColor = [UIColor lightGrayColor].CGColor;
//    border.frame = CGRectMake(0, emailField.frame.size.height - borderWidth, emailField.frame.size.width, emailField.frame.size.height);
//    border.borderWidth = borderWidth;
//    [emailField.layer addSublayer:border];
//    
//    CALayer *leftBorder = [CALayer layer];
//    leftBorder.frame = CGRectMake(0.0f, emailField.frame.size.height - 5, 1.0f, 5.0f);
//    leftBorder.borderColor = [UIColor lightGrayColor].CGColor;
//    leftBorder.borderWidth = 1;
//    [emailField.layer addSublayer:leftBorder];
//    
//    CALayer *rightBorder = [CALayer layer];
//    rightBorder.frame = CGRectMake(emailField.frame.size.width - 1, emailField.frame.size.height - 5, 1.0f, 5.0f);
//    rightBorder.borderColor = [UIColor lightGrayColor].CGColor;
//    rightBorder.borderWidth = 1;
//    [emailField.layer addSublayer:rightBorder];
//    
//    CALayer *borderPass = [CALayer layer];
//    borderPass.borderColor = [UIColor lightGrayColor].CGColor;
//    borderPass.frame = CGRectMake(0, passwordField.frame.size.height - borderWidth, passwordField.frame.size.width, passwordField.frame.size.height);
//    borderPass.borderWidth = 1.0f;
//    [passwordField.layer addSublayer:borderPass];
//    
//    CALayer *leftBorderPass = [CALayer layer];
//    leftBorderPass.frame = CGRectMake(0.0f, passwordField.frame.size.height - 5, 1.0f, 5.0f);
//    leftBorderPass.borderColor = [UIColor lightGrayColor].CGColor;
//    leftBorderPass.borderWidth = borderWidth;
//    [passwordField.layer addSublayer:leftBorderPass];
//    
//    CALayer *rightBorderPass = [CALayer layer];
//    rightBorderPass.frame = CGRectMake(passwordField.frame.size.width - 1, passwordField.frame.size.height - 5, 1.0f, 5.0f);
//    rightBorderPass.borderColor = [UIColor lightGrayColor].CGColor;
//    rightBorderPass.borderWidth = borderWidth;
//    [passwordField.layer addSublayer:rightBorderPass];
//    
//    emailField.layer.masksToBounds = YES;
//    [self addSubview:emailField];
//    passwordField.layer.masksToBounds = YES;
//    [self addSubview:passwordField];
//    
//    float cornerRadius = 5.0f;
//    
//    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    signInButton.frame = CGRectMake(passwordField.frame.origin.x + 50, passwordField.frame.origin.y + passwordField.frame.size.height + 15, 120, 120*0.42);
//    signInButton.tintColor= [UIColor whiteColor];
//    signInButton.titleLabel.textColor = [UIColor whiteColor];
//    [signInButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
//    signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
//    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [signInButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    signInButton.backgroundColor = [UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f];
//    signInButton.layer.cornerRadius = cornerRadius;
//    [signInButton addTarget:self action:@selector(signInButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:signInButton];
//    
//    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    signUpButton.frame = CGRectMake(googleButton.frame.origin.x, passwordField.frame.origin.y + passwordField.frame.size.height + 15, 120, 120*0.42);
//    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
//    signUpButton.titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
//    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    signUpButton.backgroundColor = [UIColor colorWithRed:145.0f/255 green:195.0f/255 blue:238.0f/255 alpha:1.0f];
//    signUpButton.layer.cornerRadius = cornerRadius;
//    [signUpButton addTarget:self action:@selector(signUpButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:signUpButton];
//    
//    UIButton *forgotPass = [UIButton buttonWithType:UIButtonTypeCustom];
//    [forgotPass setTitle:@"Forgot Password" forState:UIControlStateNormal];
//    [forgotPass setTitleColor:[UIColor colorWithRed:227.0f/255 green:69.0f/255 blue:84.0f/255 alpha:1.0f] forState:UIControlStateNormal];
//    [forgotPass setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    forgotPass.frame = CGRectMake(self.frame.size.width/2 - 70, signInButton.frame.origin.y + signInButton.frame.size.height + 40, 140, 15);
//    [forgotPass addTarget:self action:@selector(forgotPassWordButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:forgotPass];
    
    checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBoxButton.frame = CGRectMake(fbButton.frame.origin.x, fbButton.frame.origin.y + fbButton.frame.size.height + 30, 22, 22);
    [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkBox_selected.png"] forState:UIControlStateNormal];
    [checkBoxButton addTarget:self action:@selector(checkBoxButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkBoxButton];
    
    UILabel *agreeText = [[UILabel alloc] initWithFrame:CGRectMake(checkBoxButton.frame.origin.x + checkBoxButton.frame.size.width + 10, checkBoxButton.frame.origin.y, 75, 22)];
    agreeText.text = NSLocalizedString(kTermsTextKey, nil);
    agreeText.textAlignment = NSTextAlignmentLeft;
    agreeText.textColor = [UIColor blackColor];
    agreeText.backgroundColor = [UIColor clearColor];
    agreeText.font = [UIFont systemFontOfSize:11.0f];
    
    UIButton *termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    termsButton.frame = CGRectMake(agreeText.frame.origin.x + agreeText.frame.size.width, agreeText.frame.origin.y, 120, 22);
    termsButton.backgroundColor = [UIColor clearColor];
    [termsButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    termsButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    termsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    termsButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    [termsButton addTarget:self action:@selector(termsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:termsButton];
    [self addSubview:agreeText];
    
    NSMutableAttributedString *termsString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(kTermsButtonTextKey, nil)];
    [termsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [termsString length])];
    [termsButton setAttributedTitle:termsString forState:UIControlStateNormal];
    
    skipSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipSignInButton setTitle:NSLocalizedString(kGuestKey, nil) forState:UIControlStateNormal];
    [skipSignInButton setTitleColor:themeColor forState:UIControlStateNormal];
    [skipSignInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    skipSignInButton.frame = CGRectMake(self.frame.size.width/2 - 80, self.frame.size.height - 60, 160, 15);
    [skipSignInButton addTarget:self action:@selector(skipSignInButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skipSignInButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(delegate)
    {
        if(textField == emailField)
        {
            [delegate emailFieldEndedEditing:textField.text];
        }
        else if(textField == passwordField)
        {
            [delegate passWordFieldEndedEditing:textField.text];
        }
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(delegate)
    {
        if(textField == emailField)
        {
            [delegate emailFieldEndedEditing:textField.text];
        }
        else if(textField == passwordField)
        {
            [delegate passWordFieldEndedEditing:textField.text];
        }
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)checkBoxButtonAction
{
    isCheckBoxSelected = !isCheckBoxSelected;
    if(isCheckBoxSelected)
    {
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkBox_selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checkBox_deSelected.png"] forState:UIControlStateNormal];
    }
    fbButton.hidden = !isCheckBoxSelected;
    googleButton.hidden = !isCheckBoxSelected;
    skipSignInButton.hidden = !isCheckBoxSelected;
}

-(void)termsButtonAction
{
    if(delegate)
    {
        [delegate termsButtonAction];
    }
}

-(void)facebookButtonAction
{
    if(delegate)
    {
        [delegate facebookButtonAction];
    }
}

-(void)googleButtonAction
{
    if(delegate)
    {
        [delegate googleButtonAction];
    }
}

-(void)twitterButtonAction
{
    if(delegate)
    {
        [delegate twitterButtonAction];
    }
}

-(void)skipSignInButtonAction
{
    if(delegate)
    {
        [delegate skipSignInButtonAction];
    }
}

-(void)forgotPassWordButtonAction
{
    if(delegate)
    {
        [delegate forgotPassWordButtonAction];
    }
}

-(void)signInButtonAction
{
    if(delegate)
    {
        [delegate emailFieldEndedEditing:emailField.text];
        [delegate passWordFieldEndedEditing:passwordField.text];
        [delegate signInButtonAction];
    }
    
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void)signUpButtonAction
{
    if(delegate)
    {
        [delegate signUpButtonAction];
    }
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

@end
