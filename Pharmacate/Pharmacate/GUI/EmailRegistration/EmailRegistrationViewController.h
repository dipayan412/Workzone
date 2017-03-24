//
//  EmailRegistrationViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/22/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailRegistrationViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmPasswordField;
    IBOutlet UIView *credentialsView;
}
//@property(nonatomic, strong) NSString *emailAddress;
-(IBAction)singInButtonAction:(UIButton*)button;
-(IBAction)backButtonAction:(UIButton*)button;
@end
