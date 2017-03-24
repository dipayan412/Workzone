//
//  RA_AppDelegate.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RA_AppDelegate.h"
#import "RA_MessageBoard.h"

@implementation RA_AppDelegate

@synthesize taxAmount = _taxAmount;
@synthesize currency = _currency;
@synthesize taxCurrencyRequest;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:GoogleMapAPIKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray * langs = [NSLocale preferredLanguages];
    NSString * lang = langs.count ? [langs objectAtIndex: 0] : nil;
    
    if([lang isEqualToString: @"it"])
    {
        [RA_UserDefaultsManager setLanguageToItalian:YES];
        [RA_UserDefaultsManager setAppLanuage:@"it"];
    }
    
    tabController = [[UITabBarController alloc] init];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    
    //initializes home view controller and home tab item for the tabBarController
    homeVC = [[RA_HomeViewController alloc] initWithNibName:@"RA_HomeViewController" bundle:nil];
    homeVC.title = kRestaurantTitle;
    homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.navigationBar.translucent = NO;
    homeNC.tabBarItem.image = kHomeButtonSelected;
    homeNC.tabBarItem.title = AMLocalizedString(kHome, nil);
    homeNC.tabBarItem.selectedImage = kHomeButtonSelected;
    
    //initializes menu view controller and home tab item for the tabBarController
    menuVC = [[RA_CategoryViewController alloc] initWithNibName:@"RA_CategoryViewController" bundle:nil];
    menuVC.title = AMLocalizedString(kMenuTitle, nil);
    menuNC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    menuNC.navigationBar.translucent = NO;
    menuNC.tabBarItem.image = kMenuButtonDeselected;
    menuNC.tabBarItem.title = AMLocalizedString(kMenu, nil);
    menuNC.tabBarItem.selectedImage = kMenuButtonSelected;
    
    //initializes reservation view controller and home tab item for the tabBarController
    reservationVC = [[RA_ReservationParentViewController alloc] initWithNibName:@"RA_ReservationParentViewController" bundle:nil];
    reservationVC.title = AMLocalizedString(kReservationTitle, nil);
    reservationNC = [[UINavigationController alloc] initWithRootViewController:reservationVC];
    reservationNC.navigationBar.translucent = NO;
    reservationNC.tabBarItem.image = kReservationButtonDeselected;
    reservationNC.tabBarItem.title = AMLocalizedString(kReservation, nil);
    reservationNC.tabBarItem.selectedImage = kReservationButtonSelected;
    
    //initializes findUS view controller and home tab item for the tabBarController
    findUsVC = [[RA_FindUsViewController alloc] initWithNibName:@"RA_FindUsViewController" bundle:nil];
    findUsVC.title = AMLocalizedString(kFindUsTitle, nil);
    findUsNC = [[UINavigationController alloc] initWithRootViewController:findUsVC];
    findUsNC.navigationBar.translucent = NO;
    findUsNC.tabBarItem.image = kFindUsButtonDeselected;
    findUsNC.tabBarItem.title = AMLocalizedString(kFindUs, nil);
    findUsNC.tabBarItem.selectedImage = kFindUsButtonSelected;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        homeNC.tabBarItem.image = [kHomeButtonDeselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        menuNC.tabBarItem.image = [kMenuButtonDeselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        reservationNC.tabBarItem.image = [kReservationButtonDeselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        findUsNC.tabBarItem.image = [kFindUsButtonDeselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        homeNC.tabBarItem.image = kHomeButtonDeselected;
        menuNC.tabBarItem.image = kMenuButtonDeselected;
        reservationNC.tabBarItem.image = kReservationButtonDeselected;
        findUsNC.tabBarItem.image = kFindUsButtonDeselected;
    }
    
    //populate tab controller with the tab bar items
    tabController.viewControllers = [NSArray arrayWithObjects:homeNC, menuNC, reservationNC, findUsNC, nil];
    tabController.delegate = self;
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UINavigationBar appearance] setBarTintColor:kTabBarColor];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:kTabBarColor];
    }
    
    UIImage *tabBackground = nil;
    if([UIScreen mainScreen].bounds.size.height <= 568)
    {
        tabBackground = [kTabBarBackgroundImageiPhone resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
        {
            // Retina display
            tabBackground = [kTabBarBackgroundImageiPadRetina resizableImageWithCapInsets:UIEdgeInsetsMake(0, -135, 0, 0)];
        }
        else
        {
            tabBackground = [kTabBarBackgroundImageiPhone resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"transparentShadow.png"]];
    tabController.tabBar.backgroundColor = [UIColor clearColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
    
    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];
    
    [self fetchTaxCurrency];
    
    if([RA_UserDefaultsManager getOrderItemsArray].count > 0)
    {
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kConfirm", nil) message:AMLocalizedString(@"kRemoveOrder", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"kNo", nil) otherButtonTitles:AMLocalizedString(@"kYes", nil), nil];
        [alert show];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    if(launchOptions!=nil)
//    {
//        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
//        NSLog(@"%@",msg);
//        [self createAlert:msg];
//    }
    
    return YES;
}

-(void)changeLanguages
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    
    homeVC.title = kRestaurantTitle;
    homeNC.tabBarItem.title = AMLocalizedString(kHome, nil);
    
    menuVC.title = AMLocalizedString(kMenuTitle, nil);
    menuNC.tabBarItem.title = AMLocalizedString(kMenu, nil);
    
    reservationVC.title = AMLocalizedString(kReservationTitle, nil);
    reservationNC.tabBarItem.title = AMLocalizedString(kReservation, nil);
    
    findUsVC.title = AMLocalizedString(kFindUsTitle, nil);
    findUsNC.tabBarItem.title = AMLocalizedString(kFindUs, nil);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return;
    }
    else
    {
        [RA_UserDefaultsManager removeAllItems];
    }
}

/**
 * Method name: fetchTaxCurrency
 * Description: start request to get the currency of the tax
 * Parameters: none
 */

-(void)fetchTaxCurrency
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@?accesskey=%@", TaxCurrencyAPI,AccessKey];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    taxCurrencyRequest = [ASIHTTPRequest requestWithURL:url];
    self.taxCurrencyRequest.delegate = self;
    
    [self.taxCurrencyRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == self.taxCurrencyRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:taxCurrencyRequest.responseData options:kNilOptions error:&error];
        if (error)
        {
            LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kParseResponse", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSArray *responseArray = [responseObject objectForKey:@"data"];
        if(responseArray.count == 2)
        {
            NSDictionary *dic = [[responseArray objectAtIndex:0] objectForKey:@"tax_n_currency"];
            NSString *taxValue = [dic objectForKey:@"Value"];
            _taxAmount = taxValue.floatValue;
            
            NSDictionary *dic2 = [[responseArray objectAtIndex:1] objectForKey:@"tax_n_currency"];
            _currency = [dic2 objectForKey:@"Value"];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"kError", nil) message:AMLocalizedString(@"kConnectServer", nil) delegate:Nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles: nil];
    [alert show];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex)
    {
        case 0:
            [homeVC.navigationController popToRootViewControllerAnimated:YES];
            break;
          
        case 1:
            [menuVC.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case 2:
            [reservationVC.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case 3:
            [findUsVC.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //Convert deviceToken to String Type

    const char* data = deviceToken.bytes;
    
    NSMutableString* tokenString = [NSMutableString string];
    
    for (int i = 0; i < deviceToken.length; i++)
    {
        [tokenString appendFormat:@"%02.2hhX", data[i]];
    }
    
    NSLog(@"deviceToken String: %@", tokenString);
    
    [RA_UserDefaultsManager setDeviceToken:tokenString];
    
    if ([[RA_MessageBoard instance] createApplicationEndpoint])
    {
        NSLog(@"Device Endpoint has been created successfully.");
    }
    else
    {
        NSLog(@"Failed to create device endpoint");
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to register with error : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    NSString *msg = [NSString stringWithFormat:@"%@", userInfo];
    NSLog(@"%@",msg);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
