//
//  ProblemViewController.m
//  Robick
//
//  Created by Atif Qayyum Toor on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProblemViewController.h"
#import "AppDelegate.h"
#import "UIAlertView+Content.h"
#import "iRate.h"

@interface ProblemViewController ()

@end

@implementation ProblemViewController
@synthesize m_navigator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.m_navigator.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController:)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void) dismissController:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//    [(AppController *) [[UIApplication sharedApplication] delegate] DismissAll];
    [[iRate sharedInstance] userDidDeclineToRateApp];
}


-(IBAction)sendEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        [self showAlertWithTextEdit];
    }
    else
    {
        [[UIAlertView alertViewWithTitle: [self applicationName]
                                 message:@"Please check that you can send an email from your device"
                                delegate:self
                       cancelButtonTitle:@"OK"
                      confirmButtonTitle:nil]
         show];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    //[self dismissModalViewControllerAnimated:YES];    
//    [((AppDelegate *) [[UIApplication sharedApplication] delegate]).navController dismissModalViewControllerAnimated:YES];
    
    
    NSLog(@"Resultt %u",result);
    NSLog(@"errorr %@",[error localizedDescription]);
    
    [self dismissModalViewControllerAnimated:YES];

    [[iRate sharedInstance] userDidDeclineToRateApp];
//    [(AppController *) [[UIApplication sharedApplication] delegate] DismissAll];
    
}

- (NSString *) applicationName
{
    NSString * applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if ([applicationName length] == 0)
    {
        applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    }
    return applicationName;
}

- (NSString *) applicationVersion
{
    NSString * applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([applicationVersion length] == 0)
    {
        applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    }
    return applicationVersion;
}

- (void) showAlertWithTextEdit
{
    UITextView * textView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 120.0f)] autorelease];
    textView.backgroundColor = nil;//[UIColor redColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:16];
    [[UIAlertView alertViewWithTitle:@"Please tell us what the problem is below"
                         contentView:textView
                       keepSideRatio:NO
                            delegate:self
                   cancelButtonTitle:@"Cancel"
                  confirmButtonTitle:@"DONE"]
     show];
    [textView becomeFirstResponder];
}


#pragma mark - UIAlertViewDelegate

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIView * contentView = [alertView contentView1];
    if ([contentView isKindOfClass:[UITextView class]])
    {
        void (^onCancel)(void) = ^(){
            [[iRate sharedInstance] userDidDeclineToRateApp];
        };
        if (buttonIndex == 1)
        {
            UITextView * textView = (UITextView *)contentView;
            NSString * text = [textView text];
            if ([text length] > 0)
            {
                NSString *appVersion = [self applicationVersion];
                NSString *osVersion  = [[UIDevice currentDevice] systemVersion];
                NSString *deviceName = [[UIDevice currentDevice] model];
                NSString *systemName = [[UIDevice currentDevice] systemName];
                NSString *body = [NSString stringWithFormat:@"Description of the Problem:\n%@\n\n App Version: %@\n OS Version: %@\n Device Name: %@\n System Name: %@\n", text, appVersion, osVersion, deviceName, systemName];
                
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                [controller setMailComposeDelegate:self];
                [controller setSubject:[NSString stringWithFormat: @"Report on the \"%@\" App", [self applicationName]]];
                [controller setToRecipients: [NSArray arrayWithObject:@"smartappbugreports@gmail.com"] ];
//                SmartAppBugReports
                [controller setMessageBody:body isHTML:NO];
//                [self presentModalViewController:controller animated:YES];
                
                
//                [((AppController *) [[UIApplication sharedApplication] delegate]).navController presentModalViewController:controller animated:YES];
                
                
                
//                [((AppDelegate *) [[UIApplication sharedApplication] delegate]).window dismissModalViewControllerAnimated:YES];// Sher
                [self presentModalViewController:controller animated:YES];
//                [controller release];
            }
            else
            {
                onCancel();
            }
        }
        else
        {
            onCancel();
        }
    }
    else
    {
        [[iRate sharedInstance] userDidRequestReminderToRateApp];
    }
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}

@end
