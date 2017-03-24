//
//  MRAudioWriter.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/22.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRAudioWriter.h"
#import <AVFoundation/AVFoundation.h>

@implementation MRAudioWriter

-(void)addAudio:(NSURL *)audioUrl toVideo:(NSURL *)videoUrl {
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    
    NSString* videoName = @"final.mov";
//    NSString* videoName = @"final.mp4";
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    //TOOD mp4 format does not seem to work
//    _assetExport.outputFileType = AVFileTypeMPEG4;
    NSLog(@"file type %@",_assetExport.outputFileType);
    
    _assetExport.outputURL = exportUrl;
    //_assetExport.shouldOptimizeForNetworkUse = NO;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {      
         if (self.delegate) {
             [self.delegate audioWriterFinished];
         }
     }];
    
}

@end
