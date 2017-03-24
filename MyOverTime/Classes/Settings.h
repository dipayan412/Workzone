//
//  Settings.h
//  MyOvertime
//
//  Created by Nazmul Quader on 9/19/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, SettingsDayTemplate;

@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * dayTemplateId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *settingsDayTemplates;
@property (nonatomic, retain) Activity *checkinActivity;
@end

@interface Settings (CoreDataGeneratedAccessors)

- (void)addSettingsDayTemplatesObject:(SettingsDayTemplate *)value;
- (void)removeSettingsDayTemplatesObject:(SettingsDayTemplate *)value;
- (void)addSettingsDayTemplates:(NSSet *)values;
- (void)removeSettingsDayTemplates:(NSSet *)values;
@end
