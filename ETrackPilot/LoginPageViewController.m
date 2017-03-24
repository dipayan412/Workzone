//
//  LoginPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "LoginPageViewController.h"
#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "Devices.h"
#import "InspectionList.h"
#import "CountryStates.h"
#import "InspectionListItemProcedure.h"
#import "DriverStatusList.h"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface LoginPageViewController ()

@property (nonatomic, retain) ASIHTTPRequest *loginRequest;
@property (nonatomic, retain) ASIHTTPRequest *getDevicesRequest;
@property (nonatomic, retain) ASIHTTPRequest *getInspectionRequest;
@property (nonatomic, retain) ASIHTTPRequest *getCountryStatesRequest;
@property (nonatomic, retain) ASIHTTPRequest *getDriverStatusListRequest;
@property (nonatomic, retain) CLLocation *location;

@end

@implementation LoginPageViewController

@synthesize loginRequest;
@synthesize getDevicesRequest;
@synthesize getInspectionRequest;
@synthesize getCountryStatesRequest;
@synthesize getDriverStatusListRequest;
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
    
    self.title = @"ePilot Login";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg~iPad.png"]];
    }
    else if (IS_IPHONE5)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg_568h.png"]];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    }
    
    loadingView = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    userLocationManager = [[CLLocationManager alloc] init];
    userLocationManager.delegate = self;
    
    usernameField.text = @"demo";
    passwordField.text = @"demo1234";
    
    if([UserDefaultsManager rememberMe])
    {
        MainPageViewController *vc = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [usernameField release];
    [passwordField release];
    [rememberMeSwittch release];
    [signInButton release];
    [loadingView release];
    
    [super dealloc];
}

- (IBAction)rememberMeSwitchAction:(UISwitch *)sender
{
    [UserDefaultsManager setRememberMe:sender.isOn];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)signInButtonAction:(UIButton *)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [loadingView show];
    self.location = nil;
    
    [userLocationManager startUpdatingLocation];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    
    NSLog(@"Response: %@", request.responseString);
    
    if (request == loginRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to parse response" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
        
        NSString *checkedInSinceStr = [responseObject objectForKey:@"checkedInSince"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
        NSDate *checkedInSince = [df dateFromString:checkedInSinceStr];
        
        NSString *deviceId = [responseObject objectForKey:@"deviceId"];
        NSString *fullName = [responseObject objectForKey:@"fullName"];
        BOOL isCheckedIn = [[responseObject objectForKey:@"isCheckedIn"] boolValue];
        
        NSString *token = [responseObject objectForKey:@"token"];
        
        NSString *driverStatusSinceStr = [responseObject objectForKey:@"driverStatusSince"];
        NSDate *driverStatusSince = [df dateFromString:driverStatusSinceStr];
        
        NSString *driverStatusId = [responseObject objectForKey:@"driverStatusId"];
        
        [df release];
        
        [UserDefaultsManager setUsername:usernameField.text];
        [UserDefaultsManager setPassword:passwordField.text];
        [UserDefaultsManager setExpDays:(rememberMeSwittch.isOn ? 999 : 5)];
        [UserDefaultsManager setToken:token];
        [UserDefaultsManager setTokenValidUntil:[[NSDate date] dateByAddingTimeInterval:(rememberMeSwittch.isOn ? 999 : 5) * 24 * 3600.0f]];
        [UserDefaultsManager setFullName:fullName];
        [UserDefaultsManager setCheckedIn:isCheckedIn];
        [UserDefaultsManager setCheckedInSince:checkedInSince];
        [UserDefaultsManager setDeviceId:deviceId];
        [UserDefaultsManager setDriverStatusSince:driverStatusSince];
        [UserDefaultsManager setDriverStatusId:driverStatusId];
        [UserDefaultsManager setLastLat:location.coordinate.latitude];
        [UserDefaultsManager setLastLng:location.coordinate.longitude];
        [UserDefaultsManager setLastUpdatedOn:[NSDate date]];
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getDevices"];
        [urlStr appendFormat:@"?token=%@", [UserDefaultsManager token]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        self.getDevicesRequest = [ASIHTTPRequest requestWithURL:url];
        getDevicesRequest.delegate = self;
        
        [getDevicesRequest startAsynchronous];
    }
    else if (request == getDevicesRequest)
    {
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithFormat:@"{\"devices\":%@}", request.responseString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to parse response" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:chartEntity];
        
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        [request release];
        
        if(mutableFetchResults && [mutableFetchResults count] > 1)
        {
            for (Devices *device in mutableFetchResults)
            {
                [context deleteObject:device];
            }
        }
        
        NSArray *devicesArray = [responseObject objectForKey:@"devices"];
        for (int i = 0; i < devicesArray.count; i++)
        {
            NSDictionary *deviceObj = [devicesArray objectAtIndex:i];
            Devices *device = [NSEntityDescription insertNewObjectForEntityForName:@"Devices" inManagedObjectContext:context];
            
            device.deviceId = [deviceObj objectForKey:@"id"];
            device.name = [deviceObj objectForKey:@"name"];
        }
        
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getInspectionLists"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        self.getInspectionRequest = [ASIHTTPRequest requestWithURL:url];
        getInspectionRequest.delegate = self;
        
        [getInspectionRequest startAsynchronous];
    }
    else if (request == getInspectionRequest)
    {
        NSMutableArray *idForInspectionItem = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithFormat:@"{\"inspections\":%@}",request.responseString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to parse response" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return;
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionList" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:chartEntity];
        
        NSMutableArray *fetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        [request release];
        
        if (fetchResults && [fetchResults count] > 1)
        {
            for (InspectionList *inspectionList in fetchResults)
            {
                [context deleteObject:inspectionList];
            }
        }
        
        NSArray *inspectionListArray = [responseObject objectForKey:@"inspections"];
        for (int i = 0; i < inspectionListArray.count; i++)
        {
            NSDictionary *inspectionListObj = [inspectionListArray objectAtIndex:i];
            InspectionList *inspectionList = [NSEntityDescription insertNewObjectForEntityForName:@"InspectionList" inManagedObjectContext:context];
            
            inspectionList.listId = [inspectionListObj objectForKey:@"id"];
            inspectionList.name = [inspectionListObj objectForKey:@"name"];
            
            [idForInspectionItem addObject:[inspectionListObj objectForKey:@"id"]];
        }
        
        InspectionListItemProcedure *inspectionListItemProcedure = [[InspectionListItemProcedure alloc] init];
        [inspectionListItemProcedure inspectionListItemForListItemIdentifier:idForInspectionItem];
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getCountryStates"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        self.getCountryStatesRequest = [ASIHTTPRequest requestWithURL:url];
        getCountryStatesRequest.delegate = self;
        [getCountryStatesRequest startAsynchronous];
    }
    else if(request == getCountryStatesRequest)
    {
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithFormat:@"{\"countryStates\":%@}",request.responseString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if(error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to purge data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"CountryStates" inManagedObjectContext:context];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];        
        [fetchRequest setEntity:chartEntity];
        
        NSMutableArray *fetchResults = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        [fetchRequest release];
        
        
        if(fetchResults && [fetchResults count] > 1)
        {
            for (CountryStates *countryState in fetchResults)
            {
                NSLog(@"%@",[NSString stringWithFormat:@"%@",countryState.name]);
                [context deleteObject:countryState];
            }
        }
        
        NSArray *countryStateArray = [responseObject objectForKey:@"countryStates"];
        for (int i = 0; i < countryStateArray.count; i++)
        {
            NSDictionary *countryStateObject = [countryStateArray objectAtIndex:i];
            CountryStates *countryState = [NSEntityDescription insertNewObjectForEntityForName:@"CountryStates" inManagedObjectContext:context];
            
            countryState.identifier = [countryStateObject objectForKey:@"id"];
            countryState.name = [countryStateObject objectForKey:@"name"];
        }
        
        if (![context save:&error])
        {
            return;
        }

        
        NSMutableString *urlstr = [[NSMutableString alloc] init];
        [urlstr appendFormat:@"http://etrack.ws/pilot.svc/getDriverStatusList"];
        [urlstr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        
        NSURL *url = [NSURL URLWithString:urlstr];
        self.getDriverStatusListRequest = [ASIHTTPRequest requestWithURL:url];
        getDriverStatusListRequest.delegate = self;
        
        [getDriverStatusListRequest startAsynchronous];
    }
    else if(request == getDriverStatusListRequest)
    {
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithFormat:@"{\"driverStatusList\":%@}",request.responseString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if(error)
        {
            return;
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"DriverStatusList" inManagedObjectContext:context];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:chartEntity];
        
        NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        [fetchRequest release];
        
        if (fetchedResult && [fetchedResult count] > 0)
        {
            for (DriverStatusList *driverStatusList in fetchedResult)
            {
                [context deleteObject:driverStatusList];
            }
        }
        
        NSArray *driverStatusListArray = [responseObject objectForKey:@"driverStatusList"];
        for (int i = 0; i < driverStatusListArray.count; i++)
        {
            NSDictionary *driverStatusListObj = [driverStatusListArray objectAtIndex:i];
            DriverStatusList *driverStatusList = [NSEntityDescription insertNewObjectForEntityForName:@"DriverStatusList" inManagedObjectContext:context];
            
            driverStatusList.name = [driverStatusListObj objectForKey:@"name"];
            driverStatusList.statusId = [driverStatusListObj objectForKey:@"statusId"];
        }
        
        if(![context save:&error])
        {
            return;
        }
        
        [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
        
#pragma going_to_main_view
        MainPageViewController *vc = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)backgroundTap:(id)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (location == nil)
    {
        self.location = [locations objectAtIndex:0];
        [userLocationManager stopUpdatingLocation];
        
        [self requestSingIn];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (location == nil)
    {
        NSLog(@"Location manager failed");
        self.location = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
        
        [self requestSingIn];
    }
}

-(void)requestSingIn
{
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/authorization"];
    [urlStr appendFormat:@"?login=%@", usernameField.text];
    [urlStr appendFormat:@"&password=%@", passwordField.text];
    [urlStr appendFormat:@"&expDays=%d", (rememberMeSwittch.isOn ? 999 : 5)];
    [urlStr appendFormat:@"&lat=%f", location.coordinate.latitude];
    [urlStr appendFormat:@"&lng=%f", location.coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    self.loginRequest = [ASIHTTPRequest requestWithURL:url];
    loginRequest.delegate = self;
    
    [loginRequest startAsynchronous];
}

-(void)dbiCompleted
{
    
}

-(void)dbiFailedWithError:(NSString*)error
{
    
}

@end
