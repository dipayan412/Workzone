//
//  PromoScanner.h
//  Grabber
//
//  Created by World on 3/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromoObject.h"

@protocol PromoScannerDelegate <NSObject>

-(void)didReceivePromo:(NSArray*)promoArray;

@end

@interface PromoScanner : NSObject <CLLocationManagerDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate>
{
    CLLocationManager *userLocationManager;
}
@property (nonatomic, retain) id <PromoScannerDelegate> delegate;

+(PromoScanner*)getInstance;
-(void)startPromoScanner;
-(void)startUpdatingLocation;
-(void)stopUpdateingLocation;

-(void)storePassToPassLibrary;
-(void)getPromoApiCallWithBeaccon:(CLBeacon*)foundBeacon;
-(void)grabPromoApiCall;
-(void)getShopsByLatLonApiCallWithUserLocation:(CLLocation*)userLocation;
-(void)shareWithFacebookModule;

@end
