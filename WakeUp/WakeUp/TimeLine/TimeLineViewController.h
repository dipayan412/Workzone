//
//  TimeLineViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface TimeLineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UIView *topBarView;
    IBOutlet UIButton *timeLineSwitchButton;
    IBOutlet UIButton *alarmButton;
    
    IBOutlet UIView *shortMessageTextBoxView;
    IBOutlet UIView *messageBGView;
    IBOutlet UIView *textViewContainerView;
    IBOutlet UIView *messageBoxLowerContainerView;
    IBOutlet UIImageView *recipientImageView;
    IBOutlet UILabel *recipientNameLabel;
    IBOutlet UILabel *recipientModeLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *characterCountLabel;
    IBOutlet UITextView *messageTextView;
    
    IBOutlet UIView *fullScreenImageBGView;
    IBOutlet UIImageView *fullScreenImageView;
}

@property (nonatomic, strong) id <DrawerViewDelegate> drawerViewDelegate;

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)timeLineSwitchButtonAction:(UIButton*)sender;
-(IBAction)alarmButtonAction:(UIButton*)sender;
-(IBAction)sendMessageButtonAction:(UIButton*)sender;
-(IBAction)shortMessageBoxBGTap:(UIControl*)sender;

-(IBAction)dismissFullScreenImage:(id)sender;
@end
