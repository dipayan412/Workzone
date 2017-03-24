//
//  ForgotPasswordViewController.h
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController 
{
    IBOutlet UITextField *emailField;
}
-(IBAction)bgTap:(id)sender;
-(IBAction)doneButtonAction:(id)sender;

@end
