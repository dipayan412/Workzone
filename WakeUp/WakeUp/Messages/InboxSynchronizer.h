//
//  InboxSynchronizer.h
//  WakeUp
//
//  Created by World on 7/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxSynchronizer : NSObject
{
    BOOL started;
    BOOL running;
    
    NSTimer *scheduler;
}

+(InboxSynchronizer*)getInstance;
-(void)startSynchronizer;
-(void)synchronizeOnce;
-(void)stopSynchronizer;

@end
