//
//  BackUpViewController.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 11/17/12.
//
//

#import <UIKit/UIKit.h>
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import <MessageUI/MessageUI.h>

@interface BackUpViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSString *email;
    IBOutlet UITextView *warningView;
    IBOutlet UIButton *forAndroidButton;
    BOOL stylePerformed;
}

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

-(IBAction)forAndroidButtonAction:(id)sender;


@end
