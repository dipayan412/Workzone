//
//  InspectionListItems.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InspectionListItems : NSManagedObject

@property (nonatomic, retain) NSString * listId;
@property (nonatomic, retain) NSString * itenId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastUpdatedOn;

@end
