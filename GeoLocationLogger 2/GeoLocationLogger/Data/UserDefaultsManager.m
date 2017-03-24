//
//  UserDefaultsManager.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kMLDailyNotififaction   @"kMLDailyNotififaction"
#define kMLNotificationTime     @"kMLNotificationTime"

@implementation UserDefaultsManager

+(void)setDailyNotification:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kMLDailyNotififaction];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)dailyNotification
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:kMLDailyNotififaction];
    if(str)
    {
        return str.boolValue;
    }
    return NO;
}

+(void)setNotificationTime:(int)seconds
{
    [[NSUserDefaults standardUserDefaults] setInteger:seconds forKey:kMLNotificationTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)notificationTime
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:kMLNotificationTime];
    if(str)
    {
        return str.intValue;
    }
    return 0;
}

@end
