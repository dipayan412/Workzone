//
//  ContactProfileViewController.h
//  WakeUp
//
//  Created by World on 8/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewControllerDelegate.h"
#import "Contact.h"
#import "SendMessageViewController.h"

@interface ContactProfileViewController : UIViewController <SendMessageViewControllerDelegate>
{
    SendMessageViewController *sendMessageVC;
    
    IBOutlet UILabel *contactNameLabel;
    IBOutlet UIImageView *contactImageView;
    
    IBOutlet UIView *shortMessageTextBoxView;
    IBOutlet UIView *messageBGView;
    IBOutlet UIView *textViewContainerView;
    IBOutlet UIView *messageBoxLowerContainerView;
    IBOutlet UIImageView *recipientImageView;
    IBOutlet UILabel *recipientNameLabel;
    IBOutlet UILabel *characterCountLabel;
    IBOutlet UITextView *messageTextView;
}
@property (nonatomic, assign) id <ContactViewControllerDelegate> delegate;
@property (nonatomic, strong) Contact *contactObject;

-(IBAction)sendGiftButtonAction:(UIButton*)sender;
-(IBAction)sendMessageButtonAction:(UIButton*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;

-(IBAction)sendShortMessageButtonAction:(UIButton*)sender;
-(IBAction)shortMessageBoxBGTap:(UIControl*)sender;

@end
