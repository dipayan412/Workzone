//
//  UserDefaultsManager.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(void)setDailyNotification:(BOOL)value;
+(BOOL)dailyNotification;

+(void)setNotificationTime:(int)seconds;
+(int)notificationTime;

@end
