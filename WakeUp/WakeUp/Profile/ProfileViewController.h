//
//  ProfileViewController.h
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"

@interface ProfileViewController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *userImageView;
    IBOutlet UITextField *userNameField;
    
    IBOutlet UIButton *updateButton;
    IBOutlet UIButton *updateButtonInView;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;

-(IBAction)imageButtonAction:(UIButton*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)updateButtonAction:(UIButton*)sender;
-(IBAction)userColorThemeAction:(UIButton*)sender;

@end
