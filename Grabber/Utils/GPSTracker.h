//
//  GPSTracker.h
//  iOS Prototype
//
//  Created by World on 3/17/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSTracker : NSObject <CLLocationManagerDelegate, ASIHTTPRequestDelegate>
{
    CLLocationManager *userLocationManager;
    ASIHTTPRequest *gpsRequest;
}
+(GPSTracker*)getInstance;

-(void)startUpdating;
-(void)stopUpdateing;

@end
