//
//  SignInSignUpViewController.h
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInSignUpViewController : UIViewController
{
    IBOutlet UIButton *signInButton;
    IBOutlet UIButton *signUpButton;
}

-(IBAction)signInButtonAction:(UIButton*)btn;
-(IBAction)signUpButtonAction:(UIButton*)btn;

@end
