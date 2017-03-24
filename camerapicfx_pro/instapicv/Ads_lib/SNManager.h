//
//  SNManager.h
//  Alien Tower
//
//  Created by Asad Khan on 05/02/2013.
//
//

#import <Foundation/Foundation.h>

#import <Availability.h>

/*
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif
*/

#ifdef DEBUG
#define DebugLog(f, ...) NSLog(f, ## __VA_ARGS__)
#else
#define DebugLog(f, ...)
#endif


#define kPlayHavenAdTimeOutThresholdValue 4.0
#define kRevMobAdTimeOutThresholdValue 3.0

//#ifdef FreeApp
#define kRevMobId @"51757bda612d566b07000003"//@"508b256d3628350d00000025"

#define ChartBoostAppID @"50bf103b17ba47655d000002" // Neon Tower Paid
#define ChartBoostAppSignature @"094a0578c3f67bfa1177d54aeb1ca01064a0cf0d" //Neon tower Paid

//#define MOBCLIX_ID @"665A8F99-D0E1-49ED-9CB9-992EBDCA5619"//@"665A8F99-D0E1-49ED-9CB9-992EBDCA5619"//@"B7C698A4-FFF5-4B2F-822F-25170F8858C3"//@"2C63EF1A-CA74-4467-8D30-1032D073A367"//2C63EF1A-

#define kPlayHavenAppToken @"a2469b593d004a16bd94e3541b7ec7f0"
#define kPlayHavenSecret @"1d436962b6a84afaa9b3b9147143656b"
#define kPlayHavenPlacement @"main_menu"

//#define kTapJoyAppID @"79067244-565f-4e04-a077-07b6e724a328"
//#define kTapJoySecretKey @"OoMvmJeL25OTbTzqnGTv"
//#endif

#ifdef PaidApp
#define kRevMobId @"51757bda612d566b07000003"//@"508b256d3628350d00000025"

#define ChartBoostAppID @"50bf103b17ba47655d000002" // Neon Tower Paid
#define ChartBoostAppSignature @"094a0578c3f67bfa1177d54aeb1ca01064a0cf0d" //Neon tower Paid

//#define MOBCLIX_ID @"B7C698A4-FFF5-4B2F-822F-25170F8858C3"//@"2C63EF1A-CA74-4467-8D30-1032D073A367"//2C63EF1A-
#endif

typedef NS_ENUM(NSUInteger, adPriorityLevel){
    kPriorityLOWEST = 10,
    kPriorityNORMAL,
    kPriorityHIGHEST
};

typedef NS_ENUM(NSUInteger, ConnectionStatus) {
   
    kNotAvailable,
    kWANAvailable,
    kWifiAvailable
    
};

/*
 These are the default values before changing them do consult Angela
 */
#define kRevMobBannerAdPriority kPriorityHIGHEST  //In Game banner Ads
#define kRevMobFullScreenAdPriority kPriorityLOWEST //Full Screen Pop-ups
#define kRevMobButtonAdPriority kPriorityHIGHEST //Button ads this is not currently used in games, its just a wrapper on Link Ads
#define kRevMobLinkAdPriority kPriorityHIGHEST  //This is the Ad that is displayed on buttons on game over screens
#define kRevMobPopAdPriority kPriorityHIGHEST  //UIAlert type pop-up Ads in games
#define kRevMobLocalNotificationAdPriority kPriorityHIGHEST // UILocalNotification Ads //Currently we're not using it

#define kChartBoostFullScreeAdPriority kPriorityHIGHEST
#define kChartBoostMoreAppsAd kPriorityHIGHEST

//#define kMobClixBannerAdPriority kPriorityNORMAL
//#define kMobClixFullScreenAdPriority kPriorityNORMAL


#define kPlayHavenFullScreenAdPriority kPriorityNORMAL


//#define kRevMobBannerAdPriority kPriorityLOWEST  //In Game banner Ads
//#define kRevMobFullScreenAdPriority kPriorityNORMAL //Full Screen Pop-ups
//#define kRevMobButtonAdPriority kPriorityHIGHEST //Button ads this is not currently used in games, its just a wrapper on Link Ads
//#define kRevMobLinkAdPriority kPriorityHIGHEST  //This is the Ad that is displayed on buttons on game over screens
//#define kRevMobPopAdPriority kPriorityHIGHEST  //UIAlert type pop-up Ads in games
//#define kRevMobLocalNotificationAdPriority kPriorityHIGHEST // UILocalNotification Ads //Currently we're not using it
//
//#define kChartBoostFullScreeAdPriority kPriorityNORMAL
//#define kChartBoostMoreAppsAd kPriorityHIGHEST
//
//#define kMobClixBannerAdPriority kPriorityHIGHEST
//#define kMobClixFullScreenAdPriority kPriorityHIGHEST



#define kNumberOfAdNetworks 3

#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=685360755"//579388308"



@interface SNManager : NSObject



@end
