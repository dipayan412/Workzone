//
//  DriverStatusViewController.m
//  ETrackPilot
//
//  Created by World on 7/23/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "DriverStatusViewController.h"
#import "DriverStatusHistoryPageViewController.h"
#import "CountryStates.h"
#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "DriverStatusList.h"


@interface DriverStatusViewController ()

@end

@implementation DriverStatusViewController

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
    
    self.title = @"Driver Status";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateSelected];
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    
    latLngLocationLabel.text = [NSString stringWithFormat:@"%0.02f, %0.02f",[UserDefaultsManager lastLat], [UserDefaultsManager lastLng]];
    
    stateField.inputView = statePicker;
    statusField.inputView = statusPicker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [DriverStatusLabel release];
    [latLngLocationLabel release];
    [viewHistoryButton release];
    [saveButton release];
    [cancelButton release];
    [addressField release];
    [stateField release];
    [zipCodeField release];
    [odometerField release];
    [statusField release];
    [statePicker release];
    [statusPicker release];
    [super dealloc];
}
- (void)viewDidUnload {
    [DriverStatusLabel release];
    DriverStatusLabel = nil;
    [latLngLocationLabel release];
    latLngLocationLabel = nil;
    [viewHistoryButton release];
    viewHistoryButton = nil;
    [saveButton release];
    saveButton = nil;
    [cancelButton release];
    cancelButton = nil;
    [addressField release];
    addressField = nil;
    [stateField release];
    stateField = nil;
    [zipCodeField release];
    zipCodeField = nil;
    [odometerField release];
    odometerField = nil;
    [statusField release];
    statusField = nil;
    [statePicker release];
    statePicker = nil;
    [statusPicker release];
    statusPicker = nil;
    [super viewDidUnload];
}
- (IBAction)viewHistoryButtonAction:(UIButton *)sender
{
    DriverStatusHistoryPageViewController *vc = [[DriverStatusHistoryPageViewController alloc] initWithNibName:@"DriverStatusHistoryPageViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backgroundTap:(id)sender
{
    [addressField resignFirstResponder];
    [stateField resignFirstResponder];
    [zipCodeField resignFirstResponder];
    [odometerField resignFirstResponder];
    [statusField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == stateField)
    {
        textField.text = [[self getStates] objectAtIndex:0];
    }
    else if(textField == statusField)
    {
        textField.text = [[self getDriverStatus] objectAtIndex:0];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == statusPicker)
    {
        return [self getDriverStatus].count;
    }
    else if(pickerView == statePicker)
    {
        return [self getStates].count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == statusPicker)
    {
        return [[self getDriverStatus] objectAtIndex:row];
    }
    else if (pickerView == statusPicker)
    {
        return [[self getStates] objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == statusPicker)
    {
        statusField.text = [[self getDriverStatus] objectAtIndex:row];
    }
    else if(pickerView == statePicker)
    {
        stateField.text = [[self getStates] objectAtIndex:row];
    }
}

-(NSArray*)getDriverStatus
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"DriverStatusList" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *driverStatusListArray = [[NSMutableArray alloc] init];
    
    if(fetchedResult && [fetchedResult count] > 0)
    {
        for (DriverStatusList *driverStatusList in fetchedResult)
        {
            [driverStatusListArray addObject:driverStatusList.name];
        }
    }
    return driverStatusListArray;
}

-(NSArray*)getStates
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"CountryStates" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *statusArray = [[NSMutableArray alloc] init];
    
    if(fetchedResult && [fetchedResult count] > 0)
    {
        for (CountryStates *countryStates in fetchedResult)
        {
            [statusArray addObject:countryStates.name];
        }
    }
    return statusArray;
}
@end
