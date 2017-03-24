//
//  Synchronizer.m
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "Synchronizer.h"
#import "SyncListener.h"
#import "DBIListener.h"
#import "DWIListener.h"
#import "UWIListener.h"
#import "UserDefaultsManager.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "Devices.h"
#import "CountryStates.h"
#import "InspectionList.h"
#import "InspectionListItems.h"
#import "DriverStatusList.h"
#import "CheckInOut.h"
#import "Inspections.h"
#import "FuelPurchases.h"

static Synchronizer *synchronizer = nil;

@interface Synchronizer()

@property (nonatomic, assign) id<SyncListener> syncListener;
@property (nonatomic, assign) id<DBIListener> dbiListener;
@property (nonatomic, assign) id<DWIListener> dwiListener;
@property (nonatomic, assign) id<UWIListener> uwiListener;

@end

@implementation Synchronizer

@synthesize syncListener;
@synthesize dbiListener;
@synthesize dwiListener;
@synthesize uwiListener;

@synthesize pause;

+(id)getInstance
{
    if (synchronizer == nil)
    {
        synchronizer = [[Synchronizer alloc] init];
    }
    return  synchronizer;
}

-(void)startSynchronizer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backgroundSync) userInfo:nil repeats:YES];
}

-(void)backgroundSync
{
    if (!pause && !running)
    {
        running = YES;
        [self backgroundDBI];
        [self backgroundDWI];
        [self backgroundUWI];
        running = NO;
    }
}

-(void)backgroundDBI
{
    if (!pause) [self getDeviceList];
    if (!pause) [self getCountryState];
    if (!pause) [self getInspectionList];
    if (!pause) [self getInspectionListItem];
    if (!pause) [self getDriverStatusList];
}

-(void)backgroundDWI
{
//    if (!pause) [self getDeviceList];
//    if (!pause) [self getDeviceList];
}

-(void)backgroundUWI
{
    if(!pause) [self updateCheckInOutStatus];
    if(!pause) [self saveInspection];
    if(!pause) [self updateFuelPurchase];
}

-(void)forgroundSyncForListener:(id)listener
{
    pause = YES;
    self.syncListener = listener;
    [self forgroundDBIForListener:listener];
    [self forgroundDWIForListener:listener];
    [self forgroundUWIForListener:listener];
}

-(void)forgroundDBIForListener:(id)listener
{
    pause = YES;
    self.dbiListener = listener;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (![self getDeviceList])
        {
            [dbiListener dbiFailedWithError:@""];
            return;
        }
        
        if (![self getInspectionList])
        {
            [dbiListener dbiFailedWithError:@""];
            return;
        }
        if (![self getInspectionListItem])
        {
            [dbiListener dbiFailedWithError:@""];
            return;
        }
        
        if (![self getCountryState])
        {
            [dbiListener dbiFailedWithError:@""];
            return;
        }
        
        if (![self getDriverStatusList])
        {
            [dbiListener dbiFailedWithError:@""];
            return;
        }
        
        [dbiListener dbiCompleted];
    });
}

-(void)forgroundDWIForListener:(id)listener
{
    pause = YES;
    self.dwiListener = listener;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
}

-(void)forgroundUWIForListener:(id)listener
{
    pause = YES;
    self.uwiListener = listener;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self updateCheckInOutStatus])
        {
            [uwiListener uwiFailedWithError:@""];
            return;
        }
        
        if(![self saveInspection])
        {
            [uwiListener uwiFailedWithError:@""];
            return;
        }
        
        if(![self updateFuelPurchase])
        {
            [uwiListener uwiFailedWithError:@""];
            return;
        }
    });
}

-(BOOL)getDeviceList
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getDevices"];
    [urlStr appendFormat:@"?token=%@", [UserDefaultsManager token]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *getDevicesRequest = [ASIHTTPRequest requestWithURL:url];
    [getDevicesRequest startSynchronous];
    
    if ([getDevicesRequest error])
    {
        return NO;
    }
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"devices\":%@}", getDevicesRequest.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        return NO;
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
    
    if (![context save:&error])
    {
        return NO;
    }
    
    return YES;
}

-(BOOL)getCountryState
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getCountryStates"];
    [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *getCountryStatesRequest = [ASIHTTPRequest requestWithURL:url];
    [getCountryStatesRequest startSynchronous];
    
    if ([getCountryStatesRequest error])
    {
        return NO;
    }
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"countryStates\":%@}",getCountryStatesRequest.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if(error)
    {
        return NO;
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
        return NO;
    }
    
    return YES;
}

-(BOOL)getInspectionList
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getInspectionLists"];
    [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *getInspectionListRequest = [ASIHTTPRequest requestWithURL:url];
    [getInspectionListRequest startSynchronous];
    
    if ([getInspectionListRequest error])
    {
        return NO;
    }
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"countryStates\":%@}",getInspectionListRequest.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        return NO;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionList" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if (fetchedArray && [fetchedArray count] > 1)
    {
        for (InspectionList *inspectionList in fetchedArray)
        {
            [context deleteObject:inspectionList];
        }
    }
    
    NSArray *inspectionListArray = [responseObject objectForKey:@"inspectionList"];
    
    InspectionListItemIdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < inspectionListArray.count; i++)
    {
        NSDictionary *inspectionListObject = [inspectionListArray objectAtIndex:i];
        InspectionList *inspectionList = [NSEntityDescription insertNewObjectForEntityForName:@"InspectionList" inManagedObjectContext:context];
        
        inspectionList.listId = [inspectionListObject objectForKey:@"id"];
        inspectionList.name = [inspectionListObject objectForKey:@"name"];
        
        [InspectionListItemIdArray addObject:[inspectionListObject objectForKey:@"id"]];
    }
    
    if (![context save:&error])
    {
        return NO;
    }
    
    return YES;
}

-(BOOL)getInspectionListItem
{
    BOOL flag = YES;
    for (int i = 0; i < InspectionListItemIdArray.count; i++)
    {
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getInspectionListItems"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        [urlStr appendFormat:@"&listId=%@",[InspectionListItemIdArray objectAtIndex:i]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIHTTPRequest *getInspectionListItemRequest = [ASIHTTPRequest requestWithURL:url];
        [getInspectionListItemRequest startSynchronous];
        
        if ([getInspectionListItemRequest error])
        {
            flag = NO;
        }
        
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithFormat:@"{\"inspectionListItem\":%@}",getInspectionListItemRequest.responseString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseObjet = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error)
        {
            flag = NO;
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionListItems" inManagedObjectContext:context];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:chartEntity];

        NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
        [fetchRequest release];

        if(fetchedArray && [fetchedArray count] > 1)
        {
            for(InspectionListItems *inspectionListItem in fetchedArray)
            {
                [context deleteObject:inspectionListItem];
            }
        }

        NSArray *inspectionListItemArray = [responseObjet objectForKey:@"inspectionListItem"];
        for(int i = 0; i < inspectionListItemArray.count; i++)
        {
            NSDictionary *inspectionListItemObject = [inspectionListItemArray objectAtIndex:i];
            InspectionListItems *inspectionListItem = [NSEntityDescription insertNewObjectForEntityForName:@"InspectionListItem" inManagedObjectContext:context];
            
            inspectionListItem.name = [inspectionListItemObject objectForKey:@"name"];
            inspectionListItem.itenId = [inspectionListItemObject objectForKey:@"id"];
        }

        if(![context save:&error])
        {
            flag = NO;
        }
    }
    return flag;
}

-(BOOL)getDriverStatusList
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getDriverStatusList"];
    [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *getDriverStatusListRequest = [ASIHTTPRequest requestWithURL:url];
    [getDriverStatusListRequest startSynchronous];
    
    if ([getDriverStatusListRequest error])
    {
        return NO;
    }
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"driverStatusList\":%@}",getDriverStatusListRequest.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        return NO;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"DriverStatusList" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchedArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];;
    [fetchRequest release];
    
    if (fetchedArray && [fetchedArray count] > 1)
    {
        for (DriverStatusList *driverStatusList in fetchedArray)
        {
            [context deleteObject:driverStatusList];
            
        }
    }
    
    NSArray *driverStatusListArray = [responseObject objectForKey:@"driverStatusList"];
    
    for (int i = 0; i < driverStatusListArray.count; i++)
    {
        NSDictionary *driverStatusListObject = [driverStatusListArray objectAtIndex:i];
        DriverStatusList *driverStatusList = [NSEntityDescription insertNewObjectForEntityForName:@"DriverStatusList" inManagedObjectContext:context];
        
        driverStatusList.name = [driverStatusListObject objectForKey:@"name"];
        driverStatusList.statusId = [driverStatusListObject objectForKey:@"id"];
    }
    
    if (![context save:&error])
    {
        return NO;
    }
    
    return YES;
}

#pragma dwi methods



#pragma uwi methods

-(BOOL)updateCheckInOutStatus
{
    NSError *error = nil;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"CheckInOut" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isSynced = %@", [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    for (CheckInOut *checkInOut in fetchedResult)
    {
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/updateCheckInStatus"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        [urlStr appendFormat:@"&deviceId=%@",[UserDefaultsManager deviceId]];
        [urlStr appendFormat:@"&odometer=%@",checkInOut.odometer];
        [urlStr appendFormat:@"&isCheckedIn=%c",[UserDefaultsManager isCheckedIn]];
        [urlStr appendFormat:@"&eventDate=%@",[NSDate date]];
        [urlStr appendFormat:@"&lat=%f",[UserDefaultsManager lastLat]];
        [urlStr appendFormat:@"&lng=%f",[UserDefaultsManager lastLng]];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIHTTPRequest *updateCheckInOutStatusRequest = [ASIHTTPRequest requestWithURL:url];
        
        [updateCheckInOutStatusRequest startSynchronous];
        
        checkInOut.isSynced = [NSNumber numberWithBool:YES];
        checkInOut.syncedOn = [NSDate date];
     
        
    }
    return YES;
}

-(BOOL)saveInspection
{
    NSError *error = nil;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Inspections" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isSynced = %@",[NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    for (Inspections *inspections in fetchedResult)
    {
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/saveInspection"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        [urlStr appendFormat:@"&devicdId=%@",inspections.deviceId];
        [urlStr appendFormat:@"&odometer=%@",inspections.odometer];
        [urlStr appendFormat:@"&eventDate=%@",inspections.eventDate];
        [urlStr appendFormat:@"&listId=%@",inspections.listId];
        [urlStr appendFormat:@"&itemId=%@",inspections.itemId];
        [urlStr appendFormat:@"&passed=%@",inspections.passed];
        [urlStr appendFormat:@"&failed=%@",inspections.failed];
        [urlStr appendFormat:@"&repaired=%@",inspections.repaired];
        [urlStr appendFormat:@"&notes=%@",inspections.notes];
        [urlStr appendFormat:@"&lat=%@",inspections.lat];
        [urlStr appendFormat:@"&lng=%@",inspections.lng];
        
        inspections.isSynced = [NSNumber numberWithBool:YES];
        inspections.syncedOn = [NSDate date];
    }
    
    return YES;
}

-(BOOL)updateFuelPurchase
{
    NSError *error = nil;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"FuelPurchases" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isSynced = %@",[NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    for (FuelPurchases *fuelPurchase in fetchedResult)
    {
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"http://etrack.ws/pilot.svc/saveFuelPurchase"];
        [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        [urlStr appendFormat:@"&deviceId=%@",fuelPurchase.deviceId];
        [urlStr appendFormat:@"&odometer=%@",fuelPurchase.eventDate];
        [urlStr appendFormat:@"&qty=%@",fuelPurchase.qty];
        [urlStr appendFormat:@"&amount=%@",fuelPurchase.amount];
        [urlStr appendFormat:@"&address=%@",fuelPurchase.address];
        [urlStr appendFormat:@"&stateId=%@",fuelPurchase.stateId];
        [urlStr appendFormat:@"&postalCode=%@",fuelPurchase.postalCode];
        [urlStr appendFormat:@"&lat=%@",fuelPurchase.lat];
        [urlStr appendFormat:@"&lng=%@",fuelPurchase.lng];

    }
    
    return YES;
}

#pragma listeners methods

-(void)dbiCompleted
{
    NSLog(@"Succeed");
}

-(void)dbiFailedWithError:(NSString*)error
{
    NSLog(@"Failed");
}

-(void)dwiCompleted
{
    
}

-(void)dwiFailedWithError:(NSString*)error
{
    
}

-(void)uwiCompleted
{
    
}

-(void)uwiFailedWithError:(NSString*)error
{
    
}

-(void)syncCompleted
{
    
}

-(void)syncFailedWithError:(NSString*)error
{
    
}
@end
