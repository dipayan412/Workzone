//
//  AppDelegate.m
//  iOS Prototype
//
//  Created by World on 2/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "HomeViewController.h"
#import "SignInSignUpViewController.h"
#import "DrawerViewController.h"
#import "SettingsViewController.h"
#import "HomeV2ViewController.h"
#import "HomeV3ViewController.h"
#import "PromoObject.h"
#import "LoginViewController.h"
#import "LoginV2ViewController.h"
#import "GAI.h"

@implementation AppDelegate

@synthesize isBackGroundModeOn;
@synthesize delegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-48531176-2"];
    
    
    NSDictionary *navBarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kNavigationBarTextColor,
                                      NSForegroundColorAttributeName,
                                      nil];
    
    [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
    [[UINavigationBar appearance] setTintColor:kNavigationBarTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes: navBarAttributes];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    promoScanner = [PromoScanner getInstance];
    promoScanner.delegate = self;
//    if ([UserDefaultsManager isKeepMeSignedInOn] && ![[UserDefaultsManager sessionToken] isEqualToString:@""])
//    {
//        HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//        navCon = [[UINavigationController alloc] initWithRootViewController:vc];
//    }
//    else
//    {
//        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        navCon = [[UINavigationController alloc] initWithRootViewController:vc];
//    }
//    SignInSignUpViewController *vc = [[SignInSignUpViewController alloc] initWithNibName:@"SignInSignUpViewController" bundle:nil];
    LoginV2ViewController *vc = [[LoginV2ViewController alloc] initWithNibName:@"LoginV2ViewController" bundle:nil];
//    HomeV3ViewController *vc = [[HomeV3ViewController alloc] initWithNibName:@"HomeV3ViewController" bundle:nil];
    navCon = [[UINavigationController alloc] initWithRootViewController:vc];
    
//    navCon.navigationBarHidden = YES;
//    HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
//    drawerVC = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
//    
//    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//    vc.drawerViewDelegate = drawerVC;
//    
//    drawerVC.currentViewController = vc;
    
    self.window.rootViewController = navCon;
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
     
//        [FBSession openActiveSessionWithPublishPermissions:@[@"basic_info",@"publish_stream"]
//                                           defaultAudience:FBSessionDefaultAudienceOnlyMe
//                                              allowLoginUI:NO
//                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
//                                             [self sessionStateChanged:session state:state error:error];
//                                         }];
    }
    
    
    
    [[PromoScanner getInstance] stopUpdateingLocation];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //        [self userLoggedOut];
    }
    
    // Handle errors
    if (error)
    {
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        {
            alertTitle = @"Something went wrong";
            NSLog(@"%@",[FBErrorUtility userMessageForError:error]);
            alertText = [FBErrorUtility userMessageForError:error];
//                        [self showMessage:alertText withTitle:alertTitle];
        }
        else
        {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            {
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
                NSLog(@"2");
            }
            else
            {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //                [self showMessage:alertText withTitle:alertTitle];
                NSLog(@"3");
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //        [self userLoggedOut];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isBackGroundModeOn = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [self backgroundUpdate];
        
    }];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)backgroundUpdate
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    NSLog(@"app in BG");
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    // Check first to see if notification was fired while app was active.
    
    if (state != UIApplicationStateActive)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                              target:self
                                                            selector:@selector(backgroundUpdate)
                                                            userInfo:nil
                                                             repeats:NO];
            
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isBackGroundModeOn = NO;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(![[UserDefaultsManager sessionToken] isEqualToString:@""])
    {
//        [[PromoScanner getInstance] startUpdatingLocation];
    }
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PromoScanner getInstance] stopUpdateingLocation];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
         
         if(delegate)
         {
             [delegate cameBackToApp];
         }
     }];
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme] isEqualToString:@"myapp"] == NO) return NO;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    
    LoginV2ViewController *vc = [[LoginV2ViewController alloc] initWithNibName:@"LoginV2ViewController" bundle:nil];
    [vc setOAuthToken:token oauthVerifier:verifier];
    
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
         
         if(delegate)
         {
             [delegate cameBackToApp];
         }
     }];
    
    return NO;
}

-(void)didReceivePromo:(NSArray *)promoArray
{
    for(int i = 0; i < promoArray.count; i++)
    {
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
