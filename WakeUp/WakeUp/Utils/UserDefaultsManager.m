//
//  UserDefaultsManager.m
//  WakeUp
//
//  Created by World on 6/11/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kAlarmTime          @"kAlarmTime"
#define kMotionAlarmTime    @"kMotionAlarmTime"
#define kKeepMeLoggedIn     @"kKeepMeLoggedIn"
#define kSessionToken       @"kSessionToken"
#define kAccountVerified    @"kAccountVerified"
#define kCurrentCountry     @"kCurrentCountry"
#define kToken              @"kToken"
#define kAppLuancheFirstTime    @"kAppLuancheFirstTime"
#define kUserName           @"kUserName"
#define kUserPhotoId        @"kUserPhotoId"
#define kDeviceToken        @"kDeviceToken"
#define kUserPhoneNumber    @"kUserPhoneNumber"
#define kAlarmOn            @"kAlarmOn"
#define kMotionDetection    @"kMotionDetection"
#define kSnoozeInterval     @"kSnoozeInterval"
#define kCSTime             @"kCSTime"
#define kCSTimeContact      @"kCSTimeContact"
#define kMotionOn           @"kMotionOn"
#define kUserId             @"kUserId"
#define kPhoneBookArray     @"kPhoneBookArray"
#define kShouldRegistereDeviceLater @"kShouldRegistereDeviceLater"
#define kUserTheme          @"kUserTheme"

@implementation UserDefaultsManager

+(void)setAlarmTime:(NSDate*)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:kAlarmTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)alarmTime
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kAlarmTime];
    return date;
}

+(void)setMotionAlarmTime:(NSDate*)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:kMotionAlarmTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)motionAlarmTime
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kMotionAlarmTime];
    if(date == nil)
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        NSString *dateString = @"05:30";
        date = [df dateFromString:dateString];
    }
    return date;
}

+(void)setKeepMeLoggedIn:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kKeepMeLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)keepMeLoggedIn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kKeepMeLoggedIn];
    return value;
}

//+(void)setSessionToken:(NSString*)_value
//{
//    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kSessionToken];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//+(NSString*)sessionToken
//{
//    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionToken];
//    if(str)
//    {
//        return str;
//    }
//    return @"";
//}

+(void)setAccountVerified:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kAccountVerified];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isAccountVerified
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kAccountVerified];
    return value;
}

+(void)setCurrentCountry:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kCurrentCountry];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)currentCountry
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCountry];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setToken:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)token
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setAppLaunchedFirstTime:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kAppLuancheFirstTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isAppLuannchedFirstTime
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kAppLuancheFirstTime];
    return value;
}

+(void)setUserName:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)userName
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setUserProfilePicId:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kUserPhotoId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)userProfilePicId
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPhotoId];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setDeviceToken:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)deviceToken
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setUserPhoneNumber:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kUserPhoneNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)userPhoneNumber
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPhoneNumber];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setAlarmOn:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kAlarmOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isAlarmOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kAlarmOn];
    return value;
}

+(void)setMotionDetectionOn:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kMotionOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isMotionDetectionOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kMotionOn];
    return value;
}

+(void)setSnoozeInterval:(int)_value
{
    [[NSUserDefaults standardUserDefaults] setInteger:_value forKey:kSnoozeInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)snoozeInterval
{
    int value = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kSnoozeInterval];
    if(value < 1)
    {
        value = 60;
    }
    return value;
}

+(void)showBusyScreenToView:(UIView*)_view WithLabel:(NSString*)_str;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_view animated:YES];
    hud.labelText = _str;
    hud.labelColor = [UIColor lightGrayColor];
}

+(void)hideBusyScreenToView:(UIView*)_view
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_view animated:YES];
        });
    });
}

+(void)setCSTime:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kCSTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)cSTime
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kCSTime];
    if(str)
    {
        return str;
    }
    return @"0";
}

+(void)setCSTimeContact:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kCSTimeContact];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)cSTimeContact
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kCSTimeContact];
    if(str)
    {
        return str;
    }
    return @"0";
}

+(void)setUserId:(NSString*)_value
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)UserId
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    if(str)
    {
        return str;
    }
    return @"";
}

+(void)setPhoneBookArray:(NSArray*)_array
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kPhoneBookArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray*)phoneBookArray
{
    NSData *itemData = [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneBookArray];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    if(items)
    {
        return items;
    }
    return nil;
}

+(void)setDeviceShouldRegistereLater:(BOOL)_value
{
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:kShouldRegistereDeviceLater];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)shouldRegistereLater
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kShouldRegistereDeviceLater];
    return value;
}

+(void)goUpView:(UIView*)view ForTextField:(UITextField*)textField
{
    CGRect textFieldFrame = textField.frame;
    int textfieldLastLineY = textFieldFrame.origin.y + textFieldFrame.size.height;
    int up = 0;
    if(textfieldLastLineY > 216)
    {
        up = 216 - textfieldLastLineY;
        
        [UIView animateWithDuration:0.35f animations:^{
            CGRect frame = view.frame;
            frame.origin.y = up;
            view.frame = frame;
        }];
    }
}

+(void)goDownView:(UIView*)view
{
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = view.frame;
        frame.origin.y = 0;
        view.frame = frame;
    }];
}

+(NSString*)getObserverToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"ObserverToken"];
    if(token && token.length)
    {
        return token;
    }
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    token = (__bridge NSString *)(string);
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"ObserverToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return token;
}

+(void)setUserColorTheme:(int)_value
{
    [[NSUserDefaults standardUserDefaults] setInteger:_value forKey:kUserTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)userColorTheme
{
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:kUserTheme];
    if(value == 0)
    {
        [UserDefaultsManager setUserColorTheme:kColor1];
        return kColor1;
    }
    return value;
}

+(UIColor*)getColorForTheme:(kUserColor)_color
{
    switch (_color)
    {
        case kColor1:
            
            return kThemeColor1;
            
        case kColor2:
            
            return kThemeColor2;
            
        case kColor3:
            
            return kThemeColor3;
            
        case kColor4:
            
            return kThemeColor4;
            
        case kColor5:
            
            return kThemeColor5;
            
        case kColor6:
            
            return kThemeColor6;
            
        case kColor7:
            
            return kThemeColor7;
            
        case kColor8:
            
            return kThemeColor8;
            
        default:
            break;
    }
    
    return kThemeColor1;
}

@end
