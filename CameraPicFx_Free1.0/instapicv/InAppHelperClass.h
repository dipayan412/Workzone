//
//  InAppHelperClass.h
//  PhotoPuzzle
//
//  Created by World on 10/30/13.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>
#import "AdWhirlView.h"
//#import "Chartboost.h"
#import "AdWhirlDelegateProtocol.h"
#import "ALTabBarView.h"
#import "PlayHavenSDK.h"
#import "ALSharedData.h"
#import "ALInterstitialAd.h"

@interface InAppHelperClass : NSObject
{
    MBProgressHUD *_hud;
    NSMutableArray *storename;
    int tagId;
    NSString *Email;
}

@property (retain, nonatomic)NSString *Email;
@property (retain) MBProgressHUD *hud;


+(id)getInstance;
-(void)triggerInApp;

@end
