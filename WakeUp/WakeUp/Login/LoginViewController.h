//
//  LoginViewController.h
//  WakeUp
//
//  Created by World on 6/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *forgotPasswordButton;
    IBOutlet UISwitch *keepMeLoggedInSwitch;
    IBOutlet UITableView *containerTableView;
}
-(IBAction)loginButtonAction:(UIButton*)sender;
-(IBAction)keepMeLoggedInSwitchValueChanged:(UISwitch*)sender;
-(IBAction)registerButtonAction:(UIButton*)sender;
-(IBAction)forgotPasswordButtonAction:(UIButton*)sender;

@end
