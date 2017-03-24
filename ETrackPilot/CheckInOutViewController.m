//
//  CheckInOutViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "CheckInOutViewController.h"
#import "Devices.h"
#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "CheckInOut.h"

@interface CheckInOutViewController ()
{
    NSTimer *timer;
}

@property (nonatomic, retain) CLLocation *location;

@end

@implementation CheckInOutViewController

@synthesize location;

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
    
    checkOutButton.backgroundColor = [UIColor redColor];
    [checkOutButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [checkOutButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];

    checkInButton.backgroundColor = [UIColor greenColor];
    [checkInButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    [checkInButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateSelected];
    
    userLocationManager = [[CLLocationManager alloc] init];
    userLocationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([UserDefaultsManager isCheckedIn])
    {
        checkInOutLabel.backgroundColor = [UIColor greenColor];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkedInCounter) userInfo:nil repeats:YES];
    }
    else
    {
        checkInOutLabel.backgroundColor = [UIColor redColor];
        checkInOutLabel.text = @"You are checked Out";
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [checkInOutLabel release];
    [dayTimeLabel release];
    [odometerField release];
    [devicePicker release];
    [deviceField release];
    [checkInButton release];
    [checkOutButton release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)checkInButtonAction:(UIButton *)sender
{
    [userLocationManager startUpdatingLocation];
    
    if(![deviceField.text isEqualToString:@""] && ![odometerField.text isEqualToString:@""])
    {
        [UserDefaultsManager setCheckedIn:YES];
        [UserDefaultsManager setCheckedInSince:[NSDate date]];
        [UserDefaultsManager setDeviceId:[self getDeviceIdForDeviceName:deviceField.text]];
    }
    else
    {
        if([deviceField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Please fill up Device field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        else if([odometerField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Please fill up Odometer field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    [timer invalidate];
    timer = nil;
    
    if([UserDefaultsManager isCheckedIn])
    {
        checkInOutLabel.backgroundColor = [UIColor greenColor];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkedInCounter) userInfo:nil repeats:YES];
    }
    else
    {
        checkInOutLabel.backgroundColor = [UIColor redColor];
        checkInOutLabel.text = @"You are checked Out";
    }
    [self updateCheckInOutIsCheckedIn:[UserDefaultsManager isCheckedIn]];
}

- (IBAction)checkOutButtonAction:(UIButton *)sender
{
    if(![deviceField.text isEqualToString:@""] && ![odometerField.text isEqualToString:@""])
    {
        [UserDefaultsManager setCheckedIn:NO];
        [UserDefaultsManager setDeviceId:[self getDeviceIdForDeviceName:deviceField.text]];
    }
    else
    {
        if([deviceField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Please fill up Device field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        else if([odometerField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field" message:@"Please fill up Odometer field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    if(![UserDefaultsManager isCheckedIn])
    {
        checkInOutLabel.backgroundColor = [UIColor redColor];
        checkInOutLabel.text = @"You are checked Out";
        [timer invalidate];
        timer = nil;
    }
    [self updateCheckInOutIsCheckedIn:[UserDefaultsManager isCheckedIn]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == deviceField)
    {
        deviceField.text = [[self getDevices] objectAtIndex:0];
    }
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
    if(pickerView == devicePicker)
    {
        return [self getDevices].count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == devicePicker)
    {
        return [[self getDevices] objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == devicePicker)
    {
        deviceField.text = [[self getDevices] objectAtIndex:row];
    }
}

-(IBAction)backgroundTap:(id)sender
{
    [deviceField resignFirstResponder];
    [odometerField resignFirstResponder];
}

-(NSArray*)getDevices
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    NSMutableArray *devicesArray = [[NSMutableArray alloc] init];
    
    if (fetchedResult && [fetchedResult count] > 0)
    {
        for (Devices *devices in fetchedResult)
        {
            [devicesArray addObject:devices.name];
        }
    }
    return devicesArray;
}

-(void)checkedInCounter
{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:[UserDefaultsManager checkedInSince]];
    int hour = elapsedTime/3600;
    int min = (elapsedTime - hour*3600)/60;
    checkInOutLabel.text = [NSString stringWithFormat:@"You are Checked In ( %02d : %02d )",hour, min];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    dayTimeLabel.text = dateString;
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

-(void)updateCheckInOutIsCheckedIn:(BOOL)isCheckedIn
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"CheckInOut" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(fetchedResult && [fetchedResult count] > 0)
    {
        for(CheckInOut *checkInOut in fetchedResult)
        {
            checkInOut.isCheckedIn = [NSNumber numberWithBool:isCheckedIn];
            checkInOut.eventDate = [NSDate date];
            checkInOut.lat = [NSNumber numberWithDouble:self.location.coordinate.latitude];
            checkInOut.lng = [NSNumber numberWithDouble:self.location.coordinate.longitude];
            checkInOut.deviceId = [self getDeviceIdForDeviceName:deviceField.text];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (location == nil)
    {
        self.location = [locations objectAtIndex:0];
        [userLocationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (location == nil)
    {
        NSLog(@"Location manager failed");
        self.location = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];        
    }
}

@end
