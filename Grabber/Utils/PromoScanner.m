//
//  PromoScanner.m
//  Grabber
//
//  Created by World on 3/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PromoScanner.h"

#define kAlertArrayHandlingConstant 100;

@interface PromoScanner()

@property (nonatomic, retain) NSTimer *updateLocationTimer;

@end

@implementation PromoScanner
{
    ASIHTTPRequest *nearByShopRequest;
    ASIHTTPRequest *getPromoRequest;
    ASIHTTPRequest *grabPromoRequest;
    ASIHTTPRequest *getPromoByLatLonRequest;
    NSMutableArray *beaconRegionArray;
    NSMutableArray *alreadyUsedBeacons;
    NSMutableArray *promoArray;
    NSMutableArray *alertsArray;
    NSString *promoId;
    PKPass *grabbedPass;
    
    PromoObject *grabbedPromoObject;
    UIAlertView *loadingAlert;
}

@synthesize delegate;
@synthesize updateLocationTimer;

static PromoScanner *instance;
static int alertArrayIndex = 1;
static int alertArrayMax;

+(PromoScanner*)getInstance
{
    if(instance == nil)
    {
        instance = [[PromoScanner alloc] init];
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
        
        beaconRegionArray = [[NSMutableArray alloc] init];
        alreadyUsedBeacons = [[NSMutableArray alloc] init];
        promoArray = [[NSMutableArray alloc] init];
        alertsArray = [[NSMutableArray alloc] init];
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                                  message:@""
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
    }
    return self;
}

-(void)startPromoScanner
{
    if([UserDefaultsManager isBeaconsEnabledOn])
    {
        [self stopUpdateingLocation];
        
        [beaconRegionArray removeAllObjects];
        [alreadyUsedBeacons removeAllObjects];
        [promoArray removeAllObjects];
        [alertsArray removeAllObjects];
        
        [self startUpdatingLocation];
    }
    else
    {
        [self stopUpdateingLocation];
        
        [beaconRegionArray removeAllObjects];
        [alreadyUsedBeacons removeAllObjects];
        [promoArray removeAllObjects];
        [alertsArray removeAllObjects];
        
        userLocationManager = [[CLLocationManager alloc] init];
        userLocationManager.delegate = self;
        
        if(self.updateLocationTimer == nil)
        {
            self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(locationTimerTikked) userInfo:nil repeats:YES];
        }
    }
}

-(void)locationTimerTikked
{
    [userLocationManager startUpdatingLocation];
}

-(void)startUpdatingLocation
{
    userLocationManager = [[CLLocationManager alloc] init];
    userLocationManager.delegate = self;
    [userLocationManager startMonitoringSignificantLocationChanges];
}

-(void)stopUpdateingLocation
{
    [userLocationManager stopMonitoringSignificantLocationChanges];
    for(int i = 0; i < beaconRegionArray.count; i++)
    {
        CLBeaconRegion *beaconRegion = [beaconRegionArray objectAtIndex:i];
        [userLocationManager stopMonitoringForRegion:beaconRegion];
    }
    userLocationManager = nil;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *userLocation = [locations lastObject];
    NSLog(@"lat --> %f\nlng --> %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    if([UserDefaultsManager isBeaconsEnabledOn])
    {
        [self getShopsByLatLonApiCallWithUserLocation:userLocation];
    }
    else
    {
        [self getPromoByLatLonWithUserLocation:userLocation];
//        [userLocationManager stopUpdatingLocation];
    }
}

-(void)getPromoByLatLonWithUserLocation:(CLLocation*)userLocation
{
    [userLocationManager stopUpdatingLocation];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    
    [urlStr appendFormat:@"%@%@%@/%f/%f", baseUrl,
     getPromoBytLatLonApi,
     [UserDefaultsManager sessionToken],
     userLocation.coordinate.latitude,
     userLocation.coordinate.longitude];

    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    getPromoByLatLonRequest = [ASIHTTPRequest requestWithURL:url];
    getPromoByLatLonRequest.delegate = self;
    [getPromoByLatLonRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == nearByShopRequest)
    {
        [beaconRegionArray removeAllObjects];
        
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        if([responseObject objectForKey:@"data"] != nil)
        {
            NSArray *shopsArray = [responseObject objectForKey:@"data"];
            for(int i = 0; i < shopsArray.count; i++)
            {
                NSDictionary *tmp = [shopsArray objectAtIndex:i];
                if(![[tmp objectForKey:@"device_token"] isEqualToString:@""])
                {
                    NSString *uuidStr = [tmp objectForKey:@"device_token"];
                    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
                    
                    CLBeaconRegion *myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                                        identifier:@"com.appcoda.testregion"];
                    [myBeaconRegion setNotifyEntryStateOnDisplay:YES];
                    [myBeaconRegion setNotifyOnEntry:YES];
                    [myBeaconRegion setNotifyOnExit:YES];
                    
                    [userLocationManager startMonitoringForRegion:myBeaconRegion];
                    [userLocationManager requestStateForRegion:myBeaconRegion];
                    
                    [beaconRegionArray addObject:myBeaconRegion];
                }
            }
        }
    }
    else if(request == getPromoByLatLonRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        
        NSArray *promoTmpArray = [responseObject objectForKey:@"data"];
        for(int i = 0; i < promoTmpArray.count; i++)
        {
            NSDictionary *tmp = [promoTmpArray objectAtIndex:i];
            if([tmp objectForKey:@"_id"])
            {
                promoId = [tmp objectForKey:@"_id"];
                
                PromoObject *promo = [[PromoObject alloc] init];
                promo.promoId = [tmp objectForKey:@"_id"];
                promo.promoName = [tmp objectForKey:@"name"];
                promo.promoDetails = [tmp objectForKey:@"text"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:promo.promoName
                                                                message:[NSString stringWithFormat:@"%@",promo.promoDetails]                                                               delegate:self
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:@"Grab", nil];
                alert.tag = 100 + i;
                if(i == 0)
                {
                    [alert show];
                }
                
                [alertsArray addObject:alert];
                [promoArray addObject:promo];
            }
        }
        alertArrayMax = alertsArray.count;
        
        if(delegate)
        {
            [delegate didReceivePromo:promoArray];
        }
    }
    else if(request == getPromoRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        
        NSArray *promoTmpArray = [responseObject objectForKey:@"data"];
        for(int i = 0; i < promoTmpArray.count; i++)
        {
            NSDictionary *tmp = [promoTmpArray objectAtIndex:i];
            if([tmp objectForKey:@"_id"])
            {
                promoId = [tmp objectForKey:@"_id"];
                
                PromoObject *promo = [[PromoObject alloc] init];
                promo.promoId = [tmp objectForKey:@"_id"];
                promo.promoName = [tmp objectForKey:@"name"];
                promo.promoDetails = [tmp objectForKey:@"text"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:promo.promoName
                                                                message:[NSString stringWithFormat:@"%@ from %@",promo.promoDetails,promo.shopName]
                                                               delegate:self
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:@"Grab", nil];
                alert.tag = 100 + i;
                if(i == 0)
                {
                    [alert show];
                }
                
                [alertsArray addObject:alert];
                [promoArray addObject:promo];
            }
        }
        alertArrayMax = alertsArray.count;
        
        if(delegate)
        {
            [delegate didReceivePromo:promoArray];
        }
    }
    else if(request == grabPromoRequest)
    {
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"%@",request.responseString);
        int status = - 1;
        if([responseObject objectForKey:@"status"] != nil)
        {
            status = [[responseObject objectForKey:@"status"] intValue];
            if(status == 0)
            {
                NSString *urlStr  = [responseObject objectForKey:@"link"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                NSError *error;
                
                //init a pass object with the data
                PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
                grabbedPass = pass;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                                message:@"What you want to do with the pass?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Share with Facebook",@"Add Pass to library", nil];
                alert.tag = 1;
                [alert show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)//facebook
        {
            [self shareWithFacebookModule];
        }
        else if(buttonIndex == 2)
        {
            [self storePassToPassLibrary];
        }
        
        if(alertArrayIndex < alertArrayMax)
        {
            UIAlertView *alert = [alertsArray objectAtIndex:alertArrayIndex++];
            [alert show];
        }
    }
    else
    {
        if(buttonIndex == 1)
        {
            PromoObject *promo = [promoArray objectAtIndex:alertView.tag - 100];
            grabbedPromoObject = promo;
            [self grabPromoApiCall];
            [loadingAlert show];
        }
        else
        {
            if(alertArrayIndex < alertArrayMax)
            {
                UIAlertView *alert = [alertsArray objectAtIndex:alertArrayIndex++];
                [alert show];
            }
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"called");
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"finding beacons");
    for(int i = 0; i < beaconRegionArray.count; i++)
    {
        CLBeaconRegion *beaconRegion = [beaconRegionArray objectAtIndex:i];
        NSLog(@"idBeacon %@... idRegion %@",beaconRegion.identifier,region.identifier);
        if([beaconRegion.identifier isEqualToString:region.identifier])
        {
            [userLocationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"No beacons");
    for(int i = 0; i < beaconRegionArray.count; i++)
    {
        CLBeaconRegion *beaconRegion = [beaconRegionArray objectAtIndex:i];
        if(beaconRegion.identifier == region.identifier)
        {
            [userLocationManager stopMonitoringForRegion:beaconRegion];
        }
    }
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    NSLog(@"Beacon found!");
    
    CLBeacon *foundBeacon = [beacons firstObject];
    NSLog(@"proximity uuid -> %@",[foundBeacon.proximityUUID UUIDString]);
    
    for(int i = 0; i < beacons.count; i++)
    {
        CLBeacon *foundBeacon = [beacons objectAtIndex:i];
        if(alreadyUsedBeacons.count == 0)
        {
            [self getPromoApiCallWithBeaccon:foundBeacon];
        }
        else
        {
            for(int j = 0; j < alreadyUsedBeacons.count; j++)
            {
                CLBeacon *tmpBeacon = [alreadyUsedBeacons objectAtIndex:j];
                if(![tmpBeacon.proximityUUID.UUIDString isEqualToString:foundBeacon.proximityUUID.UUIDString] && !(tmpBeacon.minor == foundBeacon.minor) && !(tmpBeacon.major == foundBeacon.major))
                {
                    [self getPromoApiCallWithBeaccon:foundBeacon];
                }
            }
        }
        [alreadyUsedBeacons addObject:foundBeacon];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)storePassToPassLibrary
{
    if([PKPassLibrary isPassLibraryAvailable])
    {
        PKPassLibrary *pasLib = [[PKPassLibrary alloc] init];
        
        [pasLib addPasses:[NSArray arrayWithObject:grabbedPass] withCompletionHandler:nil];
        NSArray *tmp1 = [pasLib passes];
        if(tmp1.count > 0)
        {
            PKPass *q = [tmp1 objectAtIndex:0];
            [[UIApplication sharedApplication] openURL:[q passURL]];
        }
        
        if([pasLib containsPass:grabbedPass])
        {
            NSLog(@"ase");
        }
        else
        {
            
        }
    }
}

-(void)getPromoApiCallWithBeaccon:(CLBeacon*)foundBeacon
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/", baseUrl,getPromoApi,foundBeacon.proximityUUID.UUIDString];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    getPromoRequest = [ASIHTTPRequest requestWithURL:url];
    getPromoRequest.delegate = self;
    [getPromoRequest startAsynchronous];
}

-(void)grabPromoApiCall
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/%@", baseUrl,grabPromoApi,[UserDefaultsManager sessionToken],grabbedPromoObject.promoId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    grabPromoRequest = [ASIHTTPRequest requestWithURL:url];
    grabPromoRequest.delegate = self;
    [grabPromoRequest startAsynchronous];
}

-(void)getShopsByLatLonApiCallWithUserLocation:(CLLocation*)userLocation
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@%@%@/%@/%@", baseUrl,getShopsByLatLon,[UserDefaultsManager sessionToken],[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude],[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url -> %@",urlStr);
    nearByShopRequest = [ASIHTTPRequest requestWithURL:url];
    nearByShopRequest.delegate = self;
    [nearByShopRequest startAsynchronous];
}

-(void)shareWithFacebookModule
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"An offer has been grabbed";
    params.caption = [NSString stringWithFormat:@"You grabbed an offer from %@",grabbedPromoObject.shopName];
    params.picture = [NSURL URLWithString:@"http://algonyx.com/download/ios/Icon-120.png"];
    params.description = [NSString stringWithFormat:@"You can also grab this offer. Just Get Grabber on your Iphone and visit %@",grabbedPromoObject.shopName];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params])
    {
        // Present the share dialog
        
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error)
                                          {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          }
                                          else
                                          {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    }
    else
    {
        // Present the feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"An offer has been grabbed", @"name",
                                       [NSString stringWithFormat:@"You grabbed an offer from %@",grabbedPromoObject.shopName], @"caption",
                                       [NSString stringWithFormat:@"You can also grab this offer. Just Get Grabber on your Iphone and visit %@",grabbedPromoObject.shopName], @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://algonyx.com/download/ios/Icon-120.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error)
                                                      {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          }
                                                          else
                                                          {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"])
                                                              {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              }
                                                              else
                                                              {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

@end
