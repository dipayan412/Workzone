//
//  NotificationScanner.h
//  WakeUp
//
//  Created by World on 6/26/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationScanner : NSObject

+(NotificationScanner*)getInstance;
-(void)startNotificationScanner;

@end
