//
//  LoginV2ViewController.h
//  WakeUp
//
//  Created by World on 7/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginV2ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *nameField;
    IBOutlet UIImageView *proPicImageView;
    IBOutlet UIButton *finishButton;
    
    BOOL isUpdateProfileFinished;
    
    FBLoginView *fbLoginView;
}
-(IBAction)userSelectedColorAction:(UIButton*)sender;

-(IBAction)proPicImageViewButtonAction:(UIButton*)sender;
-(IBAction)loginWithFbButtonAction:(UIButton*)sender;
-(IBAction)finishButtonAction:(UIButton*)sender;
@end
