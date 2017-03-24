//
//  MessageRoomSynchronizer.h
//  WakeUp
//
//  Created by World on 7/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageRoom.h"

@interface MessageRoomSynchronizer : NSObject
{
    BOOL started;
    BOOL running;
    
    NSTimer *scheduler;
}

+(MessageRoomSynchronizer*)getInstance;
-(void)startSynchronizer:(MessageRoom*)_partnerId;
-(void)synchronizeOnce:(MessageRoom*)_partnerId;
-(void)stopSynchronizer;

@end
