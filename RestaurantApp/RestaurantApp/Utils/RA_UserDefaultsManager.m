//
//  RA_UserDefaultsManager.m
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_UserDefaultsManager.h"

// UserDefaults Keys
#define kFacebookConnected  @"kFacebookConnected"
#define kTwitterConnected   @"kTwitterConnected"
#define RA_OrderItem        @"RA_OrderItem"
#define kTakeAwaySent       @"kTakeAwaySent"
#define kLanguageChanged    @"kLanguageChanged"
#define kHasDeviceToken     @"kHasDeviceToken"
#define kDeviceToken        @"kDeviceToken"
#define kDeviceEndPoint     @"kDeviceEndPoint"


@implementation RA_UserDefaultsManager

/**
 * Method name: getGradientLayerForBounds
 * Description: Adds gradiant layer to frame and returns CAGradientLayer
 * Parameters: CGRect, frame
 */
+(CAGradientLayer*)getGradientLayerForBounds:(CGRect)bounds
{
    UIColor *topColor = [UIColor colorWithRed:209.0f/255.0f green:70.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    UIColor *downColor = [UIColor colorWithRed:167.0f/255.0f green:30.0f/255.0f blue:13.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)topColor.CGColor,
                       (id)downColor.CGColor,
                       nil];
    
    gradient.frame = bounds;
    gradient.cornerRadius = 4.0f;
    return gradient;
}

/**
 * Method name: getGradientLayerInHomeCellForBounds
 * Description: Adds gradiant layer to frame and returns CAGradientLayer
 * Parameters: CGRect, frame
 */

+(CAGradientLayer*)getGradientLayerInHomeCellForBounds:(CGRect)bounds
{
    UIColor *topColor = [UIColor colorWithRed:95.0f/255.0f green:72.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    UIColor *downColor = [UIColor colorWithRed:67.0f/255.0f green:52.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)topColor.CGColor,
                       (id)downColor.CGColor,
                       nil];
    
    gradient.frame = bounds;
    return gradient;
}

/**
 * Method name: setFacebookConnected
 * Description: Stores the slelection state of facebook to user defaults
 * Parameters: BOOl, selected or not
 */
+(void)setFacebookConnected:(BOOL)isConnected
{
    [[NSUserDefaults standardUserDefaults] setBool:isConnected forKey:kFacebookConnected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: isFacebookConnected
 * Description: returns bool from user default
 * Parameters: none
 */
+(BOOL)isFacebookConnected
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFacebookConnected];
}

/**
 * Method name: setTwitterConnected
 * Description: Stores the slelection state of twitter to user defaults
 * Parameters: BOOl, selected or not
 */
+(void)setTwitterConnected:(BOOL)isConnected
{
    [[NSUserDefaults standardUserDefaults] setBool:isConnected forKey:kTwitterConnected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: isTwitterConnected
 * Description: returns bool from user default
 * Parameters: none
 */
+(BOOL)isTwitterConnected
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTwitterConnected];
}

/**
 * Method name: setLanguageToItalian
 * Description: stores the if the local language to Use localization from inside the app is Italian or not.
 * Parameters: Bool
 */
+(void)setLanguageToItalian:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kLanguageChanged];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: isLanguageItalian
 * Description: Check if the app language is set to Italian or not.
 * Parameters: none
 */
+(BOOL)isLanguageItalian
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kLanguageChanged];
    return value;
}

/**
 * Method name: setAppLanuage
 * Description: stores the local language to Use localization from inside the app.
 * Parameters: lanugage
 */
+(void)setAppLanuage:(NSString*)language
{
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:kAppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: appLanguage
 * Description: Returns the stored language.
 * Parameters: none
 */
+(NSString*)appLanguage
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] stringForKey:kAppLanguage];
    if (storedPref == nil || [storedPref isEqualToString:@"default"] || [storedPref isEqualToString:@""])
    {
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        return language;
    }
    return storedPref;
}

/**
 * Method name: setDeviceToken
 * Description: stores device token to send to amazon for registaring push
 * Parameters: Device token
 */
+(void)setDeviceToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: deviceToken
 * Description: Returns the stored device token to send to amazon for registaring push
 * Parameters: Device token
 */
+(NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceToken];
}

/**
 * Method name: setDeviceEndPoint
 * Description: stores device end point to send to amazon
 * Parameters: Device End point
 */
+(void)setDeviceEndPoint:(NSString*)endPoint
{
    [[NSUserDefaults standardUserDefaults] setValue:endPoint forKey:kDeviceEndPoint];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: deviceEndPoint
 * Description: Retunrs the stored device end point to send to amazon
 * Parameters: none
 */
+(NSString*)deviceEndPoint
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceEndPoint];
}

/**
 * Method name: setHasRegisteredDeviceToken
 * Description: Store if device token is registered
 * Parameters: hasRegirtered
 */
+(void)setHasRegisteredDeviceToken:(BOOL)hasRegistered
{
    [[NSUserDefaults standardUserDefaults] setBool:hasRegistered forKey:kHasDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method name: hasRegisteredDeviceToken
 * Description: Check if device token is registered or not
 * Parameters: none
 */
+(BOOL)hasRegisteredDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasDeviceToken];
}

/**
 * Method name: getOrderItemsArray
 * Description: Gets the stored orders from user defaults and retunrs an array of orders
 * Parameters: none
 */
+(NSArray*)getOrderItemsArray
{
    NSData *itemData = [[NSUserDefaults standardUserDefaults] objectForKey:RA_OrderItem];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    if(items)
    {
        return items;
    }
    return nil;
}

/**
 * Method name: getOrderItemsArray
 * Description: Gets the stored orders from user defaults and retunrs an array of orders
 * Parameters: none
 */
+(void)addMenuItems:(NSArray*)_menuItems
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_menuItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:RA_OrderItem];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeAllItems
{
    NSArray *arr = [[NSArray alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:RA_OrderItem];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setTakeAwaySent:(BOOL)isSent
{
    [[NSUserDefaults standardUserDefaults] setBool:isSent forKey:kTakeAwaySent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isTakeAwaySent
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:kTakeAwaySent];
    return value;
}


@end
