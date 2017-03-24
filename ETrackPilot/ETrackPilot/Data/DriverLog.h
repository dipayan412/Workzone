//
//  DriverLog.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DriverLog : NSManagedObject

@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSString * driverStatusId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * durationMins;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * stateId;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSDate * syncedOn;

@end
