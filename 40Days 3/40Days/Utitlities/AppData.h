//
//  AppData.h
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppTitle @"40 Days With Christ"
#define kAppBackGroung @"lesson_background.png"
#define kAppNavBarImage @"navBar.png"
#define kAudioFileUrlStarting @"http://40dayswithchrist.com/uploads/40_days_-_Day_"
#define kfileType @".mp3"

@interface AppData : NSObject

+(void)applyGenericButtonStylesOnButton:(UIButton*)btn;

+(void)setSingleReminderTime:(NSNumber*)_time;
+(NSNumber*)getSingleReminderTime;

+(NSNumber*)getRepeatingReminderTime;
+(void)setRepeatingReminderTime:(NSNumber*)_time;

+(void)setSingleReminderDate:(NSDate*)_date;
+(NSDate*)getSingleReminderDate;

+(void)setRepeatingReminderDate:(NSDate*)_date;
+(NSDate*)getRepeatingReminderDate;

+(void)setIsSingleReminderCreated:(BOOL)_created;
+(BOOL)isSingleReminderCreated;

+(void)setIsRepeatingReminderCreated:(BOOL)_created;
+(BOOL)isRepeatingReminderCreated;

+(void)setReminderDays:(NSArray*)_array;
+(NSArray*)getReminderDays;

+(NSDate*)lastOpenedDate;
+(void)setAppOpenedDate:(NSDate*)_date;

+(int)getDownloadedFileTag;
+(void)setDownloadedFileTag:(int)_tag;

+(int)getCurrentDay;
+(void)setCurrentDay:(int)_day;

+(int)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
