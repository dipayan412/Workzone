//
//  Neocortex.h
//  Neocortex SDK
//
//  Created by Osama A. Zakaria on 9/1/2012.
//  Copyright (c) 2012 Kayabit, Inc. All rights reserved.
//

#ifndef Neocortex_h
#define Neocortex_h


#import "NeocortexHelpers.h"
#import "TapjoyConnect.h"
#import "Chartboost.h"
#import "Flurry.h"
#import <UIKit/UIViewController.h>
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
#import "MPAdConversionTracker.h"


@interface Neocortex : NSObject<ChartboostDelegate, MPAdViewDelegate, MPInterstitialAdControllerDelegate, UIAlertViewDelegate>
{
	
@private
	
	NSString *itunesAppID;
	
	ChartboostSettings chartboostSettings;
//	RevmobSettings revmobSettings;
	MopubSettings mopubSettings;
	TapjoySettings tapjoySettings;
	FlurrySettings flurrySettings;
	CustomPopupSettings customPopupSettings;
	
	AdItemSettings nagScreenOnBecomeActiveSettings;
	AdItemSettings nagScreenOnMainMenuSettings;
	AdItemSettings nagScreenOnLevelsMenuSettings;
	AdItemSettings nagScreenOnPauseMenuSettings;
	AdItemSettings nagScreenOnPlayingSettings;
	AdItemSettings nagScreenOnGameoverSettings;
	
	AdItemSettings bannerOnBecomeActiveSettings;
	AdItemSettings bannerOnMainMenuSettings;
	AdItemSettings bannerOnLevelsMenuSettings;
	AdItemSettings bannerOnPauseMenuSettings;
	AdItemSettings bannerOnPlayingSettings;
	AdItemSettings bannerOnGameoverSettings;
	
	AdItemSettings moreScreenSettings;
	
	MPAdView *_mPAdBannerView;
	MPAdView* _mPAdRectView;
	MPInterstitialAdController *_mPInterstitialAdController;
	
}

@property(nonatomic, assign) UIViewController *adViewController;
@property(nonatomic, assign) BOOL isMoreScreenEnabled;

+ (Neocortex*) getInstance;

- (void) showMoreScreen;
- (void) showBannerAd;
- (void) removeBannerAd;
- (void) removeRectAd;

- (void) onBecomeActive;
- (void) onLevelsMenu;
- (void) onMainMenu;
- (void) onPauseMenu;
- (void) onPlaying;
- (void) onGameover;
- (bool) areAdsPurchased;

@end


#endif
