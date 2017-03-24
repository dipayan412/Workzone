//
//  CountryStates.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CountryStates : NSManagedObject

@property (nonatomic, retain) NSDate * lastUpdatedOn;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;

@end
