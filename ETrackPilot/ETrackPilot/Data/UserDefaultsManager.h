//
//  UserDefaultsManager.h
//  ETrackPilot
//
//  Created by World on 7/10/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EP_PASSED,
    EP_FAILED,
    EP_REPAIRED
}EP_InspectionItemStatus;

@interface UserDefaultsManager : NSObject
{
    
}

+(void)setToken:(NSString*)token;
+(void)setExpDays:(int)days;
+(void)setTokenValidUntil:(NSDate*)validUntil;
+(void)setFullName:(NSString*)fullName;
+(void)setCheckedIn:(BOOL)checkedIn;
+(void)setCheckedInSince:(NSDate*)since;
+(void)setDeviceId:(NSString*)deviceId;
+(void)setDriverStatusId:(NSString*)statusId;
+(void)setDriverStatusSince:(NSDate*)since;
+(void)setLastLat:(CGFloat)lat;
+(void)setLastLng:(CGFloat)lng;
+(void)setLastUpdatedOn:(NSDate*)updatedOn;

+(NSString*)token;
+(int)expDays;
+(NSDate*)tokenValidUntil;
+(NSString*)fullName;
+(BOOL)isCheckedIn;
+(NSDate*)checkedInSince;
+(NSString*)deviceId;
+(NSString*)driverStatusId;
+(NSDate*)driverStatusSince;
+(CGFloat)lastLat;
+(CGFloat)lastLng;
+(NSDate*)lastUpdatedOn;


+(void)setPurgeFreqDays:(int)days;
+(void)setSyncFreqSecs:(int)secs;

+(int)purgeFreqDays;
+(int)syncFreqSecs;

+(void)setRememberMe:(BOOL)data;
+(BOOL)rememberMe;

+(void)setUsername:(NSString*)username;
+(void)setPassword:(NSString*)password;

+(NSString*)username;
+(NSString*)password;
@end
