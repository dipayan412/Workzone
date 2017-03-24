//
//  YoutubeLoginViewController.h
//  SocialShare
//
//  Created by Ashif on 2/20/14.
//  Copyright (c) 2014 algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"

@protocol YoutubeShareDelegate <NSObject>

-(void)dismissYoutubeShareView;

@end

@interface YoutubeLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    GDataServiceTicket *mUploadTicket;
    
    IBOutlet UIView *videoUploadView;
    IBOutlet UIProgressView *videoUploadProgressView;
    
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *passwordField;
}

@property (nonatomic, unsafe_unretained) id<YoutubeShareDelegate>delegate;

@end
