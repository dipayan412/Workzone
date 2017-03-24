//
//  ApplicationPreference.h
//  RenoMate
//
//  Created by Nazmul Quader on 3/12/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationPreference : NSObject
{
    
}

+(void)setDropboxEnabled:(BOOL)enabled;
+(BOOL)dropboxEnabled;

+(void)setDropboxAlertAlreadyShown:(BOOL)shown;
+(BOOL)isDropboxAlertAlreadyShown;

+(BOOL)facebookEnabled;
+(void)setFacebookEnabled:(BOOL)enabled;

+(UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(BOOL)isProUpgradePurchaseDone;
+(void)setProUpgradePurchaseDone:(BOOL)done;

+(int)launchCount;
+(void)setLaunchCount:(int)number;
+(BOOL)isRatingOfferDisabled;
+(void)setRatingOfferDisabled:(BOOL)desabled;

@end
