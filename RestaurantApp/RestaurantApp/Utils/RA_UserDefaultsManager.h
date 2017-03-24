//
//  RA_UserDefaultsManager.h
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>


// Social selection option
typedef enum {
    kFacebook = 0,
    kTwitter
}kSettingsOptions;

@interface RA_UserDefaultsManager : NSObject

+(CAGradientLayer*)getGradientLayerForBounds:(CGRect)bounds;
+(CAGradientLayer*)getGradientLayerInHomeCellForBounds:(CGRect)bounds;

+(void)setFacebookConnected:(BOOL)isConnected;
+(BOOL)isFacebookConnected;

+(void)setTwitterConnected:(BOOL)isConnected;
+(BOOL)isTwitterConnected;

+(void)setLanguageToItalian:(BOOL)value;
+(BOOL)isLanguageItalian;

+(NSArray*)getOrderItemsArray;
+(void)addMenuItems:(NSArray*)_menuItems;
+(void)removeAllItems;

-(void)setTakeAwaySent:(BOOL)isSent;
-(BOOL)isTakeAwaySent;

+(void)setAppLanuage:(NSString*)language;
+(NSString*)appLanguage;

+(void)setDeviceToken:(NSString*)token;
+(NSString*)deviceToken;

+(void)setDeviceEndPoint:(NSString*)endPoint;
+(NSString*)deviceEndPoint;

+(void)setHasRegisteredDeviceToken:(BOOL)hasRegistered;
+(BOOL)hasRegisteredDeviceToken;

@end
