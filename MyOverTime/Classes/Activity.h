//
//  Activity.h
//  MyOvertime
//
//  Created by Nazmul Quader on 9/19/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Settings, TimeSheet;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * showAmount;
@property (nonatomic, retain) NSNumber * estimateMode;
@property (nonatomic, retain) NSNumber * overtimeReduce;
@property (nonatomic, retain) NSNumber * useDefault;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * activityTitle;
@property (nonatomic, retain) NSNumber * isEnabled;
@property (nonatomic, retain) NSNumber * allowance;
@property (nonatomic, retain) NSNumber * subSequence;
@property (nonatomic, retain) NSNumber * flatMode;
@property (nonatomic, retain) NSNumber * offsetValue;
@property (nonatomic, retain) NSSet *timeSheets;
@property (nonatomic, retain) NSSet *settings;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addTimeSheetsObject:(TimeSheet *)value;
- (void)removeTimeSheetsObject:(TimeSheet *)value;
- (void)addTimeSheets:(NSSet *)values;
- (void)removeTimeSheets:(NSSet *)values;
- (void)addSettingsObject:(Settings *)value;
- (void)removeSettingsObject:(Settings *)value;
- (void)addSettings:(NSSet *)values;
- (void)removeSettings:(NSSet *)values;
@end
