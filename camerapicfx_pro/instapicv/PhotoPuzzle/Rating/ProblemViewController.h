//
//  ProblemViewController.h
//  Robick
//
//  Created by Atif Qayyum Toor on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ProblemViewController : UIViewController <MFMailComposeViewControllerDelegate>


@property (nonatomic, retain) IBOutlet UINavigationItem * m_navigator;


-(IBAction)sendEmail:(id)sender;

@end
