//
//  DisplayImageController.h
//  RenoMate
//
//  Created by yogesh ahlawat on 18/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>
#import "sqlite3.h"
#import "FacebookShareDelegate.h"
#import "FacebookController.h"

@interface DisplayImageController : UIViewController<UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, FacebookShareDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
{
    IBOutlet UIScrollView *containerScrollView;
    IBOutlet UIView *bottomStrip;
    IBOutlet UIToolbar *bottomToolbar;
    IBOutlet UIBarButtonItem *locationButton;

    IBOutlet UILabel *notes;
    NSString *routeDecide;
    UIView *loadingView;
    UIActivityIndicatorView *busyIndicator;

    IBOutlet UIActivityIndicatorView *activity;
    
    UIActionSheet *popupQuery;
    BOOL isFbAuthenticationDoneFirstTime;
    
    int startIndex;
    int endIndex;
    
    BOOL visible;
    float currentZoomScale;
    
    FacebookController *facebookController;
    
    UIAlertView *loadingAlert;
    UIAlertView *dropboxAlert;
}

@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, assign) int currentIndex;

-(void)animateAvtivity;
-(void)FBauthenticationDone;

-(IBAction)optionButtonPressed:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)openLocation:(id)sender;

@end
