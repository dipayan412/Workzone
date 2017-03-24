//
//  RegistrationViewController.h
//  WakeUp
//
//  Created by World on 6/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *sexField;
    IBOutlet UITextField *phoneField;
    IBOutlet UITextField *dobField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmPassField;
    
    IBOutlet UIDatePicker *dobPicker;
    IBOutlet UIPickerView *sexPicker;
    
    IBOutlet UITableView *containerTableView;
}
-(IBAction)registerButtonAction:(UIButton*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;

@end
