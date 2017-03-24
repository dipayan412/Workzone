//
//  LoginViewController.h
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *keepMeSignedInButton;
    IBOutlet UIButton *savePasswordButton;
    IBOutlet UIButton *forgotPasswordButton;
    
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *passwordLabel;
    
    IBOutlet UIView *usernameBGView;
    IBOutlet UIView *passwordBGView;
    
    IBOutlet UIView *customNavigationBarView;
    IBOutlet UIImageView *profileImageView;
    
    BOOL keepLoggedIn;
}

-(IBAction)loginButtonAction:(UIButton*)sender;
-(IBAction)registerButtonAction:(UIButton*)sender;
-(IBAction)keepMeLoginButtonAction:(UIButton*)sender;
-(IBAction)savePasswordButtonAction:(UIButton*)sender;
-(IBAction)backAction:(UIButton*)sender;
-(IBAction)twitterButtonAction:(UIButton*)sender;
-(IBAction)forgotPasswordButtonAction:(UIButton*)sender;

-(IBAction)fbButtonAction:(UIButton*)sender;

@end
