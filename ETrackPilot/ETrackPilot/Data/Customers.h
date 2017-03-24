//
//  Customers.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customers : NSManagedObject

@property (nonatomic, retain) NSString * custId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * lastUpdatedOn;

@end
