//
//  CreditViewController.m
//  iOS Prototype
//
//  Created by World on 3/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "CreditViewController.h"

@interface CreditViewController () <ASIHTTPRequestDelegate>
{
    UIAlertView *loadingAlert;
}

@property (nonatomic, retain) ASIHTTPRequest *creditRequest;

@end

@implementation CreditViewController

@synthesize creditRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"GRABBER";
//    [loadingAlert show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:@"Could not connect to server"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)buyCredit01:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"In app bundle under construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)buyCredit02:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"In app bundle under construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)buyCredit03:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"In app bundle under construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)buyCredit04:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"In app bundle under construction"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
