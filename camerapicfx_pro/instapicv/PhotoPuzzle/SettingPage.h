//
//  SettingPage.h
//  PhotoPuzzle
//
//  Created by muhammad sami ather on 6/11/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>
//#import "AdWhirlView.h"
//#import "Chartboost.h"
//#import "AdWhirlDelegateProtocol.h"
//#import "ALTabBarView.h"
//#import "PlayHavenSDK.h"
//#import "ALSharedData.h"
//#import "ALInterstitialAd.h"
@interface SettingPage : UIViewController <UITabBarDelegate/*,AdWhirlDelegate*//*,ALTabBarDelegate*//*,ChartboostDelegate*/>
{
    MBProgressHUD *_hud;
    NSMutableArray *storename;
    int tagId;
    NSString *Email;
//    ALTabBarView * customizedTabBar;
}
@property (retain, nonatomic)NSString *Email;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
- (IBAction)moreButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic) IBOutlet UISwitch *bottomAds;
@property (retain, nonatomic) IBOutlet UISwitch *topAds;

@property (retain, nonatomic) IBOutlet UISwitch *sound;
@property (retain) MBProgressHUD *hud;
//////////////////////// New Sher
//@property (nonatomic, retain) ALTabBarView * customizedTabBar;
@property (nonatomic, retain) IBOutlet UIButton * soundSwitch;
//@property (nonatomic, retain) IBOutlet UIButton * topAdSwitch;
//@property (nonatomic, retain) IBOutlet UIButton * bottomAdSwitch;

@property (nonatomic, assign) BOOL soundIsOn;

-(IBAction)soundButton:(id)sender;
//-(IBAction)topAdButton:(id)sender;
//-(IBAction)bottomAdButton:(id)sender;




- (IBAction)soundSwitch:(id)sender;
//- (IBAction)topAdsSwitch:(id)sender;
//- (IBAction)bottomAdsSwitch:(id)sender;
-(void)loadData;
-(void)updateData;
@end
