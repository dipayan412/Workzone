//
//  WakeWorldViewController.h
//  WakeUp
//
//  Created by World on 7/21/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface WakeWorldViewController : UIViewController <UITextViewDelegate, ASIHTTPRequestDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextView *statusTextView;
    IBOutlet UIImageView *attachPhotoImageView;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;
-(IBAction)attachPhotoButtonAction:(UIButton*)sender;
-(IBAction)shareButtonAction:(UIButton*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;

@end
