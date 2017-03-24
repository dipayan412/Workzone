//
//  AppDelegate.m
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ReportViewController.h"
#import "HistoryViewController.h"
#import "CountryViewController.h"
#import "LocationReader.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize isBackground;
@synthesize needManualCheckin;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LocationReader getInstance] startUploading];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:65.0f / 255.0f green:52.0f/255.0f blue:52.0f / 255.0f alpha:1.0f]];
    
    
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:204.0f / 255.0f green:102.0f/255.0f blue:0.0f alpha:1.0f]];
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:55.0f / 255.0f alpha:1.0f]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    tabController = [[UITabBarController alloc] init];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
        
        [[UINavigationBar appearance] setBarTintColor:kNavbarBackgroundColor];
        [[UITabBar appearance] setTintColor:kTabbarTitleTextColor];
        [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:55.0f / 255.0f alpha:1.0f]];
        
        tabController.tabBar.translucent = NO;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        
        UIImage *navBackground = [[UIImage imageNamed:@"Navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UINavigationBar appearance] setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
        
        UIImage *tabBackground = [[UIImage imageNamed:@"Tabbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UITabBar appearance] setBackgroundImage:tabBackground];
    }
    
    homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.navigationBar.translucent = NO;
    homeNC.tabBarItem.title = @"Check-in";
    homeNC.tabBarItem.image = [UIImage imageNamed:@"CheckIn.png"];
    
    CountryViewController *countryVC = [[CountryViewController alloc] initWithNibName:@"CountryViewController" bundle:nil];
    UINavigationController *countryNC = [[UINavigationController alloc] initWithRootViewController:countryVC];
    countryNC.navigationBar.translucent = NO;
    countryNC.tabBarItem.title = @"Countries";
    countryNC.tabBarItem.image = [UIImage imageNamed:@"Countries.png"];
    
    HistoryViewController *historyVC = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    UINavigationController *historyNC = [[UINavigationController alloc] initWithRootViewController:historyVC];
    historyNC.navigationBar.translucent = NO;
    historyNC.tabBarItem.title = @"History";
    historyNC.tabBarItem.image = [UIImage imageNamed:@"History.png"];
    
    tabController.viewControllers = [NSArray arrayWithObjects:homeNC, countryNC, historyNC, nil];
    
    self.needManualCheckin = NO;
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        if (application.applicationIconBadgeNumber > 0)
        {
            self.needManualCheckin = YES;
            application.applicationIconBadgeNumber = 0;
            [homeVC showCheckinButton];
        }
    }
    
    self.window.rootViewController = tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    isBackground = NO;
    return YES;
}

-(void)showCheckinPage
{
    [tabController setSelectedIndex:0];
    [homeVC showCheckinButton];
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    self.needManualCheckin = NO;
    [homeVC hideCheckinButton];
    
    if (app.applicationIconBadgeNumber > 0)
    {
        app.applicationIconBadgeNumber = 0;
        self.needManualCheckin = YES;
        [self showCheckinPage];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Background mode");
    
    isBackground = TRUE;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [self backgroundUpdate];
        
    }];
}

-(void)backgroundUpdate
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
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
    NSLog(@"Foreground mode");
    
    isBackground = FALSE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GeoLocationLogger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GeoLocationLogger.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
