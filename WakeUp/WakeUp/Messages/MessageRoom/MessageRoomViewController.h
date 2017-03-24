//
//  MessageRoomViewController.h
//  WakeUp
//
//  Created by World on 7/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxObject.h"
#import "ContactViewControllerDelegate.h"
#import "MessageRoom.h"
#import "Messages.h"

@interface MessageRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UITextView *chatTextView;
    IBOutlet UIView *chatTypeBGView;
    IBOutlet UITableView *containerTableView;
    IBOutlet UIView *headerView;
    IBOutlet UILabel *partnerNameLabel;
    
    UIImage *partnerImage;
}

@property (nonatomic, strong) MessageRoom *messageRoomObject;
@property (nonatomic, assign) id <ContactViewControllerDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)chatSendButtonAction:(UIButton*)sender;

@end
