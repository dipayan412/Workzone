//
//  RegistrationViewController.h
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextField *emailField;
    
    IBOutlet UIButton *doneButton;
    
    IBOutlet UIView *registrationBGView;
    IBOutlet UILabel *emailLabel;
    
    UIButton *fbButton;
    UIButton *twitterButton;
    
    IBOutlet UIImageView *userPhotoImageView;
    IBOutlet UITableView *formTableView;
    
    IBOutlet UIView *customNavigationBarView;
    
    UIAlertView *loadingAlert;
}

-(IBAction)cancelButtonAction:(id)sender;
-(IBAction)doneButtonAction:(UIButton*)sender;
-(IBAction)fbButtonAction:(UIButton*)sender;
-(IBAction)twitterButtonAction:(UIButton*)sender;
-(IBAction)addPhotoBtnAction:(UIButton*)sender;

@end
