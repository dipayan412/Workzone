//
//  MRUtil.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRUtil.h"
#import <AVFoundation/AVFoundation.h>

#define MRSpaceWalk1Counter         @"MRSpaceWalk1Counter"
#define MRLovesongCounter           @"MRLovesongCounter"
#define MRTranspod1Counter          @"MRTranspod1Counter"
#define MRTranspodXmasCounter       @"MRTranspodXmasCounter"

#define MRSpacewalk2Counter         @"MRSpacewalk2Counter"
#define MRTranspod2Counter          @"MRTranspod2Counter"
#define MRSpacewars1Counter         @"MRSpacewars1Counter"
#define MRMRacerCounter             @"MRMRacerCounter"

#define MRUserAgreement             @"MRUserAgreement"

#define MRShowOrientationLockAlert  @"MRShowOrientationLockAlert"

@implementation MRUtil

+(void)showErrorMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops!" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alert show];
}

+(NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02i:%02i:%02i (%f)", hours, minutes, seconds, interval];
}


+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(CMTime)timeForFrame:(int)frameNumber {
    //return CMTimeMake(frameNumber, 30);
    return CMTimeMake((frameNumber * 20), 600);
}

+(void)productPurchased:(NSString*)_folderName
{
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    /*
    if([_folderName isEqualToString:mrMRacer])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointMRacerPurchased
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointMRacerPurchased forKey:kGAIEvent] build]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:mrMRacer];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([_folderName isEqualToString:mrSpacewalk2])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointSpaceWalk2Purchased
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointSpaceWalk2Purchased forKey:kGAIEvent] build]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:mrSpacewalk2];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([_folderName isEqualToString:mrSpacewars1])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointSpaceWars1Purchased
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointSpaceWars1Purchased forKey:kGAIEvent] build]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:mrSpacewars1];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([_folderName isEqualToString:mrTranspod2])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointTranspod2Purchased
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointTranspod2Purchased forKey:kGAIEvent] build]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:mrTranspod2];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
     */
    
    /*
    NSString *eventName = [NSString stringWithFormat:@"%@ Purchased", _folderName];
    [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:eventName
                                                           action:nil
                                                            label:nil
                                                            value:nil]
                    set:eventName forKey:kGAIEvent] build]];
    */
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_folderName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(BOOL)isProducePurchased:(NSString*)_folderName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:_folderName];
}

/*
+(ProductType)getTypeForFolderName:(NSString*)_folderName
{
    if([_folderName isEqualToString:mrMRacer])
    {
        return ProductTypeMRacer;
    }
    else if([_folderName isEqualToString:mrSpacewalk2])
    {
        return ProductTypeSpaceWalk2;
    }
    else if([_folderName isEqualToString:mrSpacewars1])
    {
        return ProductTypeSpaceWars;
    }
    else if([_folderName isEqualToString:mrTranspod2])
    {
        return ProductTypeTransPodGiant;
    }
    return 0;
}
 */

+ (NSString *) downloadableContentPath
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = paths;
    directory = [directory stringByAppendingPathComponent:@"Downloads"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:directory] == NO)
    {
        NSError *error;
        if ([fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error] == NO)
        {
            NSLog(@"Error: Unable to create directory: %@", error);
        }
        
        NSURL *url = [NSURL fileURLWithPath:directory];
        // exclude downloads from iCloud backup
        if ([url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error] == NO) {
            NSLog(@"Error: Unable to exclude directory from backup: %@", error);
        }
    }
    
    return directory;
}
    
/*
+(void)setCounterForTemplateFolder:(NSString*)_folderName counter:(int)_count
{
    if([_folderName isEqualToString:mrMRacer])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRMRacerCounter];
    }
    else if ([_folderName isEqualToString:mrSpacewalk1])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRSpaceWalk1Counter];
    }
    else if ([_folderName isEqualToString:mrSpacewalk2])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRSpacewalk2Counter];
    }
    else if ([_folderName isEqualToString:mrLovesong])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRLovesongCounter];
    }
    else if ([_folderName isEqualToString:mrSpacewars1])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRSpacewars1Counter];
    }
    else if ([_folderName isEqualToString:mrTranspod1])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRTranspod1Counter];
    }
    else if ([_folderName isEqualToString:mrTranspod2])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRTranspod2Counter];
    }
    else if ([_folderName isEqualToString:mrTranspodXmas])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:MRTranspodXmasCounter];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getCounterForTemplateFolder:(NSString*)_folderName
{
    if([_folderName isEqualToString:mrMRacer])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRMRacerCounter];
    }
    else if ([_folderName isEqualToString:mrSpacewalk1])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRSpaceWalk1Counter];
    }
    else if ([_folderName isEqualToString:mrSpacewalk2])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRSpacewalk2Counter];
    }
    else if ([_folderName isEqualToString:mrLovesong])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRLovesongCounter];
    }
    else if ([_folderName isEqualToString:mrSpacewars1])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRSpacewars1Counter];
    }
    else if ([_folderName isEqualToString:mrTranspod1])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRTranspod1Counter];
    }
    else if ([_folderName isEqualToString:mrTranspod2])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRTranspod2Counter];
    }
    else if ([_folderName isEqualToString:mrTranspodXmas])
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:MRTranspodXmasCounter];
    }
    return 0;
}
*/

+(void)setCounterForTemplateFolder:(NSString*)_folderName counter:(int)_count
{
    [[NSUserDefaults standardUserDefaults] setInteger:_count forKey:_folderName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getCounterForTemplateFolder:(NSString*)_folderName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:_folderName];
}

+(BOOL)isUserAgreementDone
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:MRUserAgreement];
}

+(void)setUserAgreedForCurrentVersion:(BOOL)_agreed
{
    [[NSUserDefaults standardUserDefaults] setBool:_agreed forKey:MRUserAgreement];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)passCheckpointForTemplateFolder:(NSString*)_folderName
{
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    /*
    if([_folderName isEqualToString:mrMRacer])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointMRacerUsed
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointMRacerUsed forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrSpacewalk1])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointSpaceWalk1Used
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointSpaceWalk1Used forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrSpacewalk2])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointSpaceWalk2Used
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointSpaceWalk2Used forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrLovesong])
    {

        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointLoveSongUsed
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointLoveSongUsed forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrSpacewars1])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointSpaceWars1Used
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointSpaceWars1Used forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrTranspod1])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointTranspod1Used
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointTranspod1Used forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrTranspod2])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointTranspod2Used
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointTranspod2Used forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrTranspodXmas])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointTranspodXmasUsed
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointTranspodXmasUsed forKey:kGAIEvent] build]];
    }
    else if ([_folderName isEqualToString:mrKhumba])
    {
        
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:MRCheckPointKhumbaUsed
                                                               action:nil
                                                                label:nil
                                                                value:nil]
                        set:MRCheckPointKhumbaUsed forKey:kGAIEvent] build]];
    }
     */
    
    /*
    NSString *eventName = [NSString stringWithFormat:@"%@ Used", _folderName];
    [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:eventName
                                                           action:nil
                                                            label:nil
                                                            value:nil]
                    set:eventName forKey:kGAIEvent] build]];
    */
}

+(void)setDoNotShowOrientationLockeAlert
{
    [[NSUserDefaults standardUserDefaults] setValue:@"DoNotShow" forKey:MRShowOrientationLockAlert];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)shouldShowOrientationLockAlert
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:MRShowOrientationLockAlert];
    if(storedPref && storedPref.length > 0)
    {
        return NO;
    }
    return YES;
}

+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

@end
