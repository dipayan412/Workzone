//
//  LoginPage.h
//  TestApp
//
//  Created by muhammad sami ather on 6/13/12.
//  Copyright (c) 2012 swengg-co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

//#import "FacebookController.h"
//#import "FacebookShareDelegate.h"

//#import "FlurryAppCircle.h"
//#import "FlurryAdDelegate.h"

#import "JREngage.h"
//#import "ChartBoost.h"

#import "singletonClass.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "PlayHavenSDK.h"
#import "ALInterstitialAd.h"
#import "ALSharedData.h"
//#import <RevMobAds/RevMobAdsDelegate.h>

@interface LoginPage : UIViewController <UITabBarDelegate,AdWhirlDelegate,JREngageDelegate/*,ChartboostDelegate*/,UITextFieldDelegate,AVAudioPlayerDelegate,PHPublisherContentRequestDelegate/*,RevMobAdsDelegate*/>//,FacebookShareDelegate>
{
    UIImageView *mimageview;
    BOOL configFetched;
    JREngage *jrEngage;
    int reedittextfield;
    CGFloat animatedDistance;
    BOOL signUp;
    BOOL testAds;
}
@property (retain, nonatomic) IBOutlet UITextField *forgetEmail;
@property (retain, nonatomic) IBOutlet UIView *forgetView;
@property (retain, nonatomic) IBOutlet UITextField *rePasswordSignUp;
@property (retain, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (retain, nonatomic) IBOutlet UITextField *userNameSignUp;
@property (retain, nonatomic) IBOutlet UITextField *passwordsignIn;
@property (retain, nonatomic) IBOutlet UITextField *userNameSignIn;
@property (retain, nonatomic) IBOutlet UIView *signInView;
@property (retain, nonatomic) IBOutlet UIView *signUpView;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *twitterButton;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *toolbarView;

@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UIButton *okpressed;
@property (retain, nonatomic) IBOutlet UIButton *loginpage;
@property (retain, nonatomic) IBOutlet UIImageView *mimageview;

@property (retain, nonatomic) IBOutlet UIButton *signuplogin;
@property (retain, nonatomic) IBOutlet UIButton *loginin;

//////////

@property (nonatomic, assign) BOOL isSignIn;

- (IBAction)signuppressed:(id)sender;
- (IBAction)loginpressed:(id)sender;
- (IBAction)OkButton:(id)sender;
- (IBAction)signInViewButton:(id)sender;
- (IBAction)twittersignInButton:(id)sender;
- (IBAction)facebooksignInButton:(id)sender;
- (IBAction)signUpViewButton:(id)sender;
- (IBAction)twitterSignUpButton:(id)sender;
- (IBAction)facebookSignUpButton:(id)sender;
- (IBAction)forgetPasswordPressed:(id)sender;
- (IBAction)forgetSendPressed:(id)sender;
- (IBAction)cancelForgetPressed:(id)sender;

- (void)loadPlayHaven;
@end
