//
//  DWIListener.h
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWIListener <NSObject>

-(void)dwiCompleted;
-(void)dwiFailedWithError:(NSString*)error;

@end
