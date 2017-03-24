//
//  FuelPurchases.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FuelPurchases : NSManagedObject

@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * stateId;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSDate * syncedOn;

@end
