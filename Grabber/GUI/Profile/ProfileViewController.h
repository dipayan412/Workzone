//
//  RegistrationViewController.h
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextField *emailField;
    
    IBOutlet UIView *registrationBGView;
    IBOutlet UILabel *emailLabel;
    
    IBOutlet UITableView *formTableView;
    
    UIAlertView *loadingAlert;
}

@end
