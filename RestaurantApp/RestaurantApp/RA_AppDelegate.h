//
//  RA_AppDelegate.h
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RA_RestaurantViewController.h"
#import "RA_NewsViewController.h"
#import "RA_TakeAwayViewController.h"
#import "RA_HomeViewController.h"
#import "RA_ItemViewController.h"
#import "RA_FindUsViewController.h"
#import "RA_ReservationParentViewController.h"
#import "RA_CategoryViewController.h"
//#import <GoogleMaps/GoogleMaps.h>
#import "RA_MenuObject.h"

@interface RA_AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate>
{
    UINavigationController *navigationController;

    RA_RestaurantViewController *restaurantVC;
    RA_CategoryViewController *menuVC;
    RA_NewsViewController *newsVC;
    RA_TakeAwayViewController *takeAwayVC;
    RA_ReservationParentViewController *reservationVC;
    RA_HomeViewController *homeVC;
    RA_FindUsViewController *findUsVC;
    
    UINavigationController *homeNC;
    UINavigationController *menuNC;
    UINavigationController *reservationNC;
    UINavigationController *findUsNC;
    
    UITabBarController *tabController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) float taxAmount;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) ASIHTTPRequest *taxCurrencyRequest;

-(void)changeLanguages;

@end
