//
//  GPSTracker.m
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "GPSTracker.h"

@implementation GPSTracker

static GPSTracker *instance = nil;

+(GPSTracker*)getInstance
{
    if(instance == nil)
    {
        instance = [[GPSTracker alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        userLocationManager = [[CLLocationManager alloc] init];
        userLocationManager.delegate = self;
    }
    return self;
}

-(void)startUpdating
{
    [userLocationManager startMonitoringSignificantLocationChanges];
}

-(void)stopUpdateing
{
    [userLocationManager stopMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *userLocation = [locations lastObject];
    NSLog(@"lat --> %f\nlng --> %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/%@/%@", baseUrl,
     getShopsByLatLon,
     [UserDefaultsManager sessionToken],
     [NSString stringWithFormat:@"%f",
      userLocation.coordinate.latitude],
     [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    gpsRequest = [ASIHTTPRequest requestWithURL:url];
    gpsRequest.delegate = self;
    [gpsRequest startAsynchronous];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
//    NSError *error = nil;
//    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
//    NSLog(@"%@",request.responseString);
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}
@end
