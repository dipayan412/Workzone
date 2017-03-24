//
//  MRAppDelegate.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2013/07/07.
//  Copyright (c) 2013 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRAppDelegate.h"
#import "ZipArchive.h"
#import "MRUtil.h"
//#import "PushNotificationManager.h"
//#import <Pushwoosh/PushNotificationManager.h>
//#import <FacebookSDK/FacebookSDK.h>


@implementation MRAppDelegate

@synthesize carosulCurrentItemIndex;

/*
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification
{
    NSLog(@"Push notification received");
    NSLog(@"PushDictionary %@", pushNotification);
}
 */

-(void)playButtonSound {
//    AudioServicesPlaySystemSound(_buttonSoundId);
    if([buttonSoundPlayer isPlaying])
    {
        [buttonSoundPlayer stop];
    }
    [buttonSoundPlayer play];
}

-(void)initButtonSound {
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"button_sound" ofType:@"caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFile];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL, &_buttonSoundId);
//    
    buttonSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    buttonSoundPlayer.volume = 1.0f;
    [buttonSoundPlayer prepareToPlay];
}

+(NSString *)recordingFilePath {
    NSString *fileUrl = [NSString stringWithFormat:@"%@/recording.mov", NSTemporaryDirectory()];
    return fileUrl;
}

-(void)unzipBundledTemplates {
    NSLog(@"Unzip any new bundled templates.");
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *templatesFolder = [documentsDirectory stringByAppendingPathComponent:@"templates"];

    NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
    NSArray *products = [MRProduct productsFromFile:productsFile];
    
    for (MRProduct *product in products) {
        
        NSString *templateFolder = [templatesFolder stringByAppendingPathComponent:product.templateFolder];
        BOOL templateFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:templateFolder];
        
        //only unzip if it does not already exist
        if (!templateFolderExists) {
            
            if([product.type isEqualToString:@"Embedded"])
            {
                NSString *zipFilePath = [[NSBundle mainBundle] pathForResource:product.templateFolder ofType:@"zip"];
                
                ZipArchive* za = [[ZipArchive alloc] init];
                
                if( [za UnzipOpenFile:zipFilePath] )
                {
                    if( [za UnzipFileTo:templatesFolder overWrite:YES] != NO )
                    {
                        NSLog(@"Unzip %@ succeeded.", product.templateFolder);
                    }
                    else
                    {
                        NSLog(@"Unzip %@ FAILED!", product.templateFolder);
                    }
                    
                    [za UnzipCloseFile];
                }
                else
                {
                    NSLog(@"Could not open ZIP file.");
                }
            }
        }
    }
}

-(BOOL)saveDownloadedContentAndUnzipfile:(NSString*)_contentUrl toFolder:(NSString *)_folderName
{
    NSLog(@"Unzip any new downloaded templates.");
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *templatesFolder = [documentsDirectory stringByAppendingPathComponent:@"templates"];
    
    NSString *productsFile = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"xml"];
    NSArray *products = [MRProduct productsFromFile:productsFile];
    
    for (MRProduct *product in products)
    {
        if([product.type isEqualToString:@"Downloadable"])
        {
            if([product.templateFolder isEqualToString:_folderName])
            {
                NSString *templateFolder = [templatesFolder stringByAppendingPathComponent:product.templateFolder];
                BOOL templateFolderExists = [[NSFileManager defaultManager] fileExistsAtPath:templateFolder];
                
                //only unzip if it does not already exist
                if (!templateFolderExists)
                {
                    ZipArchive* za = [[ZipArchive alloc] init];
                    za.delegate = self;
                    if([za UnzipOpenFile:_contentUrl])
                    {
                        if( [za UnzipFileTo:templatesFolder overWrite:YES] != NO )
                        {
                            NSLog(@"Unzip %@ succeeded.", product.templateFolder);
                            [za UnzipCloseFile];
                            return YES;
                        }
                        else
                        {
                            NSLog(@"Unzip %@ FAILED!", product.templateFolder);
                            [za UnzipCloseFile];
                            return NO;
                        }
                    }
                    else
                    {
                        NSLog(@"Could not open ZIP file.");
                        return NO;
                    }
                }
            }
        }
    }
    return NO;
}

-(void) ErrorMessage:(NSString*) msg
{
    NSLog(@"error message %@", msg);
}

-(void)setupAppearance {
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIImage *thumbImage = [UIImage imageNamed:@"sliderhandle.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //prevent screen from going blank during processing (user should keep watching adverts instead)
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //TODO switch off when done to save battery power
    //Need this to determine camera orientation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    NSString *versionString = [NSString stringWithFormat:@"%@", [MRUtil build]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:versionString forKey:@"app_version"];
    [defaults synchronize];
    
    [application setApplicationIconBadgeNumber:0];
        
    //[GAI sharedInstance].trackUncaughtExceptions = YES;
    //[GAI sharedInstance].dispatchInterval = 10;
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:MRGoogleAnalyticsTrackingId];
    
    //[tracker set:kGAIEventCategory value:@"App Launched"];
    
    //[tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSLog(@"iPad screen size");
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        UIViewController *initViewController = [storyBoard instantiateInitialViewController];
        [self.window setRootViewController:initViewController];
    }
    else
    {
        if(result.height == 1136){
            NSLog(@"iPhone5 screen size");
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
        else {
            NSLog(@"iPhone4 screen size");
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone4" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
    }
    
    [self setupAppearance];
    
    [self initButtonSound];
    
    carosulCurrentItemIndex = - 1;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //[[GAI sharedInstance] dispatch];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[FBSettings setDefaultAppID:MRFacebookAppID];
    //[FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
