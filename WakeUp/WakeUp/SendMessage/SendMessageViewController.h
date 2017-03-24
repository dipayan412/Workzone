//
//  SendMessageViewController.h
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol SendMessageViewControllerDelegate <NSObject>

-(void)dismissMessageView;

@end

@interface SendMessageViewController : UIViewController <ASIHTTPRequestDelegate>
{
    IBOutlet UIView *shortMessageTextBoxView;
    IBOutlet UIView *messageBGView;
    IBOutlet UIView *textViewContainerView;
    IBOutlet UIView *messageBoxLowerContainerView;
    IBOutlet UIImageView *recipientImageView;
    IBOutlet UILabel *recipientNameLabel;
    IBOutlet UILabel *characterCountLabel;
    IBOutlet UITextView *messageTextView;
}
@property (nonatomic, assign) id <SendMessageViewControllerDelegate> delegate;
@property (nonatomic, strong) Contact *contactObject;

-(IBAction)sendShortMessageButtonAction:(UIButton*)sender;
-(IBAction)shortMessageBoxBGTap:(UIControl*)sender;

@end
