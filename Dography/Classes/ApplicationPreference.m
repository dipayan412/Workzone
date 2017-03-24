//
//  ApplicationPreference.m
//  RenoMate
//
//  Created by Nazmul Quader on 3/12/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "ApplicationPreference.h"

#define kRMDropboxEnabled @"kRMDropboxEnabled"
#define kRMFacebookEnabled @"kRMFacebookEnabled"
#define kRMPurchaseDone     @"kRMPurchaseDone"
#define kRMRatingOfferDisabled @"kRMRatingOfferDisabled"
#define kRMNumberOfLaunching @"kRMNumberOfLaunching"
#define kRMDropboxAlertShown    @"kRMDropboxAlertShown"

@implementation ApplicationPreference

+(void)setDropboxAlertAlreadyShown:(BOOL)shown
{
    [[NSUserDefaults standardUserDefaults] setBool:shown forKey:kRMDropboxAlertShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isDropboxAlertAlreadyShown
{
    NSString *storePref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMDropboxAlertShown];
    if (storePref)
    {
        return storePref.boolValue;
    }
    
    return NO;
}

+(BOOL)isRatingOfferDisabled
{
    NSString *storePref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMRatingOfferDisabled];
    if (storePref)
    {
        return storePref.boolValue;
    }
    
    return NO;
}

+(void)setRatingOfferDisabled:(BOOL)desabled
{
    [[NSUserDefaults standardUserDefaults] setBool:desabled forKey:kRMRatingOfferDisabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)launchCount
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMNumberOfLaunching];
    if(storedPref)
    {
        return storedPref.intValue;
    }
    return 0;
}

+(void)setLaunchCount:(int)number
{
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:kRMNumberOfLaunching];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDropboxEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kRMDropboxEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)dropboxEnabled
{
    NSString *storePref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMDropboxEnabled];
    if (storePref)
    {
        return storePref.boolValue;
    }
    
    return NO;
}

+(void)setFacebookEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kRMFacebookEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)facebookEnabled
{
    NSString *storePref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMFacebookEnabled];
    if (storePref)
    {
        return storePref.boolValue;
    }
    
    return NO;
}

+(BOOL)isProUpgradePurchaseDone
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kRMPurchaseDone];
    if(storedPref)
    {
        return storedPref.boolValue;
    }
    return NO;
}

+(void)setProUpgradePurchaseDone:(BOOL)done
{
    [[NSUserDefaults standardUserDefaults] setBool:done forKey:kRMPurchaseDone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    
    float heightToWidthRatio = image.size.height / image.size.width;
    float scaleFactor = 1;
    if(heightToWidthRatio > 0) {
        scaleFactor = newSize.height / image.size.height;
    } else {
        scaleFactor = newSize.width / image.size.width;
    }
    
    CGSize newSize2 = newSize;
    newSize2.width = image.size.width * scaleFactor;
    newSize2.height = image.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(newSize2);
    [image drawInRect:CGRectMake(0,0,newSize2.width,newSize2.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
