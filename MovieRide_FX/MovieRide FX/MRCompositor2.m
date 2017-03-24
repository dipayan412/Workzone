//
//  MRCompositor.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/07.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRCompositor2.h"
#import "MRVideoImageProducer2.h"
#import "MRUtil.h"
#import "MRAppDelegate.h"
#import "MRFrameRenderer2.h"
#import "MRMovieWriter2.h"
#import "MRSettings.h"

@interface MRCompositor2 ()
{
    BOOL processingCanceled;
    BOOL processingPaused;
    
    int currentCameraFrame;     //assuming there are only 1 visible camera layer at a time. Will not work for multiples
    int currentMaskFrame;       //assuing there are only 1 visible mask video layer at a time. Will not work for multiples
}

@property (nonatomic) NSDate *startDate;
@property (nonatomic) MRTemplate *template;
@property (nonatomic) NSMutableDictionary *videoImageProducers;
@property (nonatomic) NSMutableDictionary *maskImageProducers;
@property (nonatomic) NSMutableDictionary *stillImages; //a cache of still images
@property (nonatomic) NSMutableDictionary *maskImages;  //a cache of mask images
@property (nonatomic) NSInteger lastRecordedFrame;
@property (nonatomic) NSOperationQueue *renderQueue;


@property (nonatomic) MRMovieWriter2 *movieWriter;

//track progress
@property (nonatomic) NSInteger totalTasks;
@property NSInteger tasksCompleted; //can potentially be called from multiple threads, must be atomic

@end

@implementation MRCompositor2

@synthesize rotateImage;

-(id)initWithTemplate:(MRTemplate *)template {
    if (self = [super init]) {
        _template = template;
        processingCanceled = NO;
        processingPaused = NO;
    }
    return self;
}

-(void)compose {
    
    self.startDate = [NSDate date];
    self.lastRecordedFrame = 0;
    
    currentCameraFrame = 0;
    currentMaskFrame = 0;
    
    int currentFrame = 0;
    int endFrame = self.template.sequence.lengthInFrames - 1;
    
    self.totalTasks = self.template.sequence.lengthInFrames;
    self.tasksCompleted = 0;
    
    //cache the still images so we only have to load them once
    [self loadStillImages];
    [self loadMaskImages];
    
    self.movieWriter = [[MRMovieWriter2 alloc] initWithTemplate:self.template];
    self.movieWriter.delegate = self;
    
    [self initVideoImageProducers];
    [self initMaskImageProducers];
    
    int progressUpdateInterval = self.template.sequence.frameRate / 2;
    
    while (currentFrame <= (endFrame)) {
        @autoreleasepool {
            
            if(processingCanceled || processingPaused) return;
            
            //NSLog(@"Rendering frame %d", currentFrame);
            UIImage *image = [self renderFrame:currentFrame];
            
            self.tasksCompleted = currentFrame;
            
            if ((currentFrame % progressUpdateInterval) == 0) {
                [self notifyProgressWithImage:image];
            }            
            
            [self.movieWriter writeImage:image atFrame:currentFrame];
            
            currentFrame++;
            
        }
    }
    
    //finish off writing. will call delegate method when done
    [self.movieWriter finish];
}

// moviewriter delegate method
-(void)movieWriterFinished {
    NSLog(@"MovieWriter finished. Adding audio...");
    
    NSString *videoPath = [self.template.path stringByAppendingPathComponent:@"out.mp4"];
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    
    NSString *audioPath = [self.template.path stringByAppendingPathComponent:self.template.sequence.pathToSoundFile];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    
    MRAudioWriter *audioWriter = [[MRAudioWriter alloc] init];
    audioWriter.delegate = self;
    [audioWriter addAudio:audioUrl toVideo:videoUrl];
    
}

//audiowriter delegate
-(void)audioWriterFinished {
    
    NSDate *endDate = [NSDate date];
    NSTimeInterval lapsedInterval = [endDate timeIntervalSinceDate:self.startDate];
    NSString *lapsedStr = [MRUtil stringFromTimeInterval:lapsedInterval];
    
    NSLog(@"Processing finished in %@.", lapsedStr);
    
    //We are done! Notify the delegate
    if (self.delegate) {
        [self.delegate compositorFinished];
    }
    
}

-(void)notifyProgressWithImage:(UIImage*)_image
{
    double progress = (double)self.tasksCompleted / (double)self.totalTasks;
    if (self.delegate) {
        [self.delegate compositorProgressNotification:progress withRenderedImage:_image];
    }
    
}


-(void)loadStillImages {
    self.stillImages = [NSMutableDictionary dictionary];
    
    for (MRLayer *layer in self.template.layers) {
        if ([layer.type isEqualToString:LAYER_TYPE_STILL_IMAGE]) {
            NSString *fullpath = [self.template.path stringByAppendingPathComponent:layer.pathToSourceFile];
            UIImage *stillImage = [UIImage imageWithContentsOfFile:fullpath];
            [self.stillImages setObject:stillImage forKey:layer.pathToSourceFile];
        }
    }
}

-(void)loadMaskImages {
    self.maskImages = [NSMutableDictionary dictionary];
    
    for (MRLayer *layer in self.template.layers) {
        if (layer.mask) {
            if ([layer.mask.type isEqualToString:LAYER_TYPE_STILL_IMAGE]) {
                NSString *fullpath = [self.template.path stringByAppendingPathComponent:layer.mask.pathToSourceFile];
                UIImage *maskImage = [UIImage imageWithContentsOfFile:fullpath];
                [self.maskImages setObject:maskImage forKey:layer.mask.pathToSourceFile];
            }
        }
    }
}

-(UIImage *)renderFrame:(NSInteger)frameIndex
{    
    self.renderQueue = [NSOperationQueue new];
    self.renderQueue.name = @"Render Queue";
    self.renderQueue.maxConcurrentOperationCount = 1;    //sequential
    
    MRFrameRenderer2 *frameRenderer = [[MRFrameRenderer2 alloc] initWithTemplate:self.template compositor:self frame:frameIndex];
    [self.renderQueue addOperation:frameRenderer];
    
    [self.renderQueue waitUntilAllOperationsAreFinished];
    
    UIImage *image = [frameRenderer renderedImage];
    
    return image;
}

-(void)initVideoImageProducers {
    self.videoImageProducers = [NSMutableDictionary dictionary];
    
    //preprocessing - init video image producers for this batch
    for (MRLayer *layer in self.template.layers) {
        if (([layer.type isEqualToString:LAYER_TYPE_VIDEO_FILE]) || ([layer.type isEqualToString:LAYER_TYPE_RECORDED_LAYER])) {
            
            NSString *videoFile;
            BOOL shouldRotateImage = NO;
            
            if ([layer.type isEqualToString:LAYER_TYPE_RECORDED_LAYER]) {
                videoFile = [MRAppDelegate recordingFilePath];
                //recorded video have to be rotated 180 degrees if recorded in landscape left
                shouldRotateImage = self.rotateImage;
            }
            else if([layer.type isEqualToString:LAYER_TYPE_VIDEO_FILE]) {
                videoFile = [self.template.path stringByAppendingPathComponent:layer.pathToSourceFile];
            } else {
                assert(false);
            }
                
            MRVideoImageProducer2 *imgProd = [[MRVideoImageProducer2 alloc] initWithVideo:videoFile];
            imgProd.rotateImage = shouldRotateImage;
            
            [self.videoImageProducers setObject:imgProd forKey:layer.layerId];
        }
    }
}

-(void)initMaskImageProducers {
    self.maskImageProducers = [NSMutableDictionary dictionary];
    
    //preprocessing - int mask video image producers for this batch
    for (MRLayer *layer in self.template.layers) {
        if ([layer.mask.type isEqualToString:LAYER_TYPE_VIDEO_FILE]) {
            
            NSString *videoFile = [self.template.path stringByAppendingPathComponent:layer.mask.pathToSourceFile];
                
            MRVideoImageProducer2 *imgProd = [[MRVideoImageProducer2 alloc] initWithVideo:videoFile];
            
            [self.maskImageProducers setObject:imgProd forKey:layer.layerId];
            
        }
    }
    
}


-(UIImage *)nextVideoImageForLayer:(NSNumber *)layerId {
    MRVideoImageProducer2 *producer = [self.videoImageProducers objectForKey:layerId];
    UIImage *image = [producer nextImage];    
    return image;
}

-(UIImage *)nextMaskVideoImageForLayer:(NSNumber *)layerId {
    MRVideoImageProducer2 *producer = [self.maskImageProducers objectForKey:layerId];
    UIImage *image = [producer nextImage];
    return image;
}

/*
-(void)rewindVideoImageProducerForLayer:(NSNumber *)layerId {
    MRVideoImageProducer2 *producer = [self.videoImageProducers objectForKey:layerId];
    producer = [[MRVideoImageProducer2 alloc] initWithVideo:producer.videoFile];
}

-(void)rewindMaskVideoImageProducerForLayer:(NSNumber *)layerId {
    MRVideoImageProducer2 *producer = [self.maskImageProducers objectForKey:layerId];
    producer = [[MRVideoImageProducer2 alloc] initWithVideo:producer.videoFile];
}
*/


-(UIImage *)stillImageAtPath:(NSString *)imagePath {
    return [self.stillImages objectForKey:imagePath];
}

-(UIImage *)maskImageAtPath:(NSString *)imagePath {
    return [self.maskImages objectForKey:imagePath];
}

-(void)cancelProcessing
{
    if(![self.renderQueue isSuspended])
    {
        [self.renderQueue cancelAllOperations];
    }
    
    [self.movieWriter cancelProcess];
    
    processingCanceled = YES;
}

-(void)pauseProcessing
{
    //    processingPaused = YES;
    //    [self.movieWriter pauseProcees];
}

-(void)resumeProcessing
{
    //    processingPaused = NO;
    //    [self.movieWriter resumeProcees];
}

@end
