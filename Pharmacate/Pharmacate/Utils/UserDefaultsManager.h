//
//  UserDefaultsManager.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/24/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserDefaultsManager : NSObject

+(NSString*)getUserToken;
+(void)setUserToken:(NSString*)value;

+(NSString*)getDeviceToken;
+(void)setDeviceToken:(NSString*)value;

+(NSString*)getUserName;
+(void)setUserName:(NSString*)value;

+(NSString*)getUserFullName;
+(void)setUserFullName:(NSString*)value;

+(NSString*)getUDID;
+(void)setUDID:(NSString*)value;

+(NSString*)getUserId;
+(void)setUserId:(NSString*)value;

+(void)saveProfilePicture:(UIImage*)image;
+(UIImage*)getProfilePicture;

+(void)setDownloadComplete:(BOOL)value;
+(BOOL)isDownloadComplete;

+(void)setIsFirstLaunch:(BOOL)value;
+(BOOL)isFirstLaunch;

+(void)saveTempProductArray:(NSMutableArray*)array;
+(NSMutableArray*)getTempProductArray;


@end
