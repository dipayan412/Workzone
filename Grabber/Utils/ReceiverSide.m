//
//  ReceiverSide.m
//  iOS Prototype
//
//  Created by World on 2/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ReceiverSide.h"

@implementation ReceiverSide

@synthesize locationManager;
@synthesize myBeaconRegion;
@synthesize isBeaconFound;
@synthesize grabPromoRequest;

static ReceiverSide *instance = nil;

+(ReceiverSide*)getInstance
{
    if (instance == nil)
    {
        instance = [[ReceiverSide alloc] init];
    }
    
    return instance;
}

-(id)init
{
    if (self = [super init])
    {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
        
        self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 identifier:@"com.appcoda.testregion"];
        [self.myBeaconRegion setNotifyEntryStateOnDisplay:YES];
        [self.myBeaconRegion setNotifyOnEntry:YES];
        [self.myBeaconRegion setNotifyOnExit:YES];
        self.isBeaconFound = YES;
    }
    
    return self;
}

-(void)startReceivingSignal
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager requestStateForRegion:self.myBeaconRegion];
}

-(void)stopReceivingSignal
{
    [self.locationManager stopMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"called");
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"finding beacons");
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"No beacons");
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    NSLog(@"Beacon found!");
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
// You can retrieve the beacon data from its properties
    
    NSLog(@"test");
    NSLog(@"proximity uuid -> %@",[foundBeacon.proximityUUID UUIDString]);
    if(self.isBeaconFound)
    {
        self.isBeaconFound = !self.isBeaconFound;
        
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@%@%@/", baseUrl,getPromoApi,foundBeacon.proximityUUID.UUIDString];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url -> %@",urlStr);
        self.getPromoRequest = [ASIHTTPRequest requestWithURL:url];
        self.getPromoRequest.delegate = self;
        [self.getPromoRequest startAsynchronous];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"authorization changed %u",status);
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == self.getPromoRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        
        NSArray *promoArray = [responseObject objectForKey:@"data"];
        NSDictionary *tmp = [promoArray objectAtIndex:0];
        promoId = [tmp objectForKey:@"_id"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Promo Alert"
                                                        message:@"There is a Promo in this shop"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"Grab", nil];
        [alert show];
    }
    else if(request == self.grabPromoRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        
        int status = - 1;
        if([responseObject objectForKey:@"status"] != nil)
        {
            NSLog(@"exist");
            
            status = [[responseObject objectForKey:@"status"] intValue];
            if(status == 0)
            {
                NSString *urlStr  = [responseObject objectForKey:@"link"];
                
                if([PKPassLibrary isPassLibraryAvailable])
                {
                    PKPassLibrary *pasLib = [[PKPassLibrary alloc] init];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                    NSError *error;
                    
                    //init a pass object with the data
                    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
                    
                    [pasLib addPasses:[NSArray arrayWithObject:pass] withCompletionHandler:nil];
                    NSArray *tmp1 = [pasLib passes];
                    if(tmp1.count > 0)
                    {
                        PKPass *q = [tmp1 objectAtIndex:0];
                        [[UIApplication sharedApplication] openURL:[q passURL]];
                    }
                    
                    if([pasLib containsPass:pass])
                    {
                        NSLog(@"ase");
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        else
        {
            NSLog(@"dont exist");
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableString *urlStr = [[NSMutableString alloc] init];
        [urlStr appendFormat:@"%@%@%@/%@", baseUrl,grabPromoApi,[UserDefaultsManager sessionToken],promoId];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"url -> %@",urlStr);
        self.grabPromoRequest = [ASIHTTPRequest requestWithURL:url];
        self.grabPromoRequest.delegate = self;
        [self.grabPromoRequest startAsynchronous];
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"1");
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    NSLog(@"2");
}
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"3");
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    NSLog(@"3");
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"4");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"5");
}
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    NSLog(@"6");
}
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"7");
}
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"8");
}
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"9");
}
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"10");
}

@end
