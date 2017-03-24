//
//  MRFrameRenderer.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/07.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCompositor2.h"
#import "MRTemplate.h"
#import "MRTemplate.h"

#define BLENDING_MODE_ADD @"ADD"
#define BLENDING_MODE_CLEAR @"CLEAR"
#define BLENDING_MODE_DARKEN @"DARKEN"
#define BLENDING_MODE_DST @"DST"
#define BLENDING_MODE_DST_ATOP @"DST_ATOP"
#define BLENDING_MODE_DST_IN @"DST_IN"
#define BLENDING_MODE_DST_OUT @"DST_OUT"
#define BLENDING_MODE_DST_OVER @"DST_OVER"
#define BLENDING_MODE_LIGHTEN @"LIGHTEN"
#define BLENDING_MODE_MULTIPLY @"MULTIPLY"
#define BLENDING_MODE_OVERLAY @"OVERLAY"
#define BLENDING_MODE_SCREEN @"SCREEN"
#define BLENDING_MODE_SRC @"SRC"
#define BLENDING_MODE_SRC_ATOP @"SRC_ATOP"
#define BLENDING_MODE_SRC_IN @"SRC_IN"
#define BLENDING_MODE_SRC_OUT @"SRC_OUT"
#define BLENDING_MODE_SRC_OVER @"SRC_OVER"
#define BLENDING_MODE_XOR @"XOR"

@interface MRFrameRenderer2 : NSOperation

-(id)initWithTemplate:(MRTemplate *)template compositor:(MRCompositor2 *)compositor frame:(NSInteger)frameIndex;
-(UIImage *)renderedImage;

@end
