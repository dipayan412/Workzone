//
//  UserDefaultsManager.h
//  iOS Prototype
//
//  Created by World on 2/28/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(BOOL)isKeepMeSignedInOn;
+(void)setKeepMeSignedIn:(BOOL)value;

+(NSString*)sessionToken;
+(void)setSessionToken:(NSString*)value;

+(BOOL)isSocialShareOn;
+(void)setSocialShareOn:(BOOL)value;

+(BOOL)isMerchantModeOn;
+(void)setMerchantModeOn:(BOOL)value;

+(BOOL)isUserBecomeMerchant;
+(void)setUserBecomeMerchant:(BOOL)value;

+(BOOL)isUserMerchant;
+(void)setUserMerchant:(BOOL)value;

+(BOOL)isEmailAlertsOn;
+(void)setEmailAlertsOn:(BOOL)value;

+(BOOL)isBeaconsEnabledOn;
+(void)setBeaconsEnabledOn:(BOOL)value;

+(BOOL)isFacebookEnabled;
+(void)setFacebookEnabled:(BOOL)value;

+(BOOL)isTwitterEnabled;
+(void)setTwitterEnabled:(BOOL)value;

+(BOOL)isInstagramEnabled;
+(void)setInstagramEnabled:(BOOL)value;

+(BOOL)isRenRenEnabled;
+(void)setRenRenEnabled:(BOOL)value;

+(BOOL)isWeiboEnabled;
+(void)setWeiboEnabled:(BOOL)value;

+(BOOL)isGooglePlusEnabled;
+(void)setGooglePlusEnabled:(BOOL)value;

+(BOOL)isPinterestEnabled;
+(void)setPinterestEnabled:(BOOL)value;

+(BOOL)isSavePasswordOn;
+(void)setSavePasswordOn:(BOOL)value;

+(NSString*)savedUsername;
+(void)setSaveUsername:(NSString*)value;

+(NSString*)savedPassword;
+(void)setSavePassword:(NSString*)value;

+(NSString*)fbUsername;
+(void)setFbUserName:(NSString*)value;

+(NSString*)fbEmail;
+(void)setFbEmail:(NSString*)value;

@end
