//
//  NotificationInfo.h
//  NotificationTest
//
//  Created by muhammad on 8/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationInfo : NSObject
{
    NSString *notifTitle;
    NSInteger notifDay;
    NSString * notifID;
}

@property (nonatomic, retain) NSString *notifTitle;
@property (nonatomic) NSInteger notifDay;
@property (nonatomic, retain) NSString * notifID;


-(id) initWithDictionary:(NSDictionary *)data;

@end
//★STAY ON TRACK★ Open up and calculate your Calories and BMI for the past day