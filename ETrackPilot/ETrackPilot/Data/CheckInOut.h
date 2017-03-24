//
//  CheckInOut.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckInOut : NSManagedObject

@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * isCheckedIn;
@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSDate * syncedOn;

@end
