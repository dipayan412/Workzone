//
//  Neocortex.m
//  Neocortex SDK
//
//  Created by Osama A. Zakaria on 9/1/2012.
//  Copyright (c) 2012 Kayabit, Inc. All rights reserved.
//

#import "Neocortex.h"

@interface Neocortex(Private)

- (BOOL) start;
- (NSString *) neocortexSettingsURL;
- (BOOL) loadNeocortexSettings;
- (NSDictionary *) getDictionaryWithUrlStr:(NSString *)urlStr;
- (void) fillAdItemSettings:(AdItemSettings *)adItemSettings fromDic:(NSDictionary *)sourceDic;
- (void) showAdItem:(AdItemSettings *)adItemSettings location:(NSString *)location;

@end




@implementation Neocortex



static Neocortex* _neocortex = nil;




+ (Neocortex*) getInstance
{
	
	@synchronized([Neocortex class]) {
		if(!_neocortex)
			[[self alloc] init];
		
		return _neocortex;
	}
	
	return nil;
	
}


+ (id) alloc
{
	
	@synchronized ([Neocortex class]) {
		
		NSAssert(_neocortex == nil, @"Attempted to allocate a second instance of the Neocortex singleton");
		_neocortex = [super alloc];
		return _neocortex;
	}
	
	return nil;
	
}


-(id) init
{
	
	self = [super init];
	
	if (self != nil) {
		
		NSLog(@"Neocortex Singleton, init");
		
	}
	
	return self;
	
}


- (void) dealloc
{
	
	[_mPAdBannerView release];
	[_mPAdRectView release];
	[_mPInterstitialAdController release];
	
	[super dealloc];
	
}


- (BOOL) start
{
	
	static BOOL synchronized = NO;
	
	if ( ! synchronized ) {
		
		BOOL loadResult = [self loadNeocortexSettings];
		
		if ( loadResult ) {
			
			NSLog(@"[Neocortex] START register Neocortex variables");
			
			[[MPAdConversionTracker sharedConversionTracker] reportApplicationOpenForApplicationID:itunesAppID];
			
			[Flurry startSession:flurrySettings.appID];
			
//			[RevMobAds startSessionWithAppID:revmobSettings.appID];
            
//			[RevMobAds loadFullscreenAd];
//            [[[RevMobAds session] fullscreen] loadAd];
			
			[TapjoyConnect requestTapjoyConnect:tapjoySettings.appID secretKey:tapjoySettings.appSecretKey];
			
			Chartboost *chartboost = [Chartboost sharedChartboost];
			chartboost.appId = chartboostSettings.appID;
			chartboost.appSignature = chartboostSettings.appSignature;
          
			chartboost.delegate = self;
			[chartboost startSession];
			[chartboost cacheMoreApps];
			[chartboost cacheInterstitial];
			
			NSLog(@"[Neocortex] END register Neocortex variables");
			
			synchronized = YES;
			
		}
		
	}
	
	return synchronized;
	
}


- (BOOL) loadNeocortexSettings
{

	NSString* neocortexSettingsURL = self.neocortexSettingsURL;
	
	NSDictionary* neocortexSettingsDic = [self getDictionaryWithUrlStr:neocortexSettingsURL];
	
	if (!neocortexSettingsDic) {
		
		NSLog(@"[Neocortex] Load Neocortex settings file: FAIL");
		
		return NO;
		
	}
	
	NSLog(@"[Neocortex] Neocortex settings Dic = %@", neocortexSettingsDic);
	
	
	NSDictionary *constantsDic = (NSDictionary*)[neocortexSettingsDic objectForKey:@"Constants"];
	NSDictionary *setupDic = (NSDictionary*)[neocortexSettingsDic objectForKey:@"Setup"];
	
	//Constants
	
	NSDictionary *chartboostDic = (NSDictionary*)[constantsDic objectForKey:@"Chartboost"];
//	NSDictionary *revmobDic = (NSDictionary*)[constantsDic objectForKey:@"Revmob"];
	NSDictionary *mopubDic = (NSDictionary*)[constantsDic objectForKey:@"Mopub"];
	//NSDictionary *mobclixDic = (NSDictionary*)[constantsDic objectForKey:@"Mobclix"];
	//NSDictionary *googleAdSenseDic = (NSDictionary*)[constantsDic objectForKey:@"GoogleAdSense"];
	//NSDictionary *playhavenDic = (NSDictionary*)[constantsDic objectForKey:@"Playhaven"];
	NSDictionary *tapjoyDic = (NSDictionary*)[constantsDic objectForKey:@"Tapjoy"];
	NSDictionary *flurryDic = (NSDictionary*)[constantsDic objectForKey:@"Flurry"];
	NSDictionary *customPopupDic = (NSDictionary*)[constantsDic objectForKey:@"CustomPopup"];
	
	//Setup
	
	NSDictionary *nagScreenDic = (NSDictionary*)[setupDic objectForKey:@"NagScreen"];
	NSDictionary *nagScreenOnBecomeActiveDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnBecomeActive"];
	NSDictionary *nagScreenOnMainMenuDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnMainMenu"];
	NSDictionary *nagScreenOnLevelsMenuDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnLevelsMenu"];
	NSDictionary *nagScreenOnPauseMenuDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnPauseMenu"];
	NSDictionary *nagScreenOnPlayingDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnPlaying"];
	NSDictionary *nagScreenOnGameoverDic = (NSDictionary*)[nagScreenDic objectForKey:@"OnGameover"];
	
	NSDictionary *bannerDic = (NSDictionary*)[setupDic objectForKey:@"Banner"];
	NSDictionary *bannerOnBecomeActiveDic = (NSDictionary*)[bannerDic objectForKey:@"OnBecomeActive"];
	NSDictionary *bannerOnMainMenuDic = (NSDictionary*)[bannerDic objectForKey:@"OnMainMenu"];
	NSDictionary *bannerOnLevelsMenuDic = (NSDictionary*)[bannerDic objectForKey:@"OnLevelsMenu"];
	NSDictionary *bannerOnPauseMenuDic = (NSDictionary*)[bannerDic objectForKey:@"OnPauseMenu"];
	NSDictionary *bannerOnPlayingDic = (NSDictionary*)[bannerDic objectForKey:@"OnPlaying"];
	NSDictionary *bannerOnGameoverDic = (NSDictionary*)[bannerDic objectForKey:@"OnGameover"];
	
	NSDictionary *moreScreenDic = [setupDic objectForKey:@"MoreScreen"];
	
	
	/*
	 * Load Settings
	 */
	
	
	itunesAppID = [[constantsDic objectForKey:@"itunesAppID"] copy];
	
	
	//Chartboost Settings
	
	chartboostSettings.appID = [[chartboostDic objectForKey:@"appID"] copy];
	chartboostSettings.appSignature = [[chartboostDic objectForKey:@"appSignature"] copy];
	NSLog(@"chartboostSettings.appID = %@", chartboostSettings.appID);
	NSLog(@"chartboostSettings.appSignature = %@", chartboostSettings.appSignature);
	
	
	//Revmob Settings
	
//	revmobSettings.appID = [[revmobDic objectForKey:@"appID"] copy];
//	NSLog(@"revmobSettings.appID = %@", revmobSettings.appID);
	
	
	//Mopub Settings
	
	mopubSettings.adUnitIDBanner = [[mopubDic objectForKey:@"adUnitIDBanner"] copy];
	mopubSettings.adUnitIDFullscreen = [[mopubDic objectForKey:@"adUnitIDFullscreen"] copy];
	mopubSettings.adUnitIDMedium = [[mopubDic objectForKey:@"adUnitIDMedium"] copy];
	NSLog(@"mopubSettings.adUnitID = %@", mopubSettings.adUnitIDBanner);
	NSLog(@"mopubSettings.adUnitIDFullscreen = %@", mopubSettings.adUnitIDFullscreen);
	NSLog(@"mopubSettings.adUnitIDMedium = %@", mopubSettings.adUnitIDMedium);
	
	
	//Tapjoy Settings
	
	tapjoySettings.appID = [[tapjoyDic objectForKey:@"appID"] copy];
	tapjoySettings.appSecretKey = [[tapjoyDic objectForKey:@"appSecretKey"] copy];
	NSLog(@"tapjoySettings.appID = %@", tapjoySettings.appID);
	NSLog(@"tapjoySettings.appSecretKey = %@", tapjoySettings.appSecretKey);
	
	
	//Flurry Settings
	
	flurrySettings.appID = @"PQ59W6FHSP7RRFQ7FD9K"; //[[flurryDic objectForKey:@"appID"] copy];
	NSLog(@"flurrySettings.appID = %@", flurrySettings.appID);
	
	
	//Custom Popup Settings
	
	customPopupSettings.title = [[customPopupDic objectForKey:@"title"] copy];
	customPopupSettings.message = [[customPopupDic objectForKey:@"message"] copy];
	customPopupSettings.cancelButtonText = [[customPopupDic objectForKey:@"cancelButtonText"] copy];
	customPopupSettings.okButtonText = [[customPopupDic objectForKey:@"okButtonText"] copy];
	customPopupSettings.urls = [[customPopupDic objectForKey:@"urls"] copy];
	NSLog(@"customPopupSettings.title = %@", customPopupSettings.title);
	NSLog(@"customPopupSettings.message = %@", customPopupSettings.message);
	NSLog(@"customPopupSettings.cancelButtonText = %@", customPopupSettings.cancelButtonText);
	NSLog(@"customPopupSettings.okButtonText = %@", customPopupSettings.okButtonText);
	NSLog(@"customPopupSettings.urls = %@", customPopupSettings.urls);
	
	
	//More screen Settings
	
	[self fillAdItemSettings:&moreScreenSettings fromDic:moreScreenDic];
	//moreScreenSettings.enabled = [[moreScreenDic objectForKey:@"enabled"] boolValue];
	//moreScreenSettings.type = [[moreScreenDic objectForKey:@"chartboost"] copy];
	//NSLog(@"moreScreenSettings.enabled = %d", moreScreenSettings.enabled);
	//NSLog(@"moreScreenSettings.type = %@", moreScreenSettings.type);
	
	
	//Load Nag Screens Settings
	
	[self fillAdItemSettings:&nagScreenOnBecomeActiveSettings fromDic:nagScreenOnBecomeActiveDic];
	[self fillAdItemSettings:&nagScreenOnMainMenuSettings fromDic:nagScreenOnMainMenuDic];
	[self fillAdItemSettings:&nagScreenOnLevelsMenuSettings fromDic:nagScreenOnLevelsMenuDic];
	[self fillAdItemSettings:&nagScreenOnPauseMenuSettings fromDic:nagScreenOnPauseMenuDic];
	[self fillAdItemSettings:&nagScreenOnPlayingSettings fromDic:nagScreenOnPlayingDic];
	[self fillAdItemSettings:&nagScreenOnGameoverSettings fromDic:nagScreenOnGameoverDic];
	
	
	//Load Banner Settings
	
	[self fillAdItemSettings:&bannerOnBecomeActiveSettings fromDic:bannerOnBecomeActiveDic];
	[self fillAdItemSettings:&bannerOnMainMenuSettings fromDic:bannerOnMainMenuDic];
	[self fillAdItemSettings:&bannerOnLevelsMenuSettings fromDic:bannerOnLevelsMenuDic];
	[self fillAdItemSettings:&bannerOnPauseMenuSettings fromDic:bannerOnPauseMenuDic];
	[self fillAdItemSettings:&bannerOnPlayingSettings fromDic:bannerOnPlayingDic];
	[self fillAdItemSettings:&bannerOnGameoverSettings fromDic:bannerOnGameoverDic];
	
	
	return YES;
	
}


- (void) fillAdItemSettings:(AdItemSettings *)adItemSettings fromDic:(NSDictionary *)sourceDic
{
	
	adItemSettings->showAfterCount = [[sourceDic objectForKey:@"showAfterCount"] intValue];
	
	adItemSettings->pool = [[NSMutableArray alloc] init];
	
	int probabilityCount;
	
	for ( NSString *key in [sourceDic keyEnumerator] ) {
		
		if ( [key isEqualToString:@"showAfterCount"] )
			continue;
		
		//NSLog(@"%@ ---------------------------------> %@", key, [sourceDic objectForKey:key]);
		
		probabilityCount = [[sourceDic objectForKey:key] intValue];
		for ( int i = 0; i < probabilityCount; i ++ ) {
			[adItemSettings->pool addObject:key];
		}
		
	}
	
	NSLog(@"[adItemSettings.showAfterCount] = %d", adItemSettings->showAfterCount);
	NSLog(@"[adItemSettings.pool]  %@", adItemSettings->pool);
	
}


- (void) onBecomeActive
{
	if (![self areAdsPurchased])
    {
    NSLog(@"[Neocortex] Event onBecomeActive");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnBecomeActiveSettings location:@"becomeactive"];
	//[self showAdItem:&bannerOnBecomeActiveSettings location:@"becomeactive"];
	}
}


- (void) onLevelsMenu
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] Event onLevelsMenu");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnLevelsMenuSettings location:@"levelsmenu"];
	//[self showAdItem:&bannerOnLevelsMenuSettings location:@"levelsmenu"];
    }
}


- (void) onMainMenu
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] Event onMainMenu");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnMainMenuSettings location:@"mainmenu"];
	//[self showAdItem:&bannerOnMainMenuSettings location:@"mainmenu"];
	}
}


- (void) onPauseMenu
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] Event onPauseMenu");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnPauseMenuSettings location:@"pausemenu"];
	//[self showAdItem:&bannerOnPauseMenuSettings location:@"pausemenu"];
	}
}


- (void) onPlaying
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] Event onPlaying");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnPlayingSettings location:@"playing"];
	//[self showAdItem:&bannerOnPlayingSettings location:@"playing"];
	}
}


- (void) onGameover
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] Event onGameover");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&nagScreenOnGameoverSettings location:@"gameover"];
	//[self showAdItem:&bannerOnGameoverSettings location:@"gameover"];
	}
}


- (void) showAdItem:(AdItemSettings *)adItemSettings location:(NSString *)location
{
	
	if ( adItemSettings->showAfterCount <= 0 || ! adItemSettings->pool || adItemSettings->pool.count <= 0 ) {
		return;
	}
	
	adItemSettings->counter ++;
	
	NSLog(@"adItemSettings->counter = %d", adItemSettings->counter);
	
	if (adItemSettings->counter >= adItemSettings->showAfterCount) {
		
		adItemSettings->counter = 0;
		
		NSString *adItemKey = [adItemSettings->pool objectAtIndex: (rand() % adItemSettings->pool.count)];
		
		NSLog(@"[Neocortex] Call showAdItem: of Type ================== %@", adItemKey);
		
		
		if ( [adItemKey isEqualToString:@"chartboost"] ) {
			
			Chartboost *chartboost = [Chartboost sharedChartboost];
			[chartboost showInterstitial];
			[chartboost cacheInterstitial];
			
		} /*else if ( [adItemKey isEqualToString:@"revmobPopup"] ) {
			
//			[RevMobAds showPopup];
            [[RevMobAds session] showPopup];
			
		} else if ( [adItemKey isEqualToString:@"revmobFullscreen"] ) {
			
//			[RevMobAds showFullscreenAd];
            [[RevMobAds session] showFullscreen];
			
		} */
        else if ( [adItemKey isEqualToString:@"mopubFullscreen"] ) {
			
			// Instantiate the interstitial using the class convenience method.
			
			_mPInterstitialAdController = [MPInterstitialAdController interstitialAdControllerForAdUnitId:mopubSettings.adUnitIDFullscreen];
			_mPInterstitialAdController.delegate = self;
			[_mPInterstitialAdController loadAd];
			
		} else if ( [adItemKey isEqualToString:@"mopubMedium"] ) {
			
			[self removeRectAd];
			
			_mPAdRectView = [[MPAdView alloc] initWithAdUnitId:mopubSettings.adUnitIDMedium size:MOPUB_MEDIUM_RECT_SIZE];
			_mPAdRectView.delegate = self;
			[_mPAdRectView loadAd];
			//[_mPAdRectView release];
			
		} else if ( [adItemKey isEqualToString:@"customPopup"] ) {
			
			UIAlertView* customPopupAlertView = [[UIAlertView alloc]
												 initWithTitle:(customPopupSettings.title.length > 0 ? customPopupSettings.title : nil)
												 message:(customPopupSettings.message.length > 0 ? customPopupSettings.message : nil)
												 delegate:self
												 cancelButtonTitle:(customPopupSettings.cancelButtonText.length > 0 ? customPopupSettings.cancelButtonText : nil)
												 otherButtonTitles:(customPopupSettings.okButtonText.length > 0 ? customPopupSettings.okButtonText : nil)
												 , nil];
			
			customPopupAlertView.tag = 100;
			[customPopupAlertView show];
			[customPopupAlertView release];
			
		}
        /*
        else if ( [adItemKey isEqualToString:@"revmobBanner"] ) {
			
			[self removeBannerAd];
			
//			[RevMobAds showBannerAd];
            [[RevMobAds session] showBanner];
			
		} 
        */
        else if ( [adItemKey isEqualToString:@"mopubBanner"] ) {
			
			[self removeBannerAd];
			
			_mPAdBannerView = [[MPAdView alloc] initWithAdUnitId:mopubSettings.adUnitIDBanner size:MOPUB_BANNER_SIZE];
			_mPAdBannerView.delegate = self;
			[_mPAdBannerView loadAd];
			//[_mPAdBannerView release];
			
		}
		
	}
	
}


- (BOOL) isMoreScreenEnabled
{
	
	NSLog(@"[Neocortex] isMoreScreenEnabled");
	
	return [self start] && moreScreenSettings.pool && moreScreenSettings.pool.count > 0;
	
}


- (void) showMoreScreen
{
	
	NSLog(@"[Neocortex] showMoreScreen");
	
	if ( ! [self start] || ! moreScreenSettings.pool || moreScreenSettings.pool.count <= 0 ) {
		return;
	}
	
	NSString *moreScreenItemKey = [moreScreenSettings.pool objectAtIndex: (rand() % moreScreenSettings.pool.count)];
	
	NSLog(@"[Neocortex] Call showMoreScreen: of Type ================== %@", moreScreenItemKey);
	
	
	if ( [moreScreenItemKey isEqualToString:@"chartboost"] ) {
		
		Chartboost *chartboost = [Chartboost sharedChartboost];
		[chartboost showMoreApps];
		[chartboost cacheMoreApps];
		
	} /*else if ( [moreScreenItemKey isEqualToString:@"revmob"] ) {
		
//		[RevMobAds openAdLink];
        [[[RevMobAds session] adLink] openLink];
		
	}
       */
	
}


- (void) showBannerAd
{
	
	if (![self areAdsPurchased])
    {
        NSLog(@"[Neocortex] showBannerAd");
	
	if ( ! [self start] ) {
		return;
	}
	
	[self showAdItem:&bannerOnBecomeActiveSettings location:nil];
	}
}


- (void) removeBannerAd
{
	if ( _mPAdBannerView ) {
		[_mPAdBannerView removeFromSuperview];
		_mPAdBannerView = nil;
	}
//	[RevMobAds deactivateBannerAd];
//    [[RevMobAds session] hideBanner];
}


- (void) removeRectAd
{
	if ( _mPAdRectView ) {
		[_mPAdRectView removeFromSuperview];
		_mPAdRectView = nil;
	}
}


- (NSString*) neocortexSettingsURL
{
	
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSDictionary* infoDic = [NSDictionary dictionaryWithContentsOfFile:[[mainBundle bundlePath] stringByAppendingPathComponent:@"neocortex-info.plist"]];
	
	if ( ! infoDic ) {
		
		NSLog(@"[Neocortex] Get info dic file: FAIL");
		
		return nil;
		
	}
	
	NSLog(@"[Neocortex] info Dic = %@", infoDic);
	
	return [infoDic objectForKey:@"neocortexURL"];
	
}


- (NSDictionary*) getDictionaryWithUrlStr:(NSString*)urlStr
{
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSError *error = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
	
	NSURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSDictionary *dic = nil;
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL);
	
	if ([(id)plist isKindOfClass:[NSDictionary class]]) {
		dic = [(NSDictionary *)plist autorelease];
	} else {
		// clean up ref
		if (plist) {
			CFRelease(plist);
		}
		dic = nil;
	}
	
	return dic;
	
}


#pragma mark UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex == 0) {
		
		NSLog(@"AlertView tag %d Cancel Button Clicked", alertView.tag);
		
	} else {
		
		NSLog(@"AlertView tag %d Ok Button Clicked", alertView.tag);
		
		if ( alertView.tag == 100 ) {
			
			if ( customPopupSettings.urls.count > 0 ) {
				NSString *selectedUrl = [customPopupSettings.urls objectAtIndex: (rand() % customPopupSettings.urls.count)];
				NSLog(@"selectedUrl = %@", selectedUrl);
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedUrl]];
			}
			
		}
		
	}
	
}



#pragma mark ChartboostDelegate Methods

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(NSString *)location
{
	NSLog(@"[Neocortex] Call didFailToLoadInterstitial");
}

// Called before requesting an interestitial from the back-end
- (BOOL)shouldRequestInterstitial:(NSString *)location
{
	return YES;
}

// Called when an interstitial has been received, before it is presented on screen
// Return NO if showing an interstitial is currently innapropriate, for example if the user has entered the main game mode.
- (BOOL)shouldDisplayInterstitial:(NSString *)location
{
	return YES;
}

// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(NSString *)location
{
}
 
// Called when the user dismisses the interstitial
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissInterstitial:(NSString *)location
{
}

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location
{
}

// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(NSString *)location
{
}

// Called before requesting the more apps view from the back-end
// Return NO if when showing the loading view is not the desired user experience.
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
	return YES;
}

// Called when an more apps page has been received, before it is presented on screen
// Return NO if showing the more apps page is currently innapropriate
- (BOOL)shouldDisplayMoreApps
{
	return YES;
}

// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{
}

// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps
{
}

// Called when the user dismisses the more apps view
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissMoreApps
{
}

// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{
}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{
}

// Whether Chartboost should show ads in the first session
// Defaults to YES
- (BOOL)shouldRequestInterstitialsInFirstSession
{
	return YES;
}



#pragma mark MPAdViewDelegate Methods

- (UIViewController *)viewControllerForPresentingModalView
{
	return self.adViewController;
}

//These callbacks notify you regarding whether the ad view (un)successfully loaded an ad.
- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
	if ( self.adViewController ) {
		
		NSLog(@"[Neocortex] adViewDidLoadAd : Creative Size ================== %@", NSStringFromCGSize(view.adContentViewSize));
		
		view.frame = CGRectMake(0, 0, view.adContentViewSize.width, view.adContentViewSize.height);
		view.center = CGPointMake(self.adViewController.view.frame.size.height/2.0, self.adViewController.view.frame.size.width - view.adContentViewSize.height/2.0);
		
		[self.adViewController.view addSubview:view];
		[self.adViewController.view bringSubviewToFront:view];
		
	}
}

//These callbacks are triggered when the ad view is about to present/dismiss a modal view. If your application may be disrupted by these actions, you can use these notifications to handle them (for example, a game might need to pause/unpause).
- (void)willPresentModalViewForAd:(MPAdView *)view
{
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
}

//This callback is triggered when the ad view has retrieved ad parameters (headers) from the MoPub server. See MPInterstitialAdController for an example of how this should be used.
- (void)adView:(MPAdView *)view didReceiveResponseParams:(NSDictionary *)params
{
}

//This method is called when a mopub://close link is activated. Your implementation of this method should remove the ad view from the screen (see MPInterstitialAdController for an example).
- (void)adViewShouldClose:(MPAdView *)view
{
}



#pragma mark MPInterstitialAdControllerDelegate Methods

//These callbacks notify you when the interstitial (un)successfully loads its ad content. You may implement these if you want to prefetch interstitial ads.
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
	[interstitial showFromViewController:self.adViewController];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
	NSLog(@"Interstitial did fail to return ad %@",interstitial);
}

//This callback notifies you that the interstitial is about to appear. This is a good time to handle potential app interruptions (e.g. pause a game).
- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
	NSLog(@"Interstitial will appear: %@",interstitial);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial
{
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial
{
	//[self.adViewController dismissModalViewControllerAnimated:YES];
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial
{
}

//Interstitial ads from certain networks (e.g. iAd) may expire their content at any time, regardless of whether the content is currently on-screen. This callback notifies you when the currently-loaded interstitial has expired and is no longer eligible for display. If the ad was on-screen when it expired, you can expect that the ad will already have been dismissed by the time this callback was fired. Your implementation may include a call to -loadAd to fetch a new ad, if desired.
- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial
{
	//Reload the interstitial ad, if desired.
}

- (bool) areAdsPurchased
{
    return NO;
}

@end
