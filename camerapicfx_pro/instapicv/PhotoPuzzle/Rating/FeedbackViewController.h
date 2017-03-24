//
//  FeedbackViewController.h
//  Robick
//
//  Created by Atif Qayyum Toor on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface FeedbackViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UINavigationItem * m_navigator;


- (IBAction)sendToAppStore:(id)sender;

@end
