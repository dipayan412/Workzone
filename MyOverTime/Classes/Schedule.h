//
//  Schedule.h
//  MyOvertime
//
//  Created by Ashif on 6/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyTemplate, SettingsDayTemplate, TimeSheet;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSNumber * offset;
@property (nonatomic, retain) NSDate * scheduleDate;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) MyTemplate *myTemplate;
@property (nonatomic, retain) NSSet *timeSheets;
@property (nonatomic, retain) SettingsDayTemplate *settingsDayTemplate;

@property (nonatomic) NSInteger weekNumber,monthNumber,yearNumber;
@property (nonatomic) NSInteger weekNumberSince2010,monthNumberSince2010;
-(void)makeDateComponents;

@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addTimeSheetsObject:(TimeSheet *)value;
- (void)removeTimeSheetsObject:(TimeSheet *)value;
- (void)addTimeSheets:(NSSet *)values;
- (void)removeTimeSheets:(NSSet *)values;
@end
