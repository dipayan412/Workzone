//
//  AppDelegate.h
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/9/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlayHavenSDK.h"
//@class adwhirl_proViewController;
//#import "AdWhirlView.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "iRate.h"
#import "FirstVC.h"
#import "RatingsViewController.h"
//#import "ALSharedData.h"
//#import "ALInterstitialAd.h"

//#import <RevMobAds/RevMobAds.h>
//@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate,PHPublisherContentRequestDelegate,iRateDelegate,UIAlertViewDelegate>
@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate,iRateDelegate,UIAlertViewDelegate>
{
    UINavigationController *navController;
    NSTimer *playbacktimer;
    NSDate *date;
    NSTimeInterval remainingSec;
    UIImageView *splashimage;
    int done;
    UITabBarController *tabBarController;
//    BOOL TopAd;
//    BOOL bottomAd;
    BOOL sound;
    int tagId;
    NSMutableArray *storename;
    RatingsViewController *m_feedback;
    ////////
    
    NSMutableArray * notificationArray;
    NSInteger notificationID;
}
//@property BOOL TopAd;
//@property BOOL bottomAd;
@property BOOL sound;

@property (retain, nonatomic) UIWindow *window;
@property(nonatomic,retain)IBOutlet UINavigationController *navController;
@property (nonatomic, retain) UITabBarController *tabBarController;
-(void)loadData;
-(void)updateData;
-(void)setupVoice;
- (void) DismissAll;
- (void) ShowRating;
- (void)productPurchased:(NSNotification *)notification;
- (void)productPurchaseFailed:(NSNotification *)notification;


@property (nonatomic) NSInteger notificationID;
@property (nonatomic, retain) NSMutableArray * notificationArray;
@property (nonatomic, assign) int tagId;
@property (nonatomic, assign) int randomNum;
@property (nonatomic, assign) BOOL  isAlertView;
- (void) scheduleLocalNotificatoins;


- (void) setNotification:(NSDate *)notificationDate andTitle:(NSString *)notificationTitle andIndex:(NSInteger )notificationIndex;//
-(void) cancelAllNotification;//
- (void) rescheduleNotifications: (NSDate *)currentDate; //
- (void) handleNotifications: (UILocalNotification *) appNotification;//




@end
