//
//  DataUploader.m
//  SocialHeroes
//
//  Created by Nazmul Quader on 7/22/13.
//  Copyright (c) 2013 Nazmul Quader. All rights reserved.
//

#import "LocationReader.h"
#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "NSDate+Extension.h"
#import "GLLVisit.h"

#define TICKER_IN_SECONDS 60.0f
#define BACKGROUND_KEEPALIVE_TIME 60.0f

@interface LocationReader()

@property (nonatomic, retain) NSTimer *countdownTimer;

@property (nonatomic, retain) NSDate *lastUpdatedOn;

@end

@implementation LocationReader

@synthesize countdownTimer;
@synthesize lastUpdatedOn;

static LocationReader *instance = nil;

+(LocationReader*)getInstance
{
    if (instance == nil)
    {
        instance = [[LocationReader alloc] init];
    }
    
    return instance;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        userLocationManager = [[CLLocationManager alloc] init];
        userLocationManager.delegate = self;
    }
    
    return self;
}

-(void)startUploading
{
    if (self.countdownTimer == nil)
    {
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:TICKER_IN_SECONDS target:self selector:@selector(countdownTimerTick) userInfo:nil repeats:YES];
    }
}

-(void)stopUploading
{
    if (countdownTimer.isValid)
    {
        [countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

-(void)countdownTimerTick
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.isBackground)
    {
        int currentTime = [[NSDate date] timeIntervalSinceMidnight];
        int requireTime = [UserDefaultsManager notificationTime];
        
        if ((currentTime - requireTime) <= 60)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                if ([UserDefaultsManager dailyNotification])
                {
                    [self captureAndUploadLocationData];
                }
            });
        }
        else
        {
            [self keepAliveLocationService];
        }
    }
    else
    {
        int currentTime = [[NSDate date] timeIntervalSinceMidnight];
        int requireTime = [UserDefaultsManager notificationTime];
        
        if ((currentTime - requireTime) <= 60)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          
                if ([UserDefaultsManager dailyNotification])
                {
                    [self captureAndUploadLocationData];
                }
            });
        }
    }
}

-(void)captureAndUploadLocationData
{
    NSLog(@"Capture and Update");
    
    waitForUpdate = YES;
    [userLocationManager startUpdatingLocation];
}

-(void)keepAliveLocationService
{
    NSLog(@"Background Mode: Keep alive");
    
    waitForUpdate = NO;
    [userLocationManager startUpdatingLocation];
    [userLocationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (waitForUpdate == NO) return;
    
    waitForUpdate = NO;
    
    CLLocation *location = [locations lastObject];
    [userLocationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks lastObject];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"dd/MM/yyyy";
            NSString *dateStr = [df stringFromDate:[NSDate date]];

            NSError *error = nil;
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:chartEntity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date = %@",[df dateFromString:dateStr]];
            [fetchRequest setPredicate:predicate];
            
            NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
            
            GLLVisit *visit = nil;
            
            if(fetchedResult.count > 0)
            {
                visit = [fetchedResult objectAtIndex:0];
                visit.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
                visit.longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
                visit.city = placemark.locality;
                visit.country = placemark.country;
                visit.date = [df dateFromString:dateStr];
                visit.hasPhoto = [NSNumber numberWithBool:NO];
                
                visit.remoteId = [NSNumber numberWithInt:0];
                visit.rowStatus = [NSNumber numberWithInt:0];
            }
            else
            {
                visit = [NSEntityDescription insertNewObjectForEntityForName:@"GLLVisit" inManagedObjectContext:context];
                visit.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
                visit.longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
                visit.city = placemark.locality;
                visit.country = placemark.country;
                visit.date = [df dateFromString:dateStr];
                visit.hasPhoto = [NSNumber numberWithBool:NO];
                
                visit.remoteId = [NSNumber numberWithInt:0];
                visit.rowStatus = [NSNumber numberWithInt:0];
            }
            
            [context save:&error];
            
            if (error)
            {
                if([UserDefaultsManager dailyNotification])
                {
                    [self showFailedNotification];
                }
            }
            else
            {
                if([UserDefaultsManager dailyNotification])
                {
                    [self showSuccessNotificationWithCity:placemark.locality country:placemark.country];
                }
            }
        }
        else
        {
            if([UserDefaultsManager dailyNotification])
            {
                [self showFailedNotification];
            }
        }
    } ];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showFailedNotification];
}

-(void)showSuccessNotificationWithCity:(NSString*)city country:(NSString*)country
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isBackground)
    {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        
        localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:30.0f];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = [NSString stringWithFormat:@"Today I registered you in %@, %@.", city, country];
        localNotif.alertAction = @"OK";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 0;

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Today I registered you in %@, %@.", city, country]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)showFailedNotification
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isBackground)
    {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        
        localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:30.0f];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = @"Failed to get your location. Please do a manual check-in now.";
        localNotif.alertAction = @"OK";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Failed to get your location. Please do a manual check-in now."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.needManualCheckin = YES;
        
        [appDelegate showCheckinPage];
    }
}

@end
