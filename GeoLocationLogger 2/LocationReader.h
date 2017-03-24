//
//  DataUploader.h
//  SocialHeroes
//
//  Created by Nazmul Quader on 7/22/13.
//  Copyright (c) 2013 Nazmul Quader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationReader : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *userLocationManager;
    BOOL waitForUpdate;
}

+(LocationReader*)getInstance;

-(void)startUploading;
-(void)stopUploading;

@end
