//
//  LoginPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "UserDefaultsManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DBIListener.h"

@interface LoginPageViewController : UIViewController <UITextFieldDelegate, ASIHTTPRequestDelegate, CLLocationManagerDelegate, DBIListener>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UISwitch *rememberMeSwittch;
    
    IBOutlet UIButton *signInButton;
    
    UIAlertView *loadingView;
    
    CLLocationManager *userLocationManager;
}

- (IBAction)rememberMeSwitchAction:(UISwitch *)sender;
- (IBAction)signInButtonAction:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
