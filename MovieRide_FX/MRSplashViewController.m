//
//  MRSplashViewController.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/07.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRSplashViewController.h"
#import "MRAppDelegate.h"

@interface MRSplashViewController ()
//@property (nonatomic, retain) NSTimer *timer;
@end

@implementation MRSplashViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    
    MRAppDelegate *adel = (MRAppDelegate*) [[UIApplication sharedApplication] delegate];
    [adel unzipBundledTemplates];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showHomeScreen) userInfo:nil repeats:NO];
}

-(void)showHomeScreen {
    NSLog(@"Show Home screen");
    [self performSegueWithIdentifier:@"Home" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
