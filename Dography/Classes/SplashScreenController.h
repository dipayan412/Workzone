//
//  SplashScreenController.h
//  Whosin
//
//  Created by Kumar Aditya on 09/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <Dropbox/Dropbox.h>

@interface SplashScreenController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIButton *cameraButton;
    IBOutlet UIButton *libraryButton;
    
    BOOL stylePerformed;
}

@property (nonatomic, retain) UIPopoverController *popOver;

-(IBAction)photoGalleryClicked:(id)sender;
-(IBAction)cameraButtonClicked:(id)sender;

@end
