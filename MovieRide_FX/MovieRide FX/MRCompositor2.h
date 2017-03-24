//
//  MRCompositor.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/07.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRTemplate.h"
#import "MRMovieWriter2.h"
#import "MRAudioWriter.h"

@protocol MRComposerDelegate <NSObject>

@required
//-(void)compositorProgressNotification:(double)progress;
-(void)compositorProgressNotification:(double)progress withRenderedImage:(UIImage*)_image;
-(void)compositorFinished;

@end

@interface MRCompositor2 : NSObject <MRMovieWriterDelegate, MRAudioWriterDelegate>

@property (nonatomic) id<MRComposerDelegate> delegate;
@property (nonatomic, assign) BOOL rotateImage;

-(id)initWithTemplate:(MRTemplate *)template;
-(void)compose;

-(UIImage *)nextVideoImageForLayer:(NSNumber *)layerId;
-(UIImage *)nextMaskVideoImageForLayer:(NSNumber *)layerId;

//-(void)rewindVideoImageProducerForLayer:(NSNumber *)layerId;
//-(void)rewindMaskVideoImageProducerForLayer:(NSNumber *)layerId;

-(UIImage *)stillImageAtPath:(NSString *)imagePath;
-(UIImage *)maskImageAtPath:(NSString *)imagePath;

-(void)cancelProcessing;
-(void)pauseProcessing;
-(void)resumeProcessing;

@end
