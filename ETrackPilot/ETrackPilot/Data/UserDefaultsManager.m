//
//  UserDefaultsManager.m
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kPilot_Token            @"kPilot_Token"
#define kPilot_ExpDays          @"kPilot_ExpDays"
#define kPilot_TokenValidUntil  @"kPilot_TokenValidUntil"
#define kPilot_FullName         @"kPilot_FullName"
#define kPilot_IsCheckedIn      @"kPilot_IsCheckedIn"
#define kPilot_CheckedInSince   @"kPilot_CheckedInSince"
#define kPilot_DeviceId         @"kPilot_DeviceId"
#define kPilot_DriverStatusId   @"kPilot_DriverStatusId"
#define kPilot_DriverStatusSince @"kPilot_DriverStatusSince"
#define kPilot_LastLat          @"kPilot_LastLat"
#define kPilot_LastLng          @"kPilot_LastLng"
#define kPilot_LastUpdatedOn    @"kPilot_LastUpdatedOn"
#define kPilot_PurgeFreqDays    @"kPilot_PurgeFreqDays"
#define kPilot_SyncFreqSecs     @"kPilot_SyncFreqSecs"

#define kPilot_RememberMe       @"kPilot_RememberMe"

#define kPilot_Username         @"kPilot_Username"
#define kPilot_Password         @"kPilot_Password"

@implementation UserDefaultsManager

//+(void)setsy


+(void)setToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kPilot_Token];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setExpDays:(int)days
{
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:kPilot_ExpDays];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setTokenValidUntil:(NSDate*)validUntil
{
    [[NSUserDefaults standardUserDefaults] setValue:validUntil forKey:kPilot_TokenValidUntil];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setFullName:(NSString*)fullName
{
    [[NSUserDefaults standardUserDefaults] setValue:fullName forKey:kPilot_FullName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setCheckedIn:(BOOL)checkedIn
{
    [[NSUserDefaults standardUserDefaults] setBool:checkedIn forKey:kPilot_IsCheckedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setCheckedInSince:(NSDate*)since
{
    [[NSUserDefaults standardUserDefaults] setValue:since forKey:kPilot_CheckedInSince];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDeviceId:(NSString*)deviceId
{
    [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:kPilot_PurgeFreqDays];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDriverStatusId:(NSString*)statusId
{
    [[NSUserDefaults standardUserDefaults] setValue:statusId forKey:kPilot_DriverStatusId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDriverStatusSince:(NSDate*)since
{
    [[NSUserDefaults standardUserDefaults] setValue:since forKey:kPilot_DriverStatusSince];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLastLat:(CGFloat)lat
{
    [[NSUserDefaults standardUserDefaults] setFloat:lat forKey:kPilot_LastLat];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLastLng:(CGFloat)lng
{
    [[NSUserDefaults standardUserDefaults] setFloat:lng forKey:kPilot_LastLng];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLastUpdatedOn:(NSDate*)updatedOn
{
    [[NSUserDefaults standardUserDefaults] setValue:updatedOn forKey:kPilot_LastUpdatedOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)token
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_Token];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(int)expDays
{
    int storedPref = [[NSUserDefaults standardUserDefaults] integerForKey:kPilot_ExpDays];
    if (storedPref)
    {
        return storedPref;
    }
    return 0;
}

+(NSDate*)tokenValidUntil
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_TokenValidUntil];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(NSString*)fullName
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_FullName];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(BOOL)isCheckedIn
{
    BOOL storedPref = [[NSUserDefaults standardUserDefaults] boolForKey:kPilot_IsCheckedIn];
    
    return storedPref;
}

+(NSDate*)checkedInSince
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_CheckedInSince];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(NSString*)deviceId
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_DeviceId];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(NSString*)driverStatusId
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_DriverStatusId];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(NSDate*)driverStatusSince
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_DriverStatusSince];
    if (storedPref)
    {
        return storedPref;
    }
    return 0;
}

+(CGFloat)lastLat
{
    CGFloat storedPref = [[NSUserDefaults standardUserDefaults] floatForKey:kPilot_LastLat];
    if (storedPref)
    {
        return storedPref;
    }
    return 0;
}

+(CGFloat)lastLng
{
    CGFloat storedPref = [[NSUserDefaults standardUserDefaults] floatForKey:kPilot_LastLng];
    if (storedPref)
    {
        return storedPref;
    }
    return 0;
}

+(NSDate*)lastUpdatedOn
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_LastUpdatedOn];
    if (storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setPurgeFreqDays:(int)days
{
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:kPilot_PurgeFreqDays];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setSyncFreqSecs:(int)secs
{
    [[NSUserDefaults standardUserDefaults] setInteger:secs forKey:kPilot_SyncFreqSecs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)purgeFreqDays
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_PurgeFreqDays];
    if (storedPref)
    {
        return storedPref.intValue;
    }
    
    return 7;
}

+(int)syncFreqSecs
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_SyncFreqSecs];
    if (storedPref)
    {
        return storedPref.intValue;
    }
    
    return 300;
}

+(void)setRememberMe:(BOOL)data;
{
    [[NSUserDefaults standardUserDefaults] setBool:data forKey:kPilot_RememberMe];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)rememberMe
{
    BOOL storedPref = [[NSUserDefaults standardUserDefaults] boolForKey:kPilot_RememberMe];
    return storedPref;
}



+(void)setUsername:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:kPilot_Username];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setPassword:(NSString*)password
{
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:kPilot_Password];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)username
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_Username];
    return storedPref;
}
+(NSString*)password
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kPilot_Password];
    return storedPref;
}
@end
