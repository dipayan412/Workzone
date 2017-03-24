//
//  RatingsViewController.m
//  Robick
//
//  Created by Atif Qayyum Toor on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingsViewController.h"
#import "FeedbackViewController.h"
#import "ProblemViewController.h"
#import "AppDelegate.h"


static NSString *microDJProUrl = @"http://Ez.com/angryboogeritunes";

@interface RatingsViewController ()

@end

@implementation RatingsViewController
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

//    self.m_navigator.tintColor = [UIColor blackColor];
    /*
     old implementation
    self.m_navigator.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController:)];
     
     */
//    self.m_navigator.leftBarButtonItem.tintColor = [UIColor blueColor];
    
    
    // new implementation
    // Do any additional setup after loading the view.
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController:)];
    if ([button respondsToSelector: @selector(setTintColor:)])
    {
        button.tintColor = [UIColor blueColor];
        NSLog(@"respond");
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = button;
    self.m_navigator.leftBarButtonItem = button;
    [button release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
//    [self.navigationController popViewControllerAnimated:YES];
    [(AppDelegate *) [[UIApplication sharedApplication] delegate] DismissAll];
}

#pragma mark -
#pragma mark UIButton Related Custom Methods
- (IBAction)rateApp:(id)sender {
    //navigate to feedback view controllerer
    FeedbackViewController *feedback;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        feedback = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewcontroller-iPad" bundle:nil];
//        UINavigationController *ratingNavigationController = [[UINavigationController alloc] initWithRootViewController:feedback];
//        [self presentModalViewController:ratingNavigationController animated:YES];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        feedback = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    }
//    [self.navigationController pushViewController:feedback animated:YES];
    [self.view addSubview:feedback.view];
}
- (IBAction)sendFeedback:(id)sender {
    
    ProblemViewController *feedback;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        feedback = [[ProblemViewController alloc] initWithNibName:@"ProblemViewController-iPad" bundle:nil];
//        UINavigationController *ratingNavigationController = [[UINavigationController alloc] initWithRootViewController:feedback];
//        [self presentModalViewController:ratingNavigationController animated:YES];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        feedback = [[ProblemViewController alloc] initWithNibName:@"ProblemViewController" bundle:nil];
        //feedback.ratingController = self;
    }
    [self.view addSubview:feedback.view];
//    [self.navigationController pushViewController:feedback animated:YES];
}
- (IBAction)buyPro:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:microDJProUrl]];}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}

@end
