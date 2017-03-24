//
//  MyTemplate.h
//  MyOvertime
//
//  Created by Ashif on 6/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface MyTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * subSequence;
@property (nonatomic, retain) NSString * templateName;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * scheduleId;
@property (nonatomic, retain) Schedule *schedule;

@end
