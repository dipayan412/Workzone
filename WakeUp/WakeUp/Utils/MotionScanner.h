//
//  MotionScanner.h
//  WakeUp
//
//  Created by World on 7/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotionScanner : NSObject

+(MotionScanner*)getInstance;
-(void)startMotionScanner;
-(void)stopMotionScanner;

@end
