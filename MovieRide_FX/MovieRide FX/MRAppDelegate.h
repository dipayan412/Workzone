//
//  MRAppDelegate.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/07.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ZipArchive.h"
#import "MRProduct.h"

@interface MRAppDelegate : UIResponder <UIApplicationDelegate, ZipArchiveDelegate> {
//    SystemSoundID _buttonSoundId;
    AVAudioPlayer *buttonSoundPlayer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) int carosulCurrentItemIndex;

-(void)playButtonSound;
+(NSString *)recordingFilePath;
-(void)unzipBundledTemplates;
-(BOOL)saveDownloadedContentAndUnzipfile:(NSString*)_contentUrl toFolder:(NSString*)_folderName;

@end
