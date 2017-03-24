//
//  UserDefaultsManager.m
//  Pharmacate
//
//  Created by Dipayan Banik on 6/24/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kUserToken          @"kUserToken"
#define kUserName           @"kUserName"
#define kUserFullName       @"kUserFullName"
#define kUDID               @"kUDID"
#define kUserProfilePicture @"kUserProfilePicture"
#define kUserId             @"kUserId"
#define kDownloadComplete   @"kDownloadComplete"
#define kSaveTempProductArray   @"kSaveTempProductArray"
#define kIsFirstLaunch   @"kIsFirstLaunch"
#define kDeviceToken    @"kDeviceToken"

@implementation UserDefaultsManager

+(NSString*)getUserToken
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserToken];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setUserToken:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUserToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getDeviceToken
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setDeviceToken:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUserName
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setUserName:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUserFullName
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserFullName];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setUserFullName:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUserFullName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUDID
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUDID];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setUDID:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUserId
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    if(value)
    {
        return value;
    }
    return @"";
}

+(void)setUserId:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveProfilePicture:(UIImage*)image
{
//    NSData *imageData = UIImagePNGRepresentation(image);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"userImage"]];
//    
//    NSLog((@"pre writing to file"));
//    if (![imageData writeToFile:imagePath atomically:NO])
//    {
//        NSLog((@"Failed to cache image data to disk"));
//    }
//    else
//    {
//        NSLog(@"the cachedImagedPath is %@",imagePath);
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:kUserProfilePicture];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:kUserProfilePicture];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(UIImage*)getProfilePicture
{
//    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:kUserProfilePicture];
//    if(value)
//    {
//        UIImage *profileImage = [UIImage imageWithContentsOfFile:value];
//        return profileImage;
//    }
//    return nil;
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserProfilePicture];
    UIImage* image = [UIImage imageWithData:imageData];
    if(image)
    {
        return image;
    }
    return nil;
}

+(void)setDownloadComplete:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kDownloadComplete];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isDownloadComplete
{
    BOOL value = [[NSUserDefaults standardUserDefaults] valueForKey:kDownloadComplete];
    if(value)
    {
        return value;
    }
    return NO;
}

+(void)setIsFirstLaunch:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kIsFirstLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isFirstLaunch
{
    BOOL value = [[NSUserDefaults standardUserDefaults] valueForKey:kIsFirstLaunch];
    return !value;
}

+(void)saveTempProductArray:(NSMutableArray*)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kSaveTempProductArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray*)getTempProductArray
{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveTempProductArray];
    if(array)
    {
        return array;
    }
    return nil;
}

@end
