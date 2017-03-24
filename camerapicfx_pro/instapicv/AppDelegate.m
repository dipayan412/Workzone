//
//  AppDelegate.m
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 6/9/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginPage.h"
//#import "AdWhirlLog.h"
#import "Parse/Parse.h"
#import "InAppRageIAPHelper.h" 
//#import "ChartBoost.h"
//#import "FlurryAnalytics.h"
#import "Flurry.h"
//#import "FlurryAppCircle.h"
#import "singletonClass.h"
#import "CWLSynthesizeSingleton.h"
#import "Neocortex.h"
#import "NotificationInfo.h"
#import "mainview.h"
//#import "ALSdk.h"

//#import <RevMobAds/RevMobAds.h>



NSMutableArray *allFriends;
@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;
@synthesize tabBarController;
//@synthesize TopAd;
@synthesize /*bottomAd,*/sound;
@synthesize tagId;
@synthesize randomNum;
@synthesize isAlertView;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}
- (void)viewDidLoad
{
  //  self.navController.navigationBar.tintColor=[UIColor blueColor];
}
#pragma mark - iRateDelegate
//**********************************
- (void) showRatingController
{
    m_feedback = [[RatingsViewController alloc] initWithNibName:@"RatingsViewController" bundle:nil];
    //    [self.navController.view addSubview:m_feedback.view];
    [self.window addSubview:m_feedback.view];
    
}

#pragma mark - rating
- (void) ShowRating {
    
    //    RatingsViewController *feedback;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        m_feedback = [[RatingsViewController alloc] initWithNibName:@"RatingsViewController-iPad" bundle:nil];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        m_feedback = [[RatingsViewController alloc] initWithNibName:@"RatingsViewController" bundle:nil];
    }
    
    //    [self. addSubview:m_feedback.view];
    //    UIViewController * topVC = [[UIApplication sharedApplication].windows ]
    [self.window addSubview:m_feedback.view];
}

- (void) DismissAll {
    
    [m_feedback.view removeFromSuperview];
    if ([m_feedback retainCount] > 0) {
        [m_feedback release];
        m_feedback = nil;
    }
    
    
}

- (void)iRateUserDidAttemptToRateApp
{
    [self DismissAll];
}

- (void)iRateUserDidDeclineToRateApp
{
    [self DismissAll];
}

- (void)iRateUserDidRequestReminderToRateApp
{
    [self DismissAll];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
//    [ALSdk initializeSdk];
    
    
    [[singletonClass sharedsingletonClass].pool retain];

    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"])
    {
        [self getUUID];
    }
    NSString * udid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"];
    NSLog(@"%@",udid);
    

//    Commented this because @Sher told this start session is handled inside Neocortex
//    // ++ Mahendra Liya 23 Aug 2013 - Starts
//    [Flurry startSession:@"PQ59W6FHSP7RRFQ7FD9K"];
//    [Flurry logEvent:@"Application Started"];
//    // ++ Mahendra Liya 23 Aug 2013 - Ends
    
    /////////////////
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
    allFriends=[[NSMutableArray alloc]init];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
//    LoginPage *homeview=[[[LoginPage alloc]init] autorelease];
//    homeview.isSignIn = YES;
    
//    mainview *homeview=[[[mainview alloc]init] autorelease];
    
    FirstVC *homeview=[[[FirstVC alloc]init] autorelease];
    
    navController=[[UINavigationController alloc]initWithRootViewController:homeview];
    //[navController setViewControllers:[[[NSArray alloc]initWithObjects:homeview, nil] autorelease]];
    [self.window addSubview:navController.view];
    
    splashimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashimage.image=[UIImage imageNamed:@"Default.png"];
    [self.window addSubview:splashimage];
    navController.navigationBar.hidden=NO;
    [self performSelector:@selector(doTHis) withObject:nil afterDelay:1.0];
    [self.window makeKeyAndVisible];
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"DvPrrYLmFnE2UWyBJgl5FMkhQFpNe7IXetAEowDU"
                  clientKey:@"X3Au2wAbg68VhJI4HaedPYWc4Ie3ZQw3N4rwmFpY"];
    //
    // If you are using Facebook, uncomment and fill in with your Facebook App Id:
    // [PFFacebookUtils initializeWithApplicationId:@"your_facebook_app_id"];
    // ****************************************************************************
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    // Optionally enable public read access by default.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    [self loadData];
    NSDictionary *dict=[[[NSDictionary alloc]initWithDictionary:[storename objectAtIndex:0]] autorelease];
    
    dict=[[[NSDictionary alloc]initWithDictionary:[storename objectAtIndex:1]] autorelease];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"soundIsOff"])
    {
        sound = NO;
    }
    else
    {
        sound = YES;
    }
    
//#ifdef ADWHIRL_DEBUG
//	AWLogSetLogLevel(AWLogLevelDebug);
//#endif
    [self setupVoice];
    
    
    [self loadNotificationsPlist];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notification)
    {
        [self handleNotifications:notification];
    }
    
    
    iRate * rate = [iRate sharedInstance];
    [rate setDelegate:self];
    rate.appStoreGenre     = iRateAppStoreGenreGame;
    rate.daysUntilPrompt   = 3000;
    rate.usesUntilPrompt   = 3000;
    rate.eventsUntilPrompt = 0;
    rate.promptAtLaunch    = YES;
    rate.ratingsURL        = [NSURL URLWithString: @"http://georiot.co/ZPM"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    return YES;
}
- (void)productPurchased:(NSNotification *)notification
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] || [[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *productIdentifier = (NSString *) notification.object;
        NSLog(@"Purchased: %@", productIdentifier);
        NSMutableDictionary *newDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[storename objectAtIndex:tagId] objectForKey:@"Name"],@"Name",[[storename objectAtIndex:tagId] objectForKey:@"inAppIdentifier"],@"inAppIdentifier",@"Yes",@"Purchased",[NSString stringWithFormat:@"%d",tagId],@"tag",@"Yes",@"ButtonState",nil] autorelease];
        NSLog(@"%@",newDict);
        NSLog(@"Store name in product purchased %@",storename);
        [storename replaceObjectAtIndex:tagId withObject:newDict];
        [self updateData];
    }
}
-(void)updateData{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if (fileExists) {
        //     NSLog(@"%@",filepath);
        [storename writeToFile:filepath atomically:YES];
    }
    else{
        //   NSLog(@"%@",filepath);
        [storename writeToFile:filepath atomically:YES];
    }
    NSLog(@"filepath in app delegate %@",filepath);
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    //    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeBottomSwitch"] == YES)
    //    {
    //
    //    }
    //    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeTopSwitch"] == YES)
    //    {
    //
    //    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Top"] || [[[NSUserDefaults standardUserDefaults] objectForKey:ALERT_NAME] isEqualToString:@"Startup Upgrade Popup Bottom"])
    {
        
    
    
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if([[[storename objectAtIndex:0] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstTimeTopSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.TopAd=NO;
        }
        else
        {
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.TopAd=YES;
        }
        if([[[storename objectAtIndex:1] objectForKey:@"ButtonState"] isEqualToString:@"No"])
        {
            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.bottomAd=NO;
        }
        else
        {
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.bottomAd=YES;
        }
        
        SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
        if (transaction.error.code != SKErrorPaymentCancelled) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                             message:transaction.error.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil] autorelease];
            
            [alert show];
        }
    }
}


- (void)loadNotificationsPlist
{
    
    NSString * plistPath= [[NSBundle mainBundle] pathForResource:@"notificationData" ofType:@"plist"];
    
    
    NSDictionary * temp = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray * notificationData = [temp objectForKey:@"Data"];
    
    self.notificationArray = [NSMutableArray array];
    
    
    for (NSDictionary * dict in notificationData)
    {
        NotificationInfo *obj = [[NotificationInfo alloc ]  initWithDictionary:dict];
        
        [self.notificationArray addObject:obj];
        [obj release];
    }
    
}
-(void)setupVoice
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"send" ofType:@"mp3"];
    [singletonClass sharedsingletonClass].theAudios=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    [singletonClass sharedsingletonClass].theAudios.delegate=self;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"funky" ofType:@"mp3"];
    [singletonClass sharedsingletonClass].theAudios1=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path1] error:NULL];
    [singletonClass sharedsingletonClass].theAudios1.delegate=self;
    [singletonClass sharedsingletonClass].theAudios1.numberOfLoops=-1;
}
- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, "" 

    

    NSString * udid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueID"];
    NSLog(@"%@",udid);
    [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"PhotoPuzzle%@",udid] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
    //        NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
      //      NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application 
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
    //    NSLog(@"Push notifications don't work in the simulator!");
    } else {
      //  NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application 
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

-(void)doTHis
{
    [splashimage removeFromSuperview];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [splashimage removeFromSuperview];
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        splashimage.frame=CGRectMake(0, 0, 768, 1024);
    }
    else
    {
        splashimage.frame=CGRectMake(0, 0, 320, 480);
    }
    NSDate * date = [NSDate date];
    [self rescheduleNotifications:date];
    [self.window addSubview:splashimage];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    
    NSString * message;
    
    int random = rand()%2;
    
    self.randomNum = random;
    
    if(self.randomNum==0)
    {
//        if(TopAd==NO)
//        {
//            message = @"Upgrade to Remove Top Banner";
//        }
//        else if(bottomAd ==  NO)
//        {
//            message = @"Upgrade to Remove Bottom Banner";
//        }
    }
    
    if(self.randomNum ==1)
    {
//        if(bottomAd ==  NO)
//        {
//            message = @"Upgrade to Remove Bottom Banner";
//        }
//        else if(TopAd ==  NO)
//        {
//            message = @"Upgrade to Remove Top Banner";
//        }
    }
//    if(TopAd == NO || bottomAd == NO  )
//    {
        if(!self.isAlertView)
        {
//            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Hey!" message:message  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil] autorelease];
//            [alert show];
//            self.isAlertView = YES;
        }
        
//    }
    
    
    self.window.hidden=NO;
    playbacktimer=[[NSTimer alloc]init];
    
    date = [[NSDate alloc]initWithTimeIntervalSinceNow:1.0];
    done=0;
    playbacktimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(loadaftersplash)
                                                   userInfo:nil
                                                    repeats:YES];
    
    /*
    if([[[ALSharedData getSharedInstance] playHavenInfoObj] showOnBecomeActive] == YES)
    {
        [self loadPlayHaven];
    }
    */
    /*
    if([[[ALSharedData getSharedInstance] appLovinInfoObj] showOnBecomeActive] == YES)
    {
        [ALInterstitialAd showOver:[(AppDelegate*)[[UIApplication sharedApplication] delegate] window]];
    }
    */
}

/*
-(void)loadPlayHaven
{
    PHPublisherContentRequest *request2 = [PHPublisherContentRequest requestForApp:PLAYHAVEN_APP_TOKEN secret:PLAYHAVEN_APP_SECRET placement:@"main_menu" delegate:self];
    [request2 send];
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isAlertView = NO;
}

- (void)transactionHandlerOne
{
    
}
-(void)loadaftersplash
{
    remainingSec = [date timeIntervalSinceNow];
    if (remainingSec<=0&&done==0)
    {
        splashimage.hidden=YES;
        [splashimage removeFromSuperview];
        done=1;
        [playbacktimer invalidate];
        playbacktimer=nil;
    }
}
- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error
{
    if ([result boolValue])
    {
      //  NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else
    {
      //  NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
     application.applicationIconBadgeNumber = 0;
    
//    [[Neocortex getInstance] onBecomeActive];
    
  
    // sSher
    
    /*
    
    Chartboost *cb = [Chartboost sharedChartboost];
   // cb.delegate = self;
    cb.appId = @"519bd0c317ba47fa4600000a";
    cb.appSignature = @"571ee9e5d6478d1b9ac4c563fecd7f31f98d5e3c";
    

    // Notify the beginning of a user session
    [cb startSession];
    
    // Show an interstitial
    [cb cacheMoreApps];
     */
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSDate * date = [NSDate date];
    [self rescheduleNotifications:date];
    self.notificationArray = nil;
}
- (void) handleNotifications: (UILocalNotification *) appNotification
{
    NSDictionary *dict = [appNotification userInfo];
    
    id obj = [dict valueForKey:@"ID"];
    notificationID = [obj intValue];
    NSLog(@"\n\n\nnotificationID is = %d\n\n\n", notificationID );
    switch (notificationID)
    {
        case 0:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 1:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 2:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 3:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 4:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 5:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 6:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        case 7:
        {
            //Add ur methods according to your requirement
            break;
        }
            
        default:
            break;
    }
    [self cancelAllNotification];
}
-(void) cancelAllNotification
{
    
           [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

- (void) rescheduleNotifications: (NSDate *)currentDate
{
    
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil) 
    {
        // cancel all scheduled notification
        
        
        [self cancelAllNotification];
        //Setting date and time flags
        NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSUInteger timeFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:timeFlags fromDate:currentDate];
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:currentDate];
        
        NSDateComponents *dateAndTimeComponents = [[NSDateComponents alloc] init];
        
        for (int i=0; i<[self.notificationArray count]; i++)
        {
            
            NotificationInfo *obj = [self.notificationArray objectAtIndex:i];
            
            //            NSLog(@"Obj %@",);
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            [dateAndTimeComponents setDay:[dateComponents day]+[obj notifDay]];
            [dateAndTimeComponents setMonth:[dateComponents month]];
            [dateAndTimeComponents setYear:[dateComponents year]];
            [dateAndTimeComponents setHour:[timeComponents hour]];
            [dateAndTimeComponents setMinute:[timeComponents minute]];
            [dateAndTimeComponents setSecond:[timeComponents second]];
            // change hour, min, sec, etc according to your requirement of the application by just ADDING (+)  [obj notifDay] in hour, min, day, etc
            
            
            
            
            NSDate *myNewDate = [calendar dateFromComponents:dateAndTimeComponents];
            
                [self setNotification:myNewDate andTitle:[obj notifTitle] andIndex:i];
            
           
            
        }
        
        
        [dateAndTimeComponents release];
    }
}
- (void) setNotification:(NSDate *)notificationDate andTitle:(NSString *)notificationTitle andIndex:(NSInteger )notificationIndex
{
    NotificationInfo *obj = [notificationArray objectAtIndex:notificationIndex];
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    id tempObj = [obj notifID];
      
    [infoDict setValue:tempObj forKey:@"ID"];
    //[infoDict setObject:myNewDate forKey:@"Date"];
    
    UILocalNotification * localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = notificationDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 35;
    
    // Notification details
    localNotif.alertBody = notificationTitle;
    // Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    
    
    
    
}

- (NSString *)getUUID
{
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"];
    if (!UUID)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        UUID = [(NSString*)string stringByReplacingOccurrencesOfString:@"-"withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:UUID forKey:@"uniqueID"];
    }
    return UUID;
}





-(void)loadData
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath =[documentsDirectory stringByAppendingPathComponent:@"store.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileExists)
    {
    //    NSLog(@"%@",filepath);
        storename = [[NSMutableArray alloc] initWithContentsOfFile:filepath];
    }
    else
    {
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"store" ofType:@"plist"];
    //    NSLog(@"%@",filePath1);
        storename = [[NSMutableArray alloc] initWithContentsOfFile:filePath1];
    } 
//    NSLog(@"%@",storename);
//    NSLog(@"%d",storename.count);
}

@end
