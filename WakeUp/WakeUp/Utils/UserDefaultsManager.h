//
//  UserDefaultsManager.h
//  WakeUp
//
//  Created by World on 6/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(void)setAlarmTime:(NSDate*)time;
+(NSDate*)alarmTime;

+(void)setMotionAlarmTime:(NSDate*)time;
+(NSDate*)motionAlarmTime;

+(void)setKeepMeLoggedIn:(BOOL)_value;
+(BOOL)keepMeLoggedIn;

//+(void)setSessionToken:(NSString*)_value;
//+(NSString*)sessionToken;

+(void)setAccountVerified:(BOOL)_value;
+(BOOL)isAccountVerified;

+(void)setCurrentCountry:(NSString*)_value;
+(NSString*)currentCountry;

+(void)setToken:(NSString*)_value;
+(NSString*)token;

+(void)setAppLaunchedFirstTime:(BOOL)_value;
+(BOOL)isAppLuannchedFirstTime;

+(void)setUserName:(NSString*)_value;
+(NSString*)userName;

+(void)setUserProfilePicId:(NSString*)_value;
+(NSString*)userProfilePicId;

+(void)setDeviceToken:(NSString*)_value;
+(NSString*)deviceToken;

+(void)setUserPhoneNumber:(NSString*)_value;
+(NSString*)userPhoneNumber;

+(void)setAlarmOn:(BOOL)_value;
+(BOOL)isAlarmOn;

+(void)setMotionDetectionOn:(BOOL)_value;
+(BOOL)isMotionDetectionOn;

+(void)setSnoozeInterval:(int)_value;
+(int)snoozeInterval;

+(void)showBusyScreenToView:(UIView*)_view WithLabel:(NSString*)_str;
+(void)hideBusyScreenToView:(UIView*)_view;

+(void)setCSTime:(NSString*)_value;
+(NSString*)cSTime;

+(void)setCSTimeContact:(NSString*)_value;
+(NSString*)cSTimeContact;

+(void)setUserId:(NSString*)_value;
+(NSString*)UserId;

+(void)setPhoneBookArray:(NSArray*)_array;
+(NSArray*)phoneBookArray;

+(void)setDeviceShouldRegistereLater:(BOOL)_value;
+(BOOL)shouldRegistereLater;

+(void)goUpView:(UIView*)view ForTextField:(UITextField*)textField;
+(void)goDownView:(UIView*)view;

+(NSString*)getObserverToken;

+(UIColor*)getColorForTheme:(kUserColor)_color;

+(void)setUserColorTheme:(int)_value;
+(int)userColorTheme;


@end
