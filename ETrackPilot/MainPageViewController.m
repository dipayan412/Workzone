//
//  MainPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "MainPageViewController.h"
#import "JobPageViewController.h"
#import "LocateGroupPageViewController.h"
#import "CheckInOutViewController.h"
#import "FuelPurchasePageViewController.h"
#import "SettingsPageViewController.h"
#import "InspectionsPageViewController.h"
#import "UserDefaultsManager.h"
#import "DriverStatusViewController.h"

@interface MainPageViewController ()
{
    NSTimer *timer;
}

@end

@implementation MainPageViewController

@synthesize isCheckedIn;
@synthesize username;

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
    
    self.title = @"ePilot";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.navigationItem.hidesBackButton = YES;
    
    usernameLabel.text = [NSString stringWithFormat:@"Welcome %@",[UserDefaultsManager fullName]];
    
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserDefaultsManager isCheckedIn])
    {
        checkedInOutLabel.backgroundColor = [UIColor greenColor];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkedInCounter) userInfo:nil repeats:YES];
    }
    else
    {
        checkedInOutLabel.backgroundColor = [UIColor redColor];
        checkedInOutLabel.text = @"You are checked out";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [usernameLabel release];
    [checkedInOutLabel release];
    [checkedInOutButton release];
    [jobsButton release];
    [fuelPurchaseButton release];
    [locateGroupButton release];
    [settingsButton release];
    [vehicleInspectionButton release];
    [driverStatusButton release];
    [super dealloc];
}

-(void)logout:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [UserDefaultsManager setRememberMe:NO];
}

- (IBAction)checkedInOutButtonAction:(UIButton *)sender
{
    CheckInOutViewController *vc = [[CheckInOutViewController alloc] initWithNibName:@"CheckInOutViewController" bundle:nil];
    vc.title = @"Check In/Out";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)jobsButtonAction:(UIButton *)sender
{
    JobPageViewController *vc = [[JobPageViewController alloc] initWithNibName:@"JobPageViewController" bundle:nil];
    vc.title = @"Jobs List";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)fuelPurchaseButtonAction:(UIButton *)sender
{
    FuelPurchasePageViewController *vc = [[FuelPurchasePageViewController alloc] initWithNibName:@"FuelPurchasePageViewController" bundle:nil];
    vc.title = @"Fuel Purchase";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)vehicleInspectionButtonAction:(UIButton *)sender
{
    InspectionsPageViewController *vc = [[InspectionsPageViewController alloc] initWithNibName:@"InspectionsPageViewController" bundle:nil];
    vc.title = @"Inspection List";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)settingsButtonAction:(UIButton *)sender
{
    SettingsPageViewController *vc = [[SettingsPageViewController alloc] initWithNibName:@"SettingsPageViewController" bundle:nil];
    vc.title = @"Settings";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)locateGroupButtonAction:(UIButton *)sender
{
    LocateGroupPageViewController *vc = [[LocateGroupPageViewController alloc] initWithNibName:@"LocateGroupPageViewController" bundle:nil];
    vc.title = @"Group Location";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)driverStatusButtonAction:(UIButton *)sender
{
    DriverStatusViewController *vc = [[DriverStatusViewController alloc] initWithNibName:@"DriverStatusViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)checkedInCounter
{
    NSDate *now = [NSDate date];
    NSDate *inSince = [UserDefaultsManager checkedInSince];
    NSTimeInterval diff = [now timeIntervalSinceDate:inSince];
    int hour = diff/3600;
    int min = (diff - hour*3600) / 60;
    checkedInOutLabel.text = [NSString stringWithFormat:@"You are checked in ( %02d : %02d )",hour, min];
}


@end
