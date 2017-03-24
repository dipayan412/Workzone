//
//  MRSettings.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/03/30.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG_FRAME_RENDERING NO

@interface MRSettings : NSObject


+(BOOL)shouldRenderAtHalfFrameRate;

@end
