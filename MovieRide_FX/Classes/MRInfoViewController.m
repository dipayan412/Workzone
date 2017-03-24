//
//  MRInfoViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRInfoViewController.h"
#import "MRAppDelegate.h"
#import "MRUtil.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MRGalleryViewController.h"


@interface MRInfoViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation MRInfoViewController

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
        
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    //[tracker set:kGAIScreenName value:MRCheckPointInfo];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if ([segue.identifier isEqualToString:@"InfoToGallery"]) {
        
        MRGalleryViewController *galleryController = (MRGalleryViewController *)segue.destinationViewController;
        galleryController.fromController = @"MRInfoViewController";
    }
}

-(IBAction)mailButtonPressed:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Support"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"support@movieridefx.com", nil];
    
    [picker setToRecipients:toRecipients];
    
    NSString *emailBody = @"";
    
    [picker setMessageBody:emailBody isHTML:YES];
    
//    picker.navigationBar.tintColor = [UIColor blackColor];
    
    if ([MFMailComposeViewController canSendMail])
    {
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:@"Error" message:@"mail not configured" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [view show];
    }
}

#pragma mark - messageui delegate methods

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
            
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            
            break;
            
        case MFMailComposeResultSent:
            
            break;
            
        case MFMailComposeResultFailed:
            
            break;
            
        default:
            
            break;
            
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)webSiteButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.movieridefx.com"]];
}

-(IBAction)facebookButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/MOVIERIDEFX"]];
}

-(IBAction)twitterButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/MovieRideFX"]];
}

-(IBAction)youtubeButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/user/movieridefx"]];
}

-(IBAction)unwindToInfoFromGallery:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Info");
}

@end
