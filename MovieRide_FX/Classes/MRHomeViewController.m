//
//  MRHomeViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/13.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRHomeViewController.h"
#import "MRGalleryViewController.h"
#import "MRAppDelegate.h"
#import "MRUtil.h"
#import "MRSettings.h"
#import "MRAlertView.h"

@interface MRHomeViewController () <MRAlertViewDelegate>

@end

@implementation MRHomeViewController

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
    
    //[tracker set:kGAIScreenName value:MRCheckPointHome];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if(![MRUtil isUserAgreementDone])
    {
        NSString *versionString = [NSString stringWithFormat:@"MovieRide FX version %@", [MRUtil appVersion]];
        NSString *alertText = @"MovieRide FX User Agreement\n1. This MovieRide FX video and application (\"MovieRide FX\") is brought to you by Waterston Entertainment Limited (\"the Producer\"). MovieRide FX is offered to the User for private entertainment purposes only.\n2. MovieRide FX is copyright by Waterston Entertainment Projects (Pty) Ltd (\"the Copyright Holder\"). MovieRide FX is protected under the South African Copyright Act of 1978 (and its successor), the Berne Convention (and its successor) and all other applicable international copyright laws, with ALL rights reserved. No part of MovieRide FX may be copied or changed in any format, sold or used in any way whatsoever other than what is outlined and contained within the content, function and use of MovieRide FX.\n3. All content from MovieRide FX through visual, audio or written means are the sole opinions of the Producer and its officers, employees, contractors, agents and representatives involved in the making of this video and application.\n4. As in all cases, Users should never take any content from this or any other video and application at face value and should always apply their own mind and/or do their own due diligence on any viewed material to form their own opinions and judgments. And where applicable competent professional advice should always be sought before taking action of any kind.\n5. The Producer does not warrant the performance, effectiveness or applicability of any sites listed or linked to MovieRide FX.\n6. All MovieRide FX links are for information purposes only and are not warranted for content, accuracy or any other implied or explicit purpose.\n7. Whilst the Producer has used its best efforts in the production of MovieRide FX, the Producer and its officers, employees, contractors, agents and representatives give no warranties or representations with respect to the accuracy, applicability, fitness, appropriateness or completeness of MovieRide FX. The content of MovieRide FX is strictly for private entertainment purposes only. If the User wishes to use or apply information, concepts or ideas contained in MovieRide FX, it is being done at their own risk.\n8. The Producer, Copyright Holder and assigned users accept no liability whatsoever for any content changes made to MovieRide FX and the distribution thereof by the User or any other person. The User is cautioned against making any such changes and distributing them, which may result in copyright infringements against third parties, contain inappropriate material or result in any other legal infringements.\n9. Neither the Producer or their officers, employees, contractors, agents and representatives, nor the Copyright Holder or assigned users of MovieRide FX shall be held liable by the User or any other party for any damages whatsoever and how so ever arising, whether direct, indirect, punitive, special or other consequential damages arising directly or indirectly from any use of MovieRide FX, which video material and application is provided as is and without any warranties or representations.\n10. Any disputes arising out of or in connection with this contract, including any questions regarding its existence, validity or termination, shall be referred to and finally resolved by arbitration under the London International Court of Arbitration (\"LCIA\") rules (\"the Rules\"), which Rules are deemed to be incorporated by reference into this clause.\n11. In the event of arbitral proceedings: a) the seat of the arbitration shall be London, b) the number of arbitrators shall be one, c) the English language shall be used and d) the governing law shall be the laws of England.";
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            MRAlertView *alertView = [[MRAlertView alloc] init];
            
            // Add some custom content to the alert view

            [alertView setContainerView:[self createDemoViewForiPadWithAlertText:alertText alertLableText:versionString]];
            
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
            [alertView setDelegate:self];
            [alertView setUseMotionEffects:true];
            [alertView show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:versionString message:alertText
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
    NSString *versionString = [NSString stringWithFormat:@"Version: %@", [MRUtil build]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = versionString;
    versionLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MRAppDelegate *adel = (MRAppDelegate*)[[UIApplication sharedApplication] delegate];
    [adel playButtonSound];
    
    if ([segue.identifier isEqualToString:@"HomeToGallery"])
    {
        MRGalleryViewController *galleryController= (MRGalleryViewController *)segue.destinationViewController;
        galleryController.fromController = @"MRHomeViewController";
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [MRUtil setUserAgreedForCurrentVersion:YES];
}

-(IBAction)unwindToHomeFromGallery:(UIStoryboardSegue *)segue
{
    NSLog(@"Unwinded to Home");
}

-(void)alertDialogButtonTouchUpInside:(MRAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MRUtil setUserAgreedForCurrentVersion:YES];
    [alertView closeAlert];
}

-(UIView*)createDemoViewForiPadWithAlertText:(NSString*)_alertText alertLableText:(NSString*)_alertLabelText
{
    UIView *alertDemoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 400)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 580, 30)];
    UITextView *alertTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 580, 340)];
    
    alertTextView.textAlignment = NSTextAlignmentCenter;
    alertTextView.text = _alertText;
    alertTextView.font = [UIFont systemFontOfSize:17];
    alertTextView.editable = NO;
    alertTextView.backgroundColor = [UIColor clearColor];
    [alertDemoView addSubview:alertTextView];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _alertLabelText;
    
    [alertDemoView addSubview:titleLabel];
    
    return alertDemoView;
}


@end
