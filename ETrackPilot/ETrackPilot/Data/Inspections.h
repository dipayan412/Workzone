//
//  Inspections.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Inspections : NSManagedObject

@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSString * listId;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSNumber * failed;
@property (nonatomic, retain) NSNumber * repaired;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSDate * syncedOn;

@end
