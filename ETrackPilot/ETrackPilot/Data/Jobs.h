//
//  Jobs.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Jobs : NSManagedObject

@property (nonatomic, retain) NSString * jobId;
@property (nonatomic, retain) NSString * jobNumber;
@property (nonatomic, retain) NSString * custId;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * statusId;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * lastLat;
@property (nonatomic, retain) NSNumber * lastLng;
@property (nonatomic, retain) NSDate * lastUpdatedOn;
@property (nonatomic, retain) NSDate * createdOn;
@property (nonatomic, retain) NSNumber * isSynced;
@property (nonatomic, retain) NSDate * syncedOn;

@end
