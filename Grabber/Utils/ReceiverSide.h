//
//  ReceiverSide.h
//  iOS Prototype
//
//  Created by World on 2/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReceiverSide : NSObject<CLLocationManagerDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate>
{
    NSString *promoId;
}

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isBeaconFound;
@property (nonatomic, retain) ASIHTTPRequest *getPromoRequest;
@property (nonatomic, retain) ASIHTTPRequest *grabPromoRequest;


+(ReceiverSide*)getInstance;
-(void)startReceivingSignal;
-(void)stopReceivingSignal;

@end
