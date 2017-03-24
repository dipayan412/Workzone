//
//  DriverStatusList.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DriverStatusList : NSManagedObject

@property (nonatomic, retain) NSString * statusId;
@property (nonatomic, retain) NSString * name;

@end
