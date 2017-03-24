//
//  SyncListener.h
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncListener <NSObject>

-(void)syncCompleted;
-(void)syncFailedWithError:(NSString*)error;

@end
