//
//  SettingsDayTemplate.h
//  MyOvertime
//
//  Created by Ashif on 6/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule, Settings;

@interface SettingsDayTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * templateEnabled;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * scheduleId;
@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) Settings *setting;

@end
