//
//  FeedbackViewController.m
//  Robick
//
//  Created by Atif Qayyum Toor on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "iRate.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
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
    // Do any additional setup after loading the view from its nib.
    self.m_navigator.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController:)];
//    self.m_navigator.leftBarButtonItem.tintColor = [UIColor blueColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || 
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
//    } else {
//        return interfaceOrientation == UIInterfaceOrientationPortrait;
//    }
}

- (void) dismissController:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
//    [(AppController *) [[UIApplication sharedApplication] delegate] DismissAll];
    [[iRate sharedInstance] userDidDeclineToRateApp];
}


#pragma mark -
#pragma mark Custom Event Methods

- (IBAction)sendToAppStore:(id)sender {
    
    [[iRate sharedInstance] userDidAttemptToRateApp];
    [self dismissController:self];

//    [(testAppDelegate *) [[UIApplication sharedApplication] delegate] DismissAll];
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
