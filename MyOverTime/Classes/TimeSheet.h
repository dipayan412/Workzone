//
//  TimeSheet.h
//  MyOvertime
//
//  Created by Ashif on 6/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Schedule;

@interface TimeSheet : NSManagedObject

@property (nonatomic, retain) NSNumber * subSequence;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * breakTime;
@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * flatTime;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * scheduleId;
@property (nonatomic, retain) NSString * activityId;
@property (nonatomic, retain) Activity *activity;
@property (nonatomic, retain) Schedule *schedule;

@end
