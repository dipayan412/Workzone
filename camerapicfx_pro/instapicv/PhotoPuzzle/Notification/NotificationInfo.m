//
//  NotificationInfo.m
//  NotificationTest
//
//  Created by muhammad on 8/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationInfo.h"

@implementation NotificationInfo
@synthesize notifID, notifDay, notifTitle;


- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) 
    {
        self.notifTitle = [data objectForKey:@"Title"];
        self.notifDay = [[data objectForKey:@"Day"] intValue];
        self.notifID = [data objectForKey:@"id"];
    }
    
    return self;
}


-(void) dealloc
{
    self.notifID = nil;
    self.notifTitle = nil;
    
    [super dealloc];
}

- (NSString*) description
{
    NSString * temp = [NSString stringWithFormat:@"%@ %d %@", self.notifTitle, self.notifDay, self.notifID];
    return temp;
}


@end
