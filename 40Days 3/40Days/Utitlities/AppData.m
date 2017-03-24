//
//  AppData.m
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "AppData.h"
#import <QuartzCore/QuartzCore.h>

#define kSingleReminderTime @"kSingleReminderTime"
#define kRepeatingReminderTime @"kRepeatingReminderTime"

#define kSingleReminderDate @"kSingleReminderDate"
#define kRepeatingReminderDate @"kRepeatingReminderDate"

#define kIsSingleReminderCreated @"kIsSingleReminderCreated"
#define kIsRepeatingReminderCreated @"kIsRepeatingReminderCreated"

#define kLastOpenedDate @"kLastOpenedDate"
#define kFileTag @"kFileTag"
#define kCurrentDay @"kCurrentDay"

@implementation AppData

+(void)applyGenericButtonStylesOnButton:(UIButton*)btn
{
    btn.backgroundColor = [UIColor whiteColor];
    btn.clipsToBounds = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CALayer *btnLayer = btn.layer;
    btnLayer.borderColor = [UIColor clearColor].CGColor;
    btnLayer.borderWidth = 1;
    btnLayer.cornerRadius = 2;
}

+(void)setSingleReminderTime:(NSNumber*)_time
{
    [[NSUserDefaults standardUserDefaults] setValue:_time forKey:kSingleReminderTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber*)getSingleReminderTime
{
    NSNumber *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kSingleReminderTime];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setRepeatingReminderTime:(NSNumber*)_time
{
    [[NSUserDefaults standardUserDefaults] setValue:_time forKey:kRepeatingReminderTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber*)getRepeatingReminderTime
{
    NSNumber *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kRepeatingReminderTime];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setSingleReminderDate:(NSDate*)_date
{
    [[NSUserDefaults standardUserDefaults] setValue:_date forKey:kSingleReminderDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getSingleReminderDate
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kSingleReminderDate];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setRepeatingReminderDate:(NSDate*)_date
{
    [[NSUserDefaults standardUserDefaults] setValue:_date forKey:kRepeatingReminderDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getRepeatingReminderDate
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kRepeatingReminderDate];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setIsSingleReminderCreated:(BOOL)_created
{
    [[NSUserDefaults standardUserDefaults] setBool:_created forKey:kIsSingleReminderCreated];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isSingleReminderCreated
{
    BOOL storedPref = [[NSUserDefaults standardUserDefaults] boolForKey:kIsSingleReminderCreated];
    
    return storedPref;
}

+(void)setIsRepeatingReminderCreated:(BOOL)_created
{
    [[NSUserDefaults standardUserDefaults] setBool:_created forKey:kIsRepeatingReminderCreated];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isRepeatingReminderCreated
{
    BOOL storedPref = [[NSUserDefaults standardUserDefaults] boolForKey:kIsRepeatingReminderCreated];
    
    return storedPref;
}

+(void)setReminderDays:(NSArray*)_array
{
    [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"ReminderDays"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray*)getReminderDays
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReminderDays"];
    if(array)
    {
        return array;
    }
    else return nil;
}

+(void)setAppOpenedDate:(NSDate*)_date
{
    [[NSUserDefaults standardUserDefaults] setObject:_date forKey:kLastOpenedDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)lastOpenedDate
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenedDate];
    if (storedPref)
    {
        return storedPref;
    }
    return [NSDate date];
}

+(void)setDownloadedFileTag:(int)_tag
{
    [[NSUserDefaults standardUserDefaults] setInteger:_tag forKey:kFileTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getDownloadedFileTag
{
    int storedPref = [[NSUserDefaults standardUserDefaults] integerForKey:kFileTag];

    return storedPref;
}

+(void)setCurrentDay:(int)_day
{
    [[NSUserDefaults standardUserDefaults] setInteger:_day forKey:kCurrentDay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getCurrentDay
{
    int storedPref = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentDay];
    if(storedPref == 0) return 1;
    return storedPref;
}

+(int)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];    
}


@end
