//
//  AppDelegate.h
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "DrawerViewController.h"
#import "PromoScanner.h"
#import "PromoObject.h"

@protocol AppDelegateProtocol <NSObject>

-(void)cameBackToApp;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, PromoScannerDelegate, UIAlertViewDelegate>
{
    DrawerViewController *drawerVC;
    PromoScanner *promoScanner;
    UINavigationController *navCon;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isBackGroundModeOn;
@property (nonatomic, retain) id <AppDelegateProtocol> delegate;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
