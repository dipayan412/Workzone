//
//  MRMovieWriter.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/17.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRMovieWriter2.h"
#import <AVFoundation/AVFoundation.h>
#import "MRUtil.h"
#import "MRSettings.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface MRMovieWriter2 ()

@property (nonatomic) AVAssetWriterInputPixelBufferAdaptor *adaptor;
@property (nonatomic) AVAssetWriter *videoWriter;
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) BOOL paused;
@property (nonatomic) BOOL stopped;

@end

@implementation MRMovieWriter2


-(id)initWithTemplate:(MRTemplate *)template {
    
    if (self = [super init]) {
        self.stopped = NO;
        //NSLog(@"Initializing movie writer.");
        self.paused = NO;
        //create movie output writer
        NSString *outFile = [template.path stringByAppendingPathComponent:@"out.mp4"];
        NSURL *outUrl = [NSURL fileURLWithPath:outFile];
        
        //delete existing movie clip
        NSError *outError;
        [[NSFileManager defaultManager] removeItemAtURL:outUrl error:&outError];
        
        //set up the writer
        self.videoWriter = [[AVAssetWriter alloc] initWithURL: outUrl fileType:AVFileTypeMPEG4 error:&outError];
        NSParameterAssert(self.videoWriter);
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:640], AVVideoWidthKey,
                                       [NSNumber numberWithInt:360], AVVideoHeightKey,
                                       nil];
        
        AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                                assetWriterInputWithMediaType:AVMediaTypeVideo
                                                outputSettings:videoSettings];
        
        
        self.adaptor = [AVAssetWriterInputPixelBufferAdaptor
                        assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                        sourcePixelBufferAttributes:nil];
        
        NSParameterAssert(videoWriterInput);
        NSParameterAssert([self.videoWriter canAddInput:videoWriterInput]);
        
        videoWriterInput.expectsMediaDataInRealTime = NO;
        
        [self.videoWriter addInput:videoWriterInput];
        
        [self.videoWriter startWriting];
        [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
    }
    
    return self;
}


-(void)writeImage:(UIImage *)image atFrame:(NSInteger)frameIndex {
    
    CMTime time = [MRUtil timeForFrame:frameIndex];
    
    CGImageRef cgImage = [image CGImage];
    //TOOD get width and height from XML
    CVPixelBufferRef buffer = [self pixelBufferFromCGImage:cgImage andSize:CGSizeMake(640, 360)];
    //CGImageRelease(cgImage);
    
    BOOL append_ok = NO;
    int j = 0;
    while (!append_ok && j < 30)
    {
        if (self.adaptor.assetWriterInput.readyForMoreMediaData)
        {
            //printf("appending %lld attemp %d\n", time.value, j);            
            append_ok = [self.adaptor appendPixelBuffer:buffer withPresentationTime:time];
            
            if(buffer)
                CVBufferRelease(buffer);
            
            //[NSThread sleepForTimeInterval:0.05];
        }
        else
        {
            printf("adaptor not ready %lld, %d\n", time.value, j);
            [NSThread sleepForTimeInterval:0.1];
        }
        j++;
    }
    if (!append_ok) {
        printf("error appending image %lld times %d\n", time.value, j);
    }
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image andSize:(CGSize) size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    
    
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    //    CGContextConcatCTM(context, CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180)));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

-(void)finish {
    [self.videoWriter finishWritingWithCompletionHandler:^{
        //NSLog(@"Video writing finished.");
        
        //inform the delegate
        if (self.delegate) {
            [self.delegate movieWriterFinished];
        }
    }];
}

-(void)cancelProcess
{
    if(![self.queue isSuspended])
    {
        [self.queue cancelAllOperations];
    }
    self.stopped = YES;
}

-(void)pauseProcees
{
    //    self.paused = YES;
    //    [self.queue setSuspended:YES];
}

-(void)resumeProcees
{
    //    self.paused = NO;
    //    [self.queue setSuspended:NO];
}


@end
