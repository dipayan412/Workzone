//
//  FuelPurchasePageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "FuelPurchasePageViewController.h"
#import "MainPageViewController.h"
#import "FuelPurchases.h"
#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "DriverStatusList.h"
#import "CountryStates.h"
#import "Devices.h"

@interface FuelPurchasePageViewController ()
{
}

@end

@implementation FuelPurchasePageViewController

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
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    deviceField.inputView = devicePicker;
    stateField.inputView = statePicker;
    
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateSelected];
    
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    
    textFields = [[NSArray alloc] initWithObjects:addressField,stateField,postalCodeField,deviceField,odometerField,gallonsField,TotalSpentField, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [addressField release];
    [postalCodeField release];
    [odometerField release];
    [gallonsField release];
    [TotalSpentField release];
    [devicePicker release];
    [statePicker release];
    [stateField release];
    [deviceField release];
    [saveButton release];
    [cancelButton release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    for(UIView* subView in textFields)
    {
        if([subView isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*) subView;
            if([textField.text isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:[NSString stringWithFormat:@"please fill up %@ field",[self getTextFieldName:textField.tag]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }
    }
    
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"FuelPurchases" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if(fetchedResult && [fetchedResult count] > 1)
    {
        for(FuelPurchases *fuelPurchase in fetchedResult)
        {
            fuelPurchase.deviceId = [self getDeviceIdForDeviceName:deviceField.text];
            fuelPurchase.address = addressField.text;
            fuelPurchase.postalCode = postalCodeField.text;
            fuelPurchase.odometer = [NSNumber numberWithInt:odometerField.text.intValue];
            fuelPurchase.qty = [NSNumber numberWithDouble:gallonsField.text.doubleValue];
            fuelPurchase.amount = [NSNumber numberWithDouble:TotalSpentField.text.doubleValue];
            fuelPurchase.stateId = [self getStateIdForStateName:stateField.text];
        }
    }  
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backgroundTap:(id)sender
{
    [addressField resignFirstResponder];
    [postalCodeField resignFirstResponder];
    [odometerField resignFirstResponder];
    [gallonsField resignFirstResponder];
    [TotalSpentField resignFirstResponder];
    [stateField resignFirstResponder];
    [deviceField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == statePicker)
    {
        return [self getStates].count;
    }
    else if(pickerView == devicePicker)
    {
        return [self getDevices].count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == statePicker)
    {
        return [[self getStates] objectAtIndex:row];
    }
    else if(pickerView == devicePicker)
    {
        return [[self getDevices] objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == devicePicker)
    {
        deviceField.text = [[self getDevices] objectAtIndex:row];
    }
    else if (pickerView == statePicker)
    {
        stateField.text = [[self getStates] objectAtIndex:row];
    }
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

-(NSArray*)getDevices
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray * fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Devices *device in fetchedResult)
        {
            [deviceArray addObject:device.name];
        }
    }
    return deviceArray;
}

-(NSString*)getDeviceIdForDeviceName:(NSString*)name
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name = %@",name];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray * fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        Devices *device = [fetchedResult objectAtIndex:0];
        return device.deviceId;
    }
    return nil;
}

-(NSString*)getStateIdForStateName:(NSString*)stateName
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"CountryStates" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name = %@",stateName];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray * fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        CountryStates *countryState = [fetchedResult objectAtIndex:0];
        return countryState.identifier;
    }    
    return nil;
}

-(NSString*)getTextFieldName:(NSInteger)tagNum
{
    switch (tagNum)
    {
        case 1:
            return @"Address";
        case 2:
            return @"State";
        case 3:
            return @"Postal Code";
        case 4:
            return @"Device";
        case 5:
            return @"Odometer";
        case 6:
            return @"Gallons";
        case 7:
            return @"Total Amount";
        default:
            break;
    }
    return nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == deviceField)
    {
        textField.text = [[self getDevices] objectAtIndex:0];
    }
    else if(textField == stateField)
    {
        textField.text = [[self getStates] objectAtIndex:0];
    }
}
@end
