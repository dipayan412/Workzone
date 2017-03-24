//
//  TimeLineV2ViewController.m
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "TimeLineV2ViewController.h"

@interface TimeLineV2ViewController ()
{
    
}

@end

@implementation TimeLineV2ViewController

@synthesize delegate;

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
    
    clockSetupVC = [[ClockSetupViewController alloc] initWithNibName:@"ClockSetupViewController" bundle:nil];
    clockSetupVC.delegate = self;
    clockSetupVC.view.frame = CGRectMake(0, -568, 320, 568);
    [self.view addSubview:clockSetupVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    [self showDrawerView];
}

-(IBAction)alarmClockButtonAction:(UIButton*)sender
{
    [UIView animateWithDuration:0.35f animations:^{
        clockSetupVC.view.frame = CGRectMake(0, 0, 320, 568);
    }completion:^(BOOL finished){
        if(finished)
        {
            
        }
    }];
}

#pragma mark clockSetup delegate Methods

-(void)backButtonPressedAction
{
    [UIView animateWithDuration:0.35f animations:^{
        clockSetupVC.view.frame = CGRectMake(0, -568, 320, 568);
    }];
}

#pragma mark tableView delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark tableView AsiHttpRequest Delegate

-(void)requestFinished:(ASIHTTPRequest *)request
{
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

@end
