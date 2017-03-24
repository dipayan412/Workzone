//
//  MRVideoImageProducer2.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/05/15.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRVideoImageProducer2.h"
#import <AVFoundation/AVFoundation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MRVideoImageProducer2 ()

@property (nonatomic) AVAssetReader *assetReader;
@property (nonatomic) AVAssetReaderTrackOutput *trackOutput;
@property (nonatomic) UIImage *previousImage;

@end

@implementation MRVideoImageProducer2

-(MRVideoImageProducer2 *)initWithVideo:(NSString *)videoFile {
    self = [super init];
    
    self.videoFile = videoFile;
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:videoFile];
    AVAsset *asset = [AVAsset assetWithURL:url];
    self.assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        assert(NO);
    }
    
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [videoTracks objectAtIndex:0];
    
    NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
    float frameRate = track.nominalFrameRate;
    float noOfFrames = frameRate * duration;
    
    NSLog(@"Duration: %f", duration);
    NSLog(@"Frame rate: %f", frameRate);
    NSLog(@"No of frames: %f", noOfFrames);
        
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    
    self.trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:outputSettings];
    [self.assetReader addOutput:self.trackOutput];
    
    [self.assetReader startReading];
    
    return self;
}


-(UIImage *)nextImage {
    UIImage *image;
    
    if (self.assetReader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef buffer = [self.trackOutput copyNextSampleBuffer];
        image = [self imageFromSampleBuffer:buffer];
        if (buffer) {
            CFRelease(buffer);
        }        
    }
    
    if (image) {
        self.previousImage = image;
    }
    else {
        NSLog(@"WARNING: Could not retrieve video image. Using previous image.");
        image = self.previousImage;
    }
    
    if(self.rotateImage)
    {
        image = [self rotateImage:image rotatedByDegrees:-180];
    }
    
    
    return image;
}

- (UIImage *)rotateImage:(UIImage*)_image rotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,_image.size.width, _image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DEGREES_TO_RADIANS(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-_image.size.width / 2, -_image.size.height / 2, _image.size.width, _image.size.height), [_image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //TODO memory leak?
    //CGContextRelease(bitmap);
    
    return newImage;
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

@end
