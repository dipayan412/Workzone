//
//  MRUtil.h
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//#import "GAI.h"



// Facebook

#define MRFacebookAppID @"246688485518264"

// GoogleAnalytics

#define MRGoogleAnalyticsTrackingId @"UA-49239463-1"

// Checkpoints
#define MRTestFlightAppToken @"24257f88-66d8-4e1a-b93b-0567f268e3be"
#define MRCheckPointHome @"Home"
#define MRCheckPointInfo @"Info"
#define MRCheckPointClips @"Clips"
#define MRCheckPointGallery @"Gallery"
#define MRCheckPointPurchase @"Purchase"
#define MRCheckPointPreview @"Preview"
#define MRCheckPointProcessing @"Processing"
#define MRCheckPointPlayer @"Player"
#define MRCheckPointCamera @"Camera"

// App related
#define mrKhumba @"Khumba"

/*
typedef enum
{
    ProductTypeSpaceWalk2,
    ProductTypeMRacer,
    ProductTypeSpaceWars,
    ProductTypeTransPodGiant
}ProductType;
*/

@interface MRUtil : NSObject

+(void)showErrorMessage:(NSString *)message;
+(NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
+ (NSString *) applicationDocumentsDirectory;
+(CMTime)timeForFrame:(int)frameNumber;

+(void)productPurchased:(NSString*)_folderName;
+(BOOL)isProducePurchased:(NSString*)_folderName;

//+(ProductType)getTypeForFolderName:(NSString*)_folderName;
+ (NSString *) downloadableContentPath;

+(void)setCounterForTemplateFolder:(NSString*)_folderName counter:(int)_count;
+(int)getCounterForTemplateFolder:(NSString*)_folderName;

+(BOOL)isUserAgreementDone;
+(void)setUserAgreedForCurrentVersion:(BOOL)_agreed;

+(void)passCheckpointForTemplateFolder:(NSString*)_folderName;

+(void)setDoNotShowOrientationLockeAlert;
+(BOOL)shouldShowOrientationLockAlert;

+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;
    
@end
