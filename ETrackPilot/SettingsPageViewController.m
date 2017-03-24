//
//  SettingsPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "SettingsPageViewController.h"
#import "MainPageViewController.h"
#import "Synchronizer.h"
#import "AppDelegate.h"

@interface SettingsPageViewController ()
{
    NSArray *tableNames;
}

@end

@implementation SettingsPageViewController

@synthesize syncListener;
@synthesize dbiListener;
@synthesize dwiListener;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    tableNames = [[NSArray alloc] initWithObjects:@"FuelPurchases",@"Jobs",@"Customers",@"JobsRemoved",@"CountryStates",@"InspectionList",@"CheckInOut",@"Inspections",@"InspectionListItems",@"DriverLog",@"JobStatusList",@"Devices",@"JobStatusLog",@"DriverStatusList",@"JobNotesLog",nil];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [syncFrequencyLabel release];
    [purgeDelayLabel release];
    [saveSettingsButton release];
    [syncNowButton release];
    [resetAllButton release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveSettingsButtonAction:(UIButton *)sender
{
    [UserDefaultsManager setPurgeFreqDays:[purgeDelayLabel.text intValue]];
    [UserDefaultsManager setSyncFreqSecs:[syncFrequencyLabel.text intValue]];
    
    MainPageViewController *vc = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)SyncNowButtonAction:(UIButton *)sender
{
    [[Synchronizer getInstance] forgroundSyncForListener:self.syncListener];
}

- (IBAction)resetAllButtonAction:(UIButton *)sender
{
    [UserDefaultsManager setPurgeFreqDays:10];
    [UserDefaultsManager setSyncFreqSecs:10];
    [self deleteDatabase];
    [[Synchronizer getInstance] forgroundDBIForListener:self.dbiListener];
    [[Synchronizer getInstance] forgroundDWIForListener:self.dwiListener];
}

- (IBAction)backGroundTap:(id)sender
{
    [syncFrequencyLabel resignFirstResponder];
    [purgeDelayLabel resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)deleteDatabase
{
    for (int i = 0; i < tableNames.count; i++)
    {
        NSError *error = nil;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:[tableNames objectAtIndex:i] inManagedObjectContext:context];
                
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:chartEntity];
        
        NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        [fetchRequest release];
        
        if (fetchedArray && [fetchedArray count] > 0)
        {
            for (int i = 0;i < fetchedArray.count; i++)
            {
                [context deleteObject:[fetchedArray objectAtIndex:i]];
            }
        }
    }
}

#pragma syncListener

-(void)syncCompleted
{
    NSLog(@"in settings");
}

-(void)syncFailedWithError:(NSString*)error
{
    
}

#pragma dbiListener

-(void)dbiCompleted
{
    
}

-(void)dbiFailedWithError:(NSString*)error
{
    
}

#pragma dwiListener

-(void)dwiCompleted
{
    
}

-(void)dwiFailedWithError:(NSString*)error
{
    
}

@end
