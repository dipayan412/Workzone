//
//  UserDefaultsManager.m
//  iOS Prototype
//
//  Created by World on 2/28/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kKeepMeSignedIn     @"kKeepMeSignedIn"
#define kSessionToken       @"kSessionToken"
#define kSocialShareOn      @"kSocialShareOn"
#define kUserMerchant       @"kUserMerchant"
#define kMerchantModeOn     @"kMerchantModeOn"
#define kUserBecomeMerchant @"kUserBecomeMerchant"
#define kBeaconsEnabledOn   @"kBeaconsEnabledOn"
#define kEmailAlerts        @"kEmailAlerts"
#define kSavePassword       @"kSavePassword"

#define kFacebook           @"kFacebook"
#define kTwitter            @"kTwitter"
#define kInstagram          @"kInstagram"
#define kRenRen             @"kRenRen"
#define kWeibo              @"kWeibo"
#define kGooglePlus         @"kGooglePlus"
#define kPinterest          @"kPinterest"

#define kUsername           @"kUsername"
#define kPassword           @"kPassword"
#define kFbUserName         @"kFbUserName"
#define kFbEmail            @"kFbEmail"


@implementation UserDefaultsManager

+(BOOL)isKeepMeSignedInOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kKeepMeSignedIn];
    return value;
}

+(void)setKeepMeSignedIn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kKeepMeSignedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)sessionToken
{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken];
    return value;
}

+(void)setSessionToken:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isSocialShareOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kSocialShareOn];
    return value;
}

+(void)setSocialShareOn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSocialShareOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isMerchantModeOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kMerchantModeOn];
    return value;
}

+(void)setMerchantModeOn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kMerchantModeOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isUserBecomeMerchant
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kUserBecomeMerchant];
    return value;
}

+(void)setUserBecomeMerchant:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kUserBecomeMerchant];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isUserMerchant
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kUserMerchant];
    return value;
}

+(void)setUserMerchant:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kUserMerchant];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isEmailAlertsOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kEmailAlerts];
    return value;
}

+(void)setEmailAlertsOn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kEmailAlerts];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isBeaconsEnabledOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kBeaconsEnabledOn];
    return value;
}

+(void)setBeaconsEnabledOn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kBeaconsEnabledOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isFacebookEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kFacebook];
    return value;
}

+(void)setFacebookEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kFacebook];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isTwitterEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kTwitter];
    return value;
}

+(void)setTwitterEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kTwitter];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isInstagramEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kInstagram];
    return value;
}

+(void)setInstagramEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kInstagram];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isRenRenEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kRenRen];
    return value;
}

+(void)setRenRenEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kRenRen];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isWeiboEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kWeibo];
    return value;
}

+(void)setWeiboEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kWeibo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isGooglePlusEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kGooglePlus];
    return value;
}

+(void)setGooglePlusEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kGooglePlus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isPinterestEnabled
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kPinterest];
    return value;
}

+(void)setPinterestEnabled:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kPinterest];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isSavePasswordOn
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kSavePassword];
    return value;
}

+(void)setSavePasswordOn:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSavePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)savedUsername
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUsername];
    if(value)
    {
        return value;
    }
    return @""; 
}

+(void)setSaveUsername:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)savedPassword
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setSavePassword:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)fbUsername
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kFbUserName];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setFbUserName:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kFbUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)fbEmail
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kFbEmail];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setFbEmail:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kFbEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
