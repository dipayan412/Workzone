//
//  MotionScanner.m
//  WakeUp
//
//  Created by World on 7/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "MotionScanner.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionScanner()
{
    CMMotionManager *motionManager;
}

@end

@implementation MotionScanner

static MotionScanner *instance = nil;

+(MotionScanner*)getInstance
{
    if(instance == nil)
    {
        instance = [[MotionScanner alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        motionManager = [[CMMotionManager alloc] init];
        motionManager.deviceMotionUpdateInterval = 1;
    }
    return self;
}

-(void)startMotionScanner
{
    [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         [self getMotion:motion];
     }];
}

-(void)stopMotionScanner
{
    [motionManager stopDeviceMotionUpdates];
}

-(void)getMotion:(CMDeviceMotion*)motion
{
    if(fabs(motion.rotationRate.x) > 1 || fabs(motion.rotationRate.y) > 1 || fabs(motion.rotationRate.z) > 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserMovedPhone object:nil];
        NSLog(@"Device moved");
    }
}

@end
