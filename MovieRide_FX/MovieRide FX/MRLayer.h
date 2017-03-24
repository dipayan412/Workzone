//
//  MRLayer.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//layer type constants
#define LAYER_TYPE_VIDEO_FILE @"VideoFile"
#define LAYER_TYPE_RECORDED_LAYER @"recordedLayer"
#define LAYER_TYPE_STILL_IMAGE @"StillImage"
#define LAYER_TYPE_IMAGE_SEQUENCE @"ImageSequence"
#define LAYER_TYPE_TEXT_LAYER @"TextLayer"


@interface MRLayer : NSObject

@property (nonatomic) NSNumber *layerId;
@property (nonatomic) NSString *type;
@property (nonatomic) int inPoint;
@property (nonatomic) int lengthInFrames;
@property (nonatomic) NSString *blendingMode;

@property (nonatomic) NSString *pathToSourceFile;

@property (nonatomic) MRLayer *mask;

@property (nonatomic) NSArray *transformX;
@property (nonatomic) NSArray *transformY;
@property (nonatomic) NSArray *anchorX;
@property (nonatomic) NSArray *anchorY;
@property (nonatomic) NSArray *scaleX;
@property (nonatomic) NSArray *scaleY;
@property (nonatomic) NSArray *rotation;
@property (nonatomic) NSArray *opacity;


//Text layer properties
/*
@property (nonatomic) NSString *text;
@property (nonatomic) float fontSize;
@property (nonatomic) NSString *color;
@property (nonatomic) NSString *fontFamily;
@property (nonatomic) BOOL bold;
@property (nonatomic) BOOL italic;
@property (nonatomic) NSString *align;
 //TODO dropshadow object
 //TODO stokeEffect object
 */



@end
