//
//  MRSettings.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/03/30.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRSettings.h"

@implementation MRSettings


+(BOOL)shouldRenderAtHalfFrameRate {
    // this is configured in the device's Settings application
    
    //TODO cache value of this setting so that we do have to load it every time
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enabled_high_render"];
    return !enabled;
}

 
@end
