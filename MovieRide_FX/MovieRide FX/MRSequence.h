//
//  MRSequence.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRSequence : NSObject

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int lengthInFrames;
@property (nonatomic) int frameRate;

@property (nonatomic) int recWidth;
@property (nonatomic) int recHeight;
@property (nonatomic) int recLengthInFrames;

@property (nonatomic) int audioChannels;
@property (nonatomic) NSString *pathToSoundFile;

@property (nonatomic) NSString *pathToOverlayStart;
@property (nonatomic) NSString *pathToOverlayEnd;
@property (nonatomic) NSString *filenamePrefix;
@property (nonatomic) NSString *compressionFormat;
@property (nonatomic) int compressionKbpsMultiplier;
@property (nonatomic) int thumbnailFrame;

@end
