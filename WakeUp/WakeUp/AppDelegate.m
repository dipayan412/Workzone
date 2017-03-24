//
//  AppDelegate.m
//  WakeUp
//
//  Created by World on 6/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils/UserDefaultsManager.h"
#import "VerificationViewController.h"
#import "LoginV2ViewController.h"
#import "MotionScanner.h"
#import "MessageRoomSynchronizer.h"
#import "AddContactByPhoneBookManager.h"
#import "Reachability.h"
#import <AudioToolbox/AudioServices.h>

@implementation AppDelegate

@synthesize foregroundManagedObjectContext = _foregroundManagedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize loadingAlert;
@synthesize backgroundModeOn;
@synthesize isInChatRoom;

@synthesize addPhonebookContactsDone;
@synthesize phonebookCheckDone;
@synthesize syncOnProgress;

@synthesize registeredContacts;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Reachability* newInternetReachability = [Reachability reachabilityForInternetConnection];
    [newInternetReachability startNotifier];
    
    if([newInternetReachability currentReachabilityStatus] == NotReachable)
    {
        noInternetConnection = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!" message:@"No internet connection. Please check your internet settings" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    application.applicationSupportsShakeToEdit = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    self.registeredContacts = [[NSMutableArray alloc] init];
    
    backgroundModeOn = NO;
    
    geocoder = [[CLGeocoder alloc] init];
    
    self.loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foregroundContextSaved:) name:NSManagedObjectContextDidSaveNotification object:self.foregroundManagedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundContextSaved:) name:NSManagedObjectContextDidSaveNotification object:self.backgroundManagedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCheckPhonebookDone) name:kPhonebookCheckComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSyncPhonebookDone) name:kPhonebookContactSyncDone object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc;
    if(![UserDefaultsManager isAccountVerified])
    {
        vc = [[VerificationViewController alloc] initWithNibName:@"VerificationViewController" bundle:nil];
        
        phonebookCheckDone = NO;
        addPhonebookContactsDone = NO;
        syncOnProgress = NO;
        // TODO: start check contacts status
    }
    else
    {
        vc = [[DrawerViewController alloc] initWithNibName:@"DrawerViewController" bundle:nil];
    }

    nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotification)
    {
        NSLog(@"local");
    }
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)networkReachabilityDidChange:(NSNotification *)notification
{
    if(noInternetConnection)
    {
        Reachability *currReach = [notification object];
        NSParameterAssert([currReach isKindOfClass: [Reachability class]]);
        
        int currStatus = [currReach currentReachabilityStatus];
        
        switch (currStatus)
        {
            case ReachableViaWiFi:
                
                noInternetConnection = NO;
                
                [self getLocationFromGoogle];
                
                break;
            case ReachableViaWWAN:
                
                noInternetConnection = NO;
                
                [self getLocationFromGoogle];
                
                break;
            case NotReachable:
                
                break;
            default:
                break;
        }
    }
}

-(void)onCheckPhonebookDone
{
    /*
    if(self.registeredContacts.count > 0)
    {
        self.phonebookCheckDone = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kStartPhonebookContactSync object:nil];
    }
    */
    
    self.phonebookCheckDone = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kStartPhonebookContactSync object:nil];
}

-(void)onSyncPhonebookDone
{
    self.phonebookCheckDone = YES;
    self.addPhonebookContactsDone = YES;
    self.syncOnProgress = NO;
}

-(void)foregroundContextSaved:(NSNotification*)notification
{
    [self.backgroundManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

-(void)backgroundContextSaved:(NSNotification*)notification
{
    [self.foregroundManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
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
                NSLog(@"%@",[error localizedDescription]);
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

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    const char* data = deviceToken.bytes;
        
    NSMutableString* tokenString = [NSMutableString string];
    
    for (int i = 0; i < deviceToken.length; i++)
    {
        [tokenString appendFormat:@"%02.2hhX", data[i]];
    }
    
    NSLog(@"deviceToken String: %@", tokenString);
    [UserDefaultsManager setDeviceToken:tokenString];
    
    if([UserDefaultsManager shouldRegistereLater])
    {
        [self registerDeviceToServer];
    }
}

-(void)registerDeviceToServer
{
    [UserDefaultsManager setDeviceShouldRegistereLater:NO];
    // TODO: register device token
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kBaseUrl];
    [urlStr appendFormat:@"cmd=%@",kRegisterDeviceApi];
    [urlStr appendFormat:@"&phone=%@",[UserDefaultsManager userPhoneNumber]];
    [urlStr appendFormat:@"&dtoken=%@",[UserDefaultsManager token]];
    [urlStr appendFormat:@"&dtype=%@",@"1"];
    
    NSLog(@"regDevice urlStr %@",urlStr);
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = 60;
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"SendContactRequest request return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        if([[responseObject objectForKey:@"status"] intValue] == 0 && responseObject)
        {
            
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[request.error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }];
    [request startAsynchronous];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to register with error : %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    backgroundModeOn = YES;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    backgroundModeOn = NO;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application
             openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
          annotation:(id)annotation
{
    //    [FBSession.activeSession setStateChangeHandler:
    //     ^(FBSession *session, FBSessionState state, NSError *error) {
    //
    //         // Retrieve the app delegate
    //         AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
    //         [appDelegate sessionStateChanged:session state:state error:error];
    //
    //         if(delegate)
    //         {
    //             [delegate cameBackToApp];
    //         }
    //     }];
    //
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //    return [FBSession.activeSession handleOpenURL:url];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remote user Info %@",userInfo);
    if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"says"].location != NSNotFound && backgroundModeOn)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIncomingMessageArrivedRemoteNotification object:nil];
    }
    else if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"says"].location != NSNotFound && !backgroundModeOn && isInChatRoom)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIncomingMessageArrivedRemoteNotificationReloadChatRoom object:nil];
    }
    else if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"woken up"].location != NSNotFound && backgroundModeOn)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWokenUpRemoteNotificationArrived object:nil];
    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kOtherTypeRemoteNotificationArrived object:nil];
//    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"notification arrived");
    if([[notification.userInfo objectForKey:@"wakeup"] isEqualToString:@"WakeUpAlert"])
    {
        if([UserDefaultsManager isAccountVerified])
        {
            if([UserDefaultsManager isMotionDetectionOn])
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMovedPhone) name:kUserMovedPhone object:nil];
                [[MotionScanner getInstance] startMotionScanner];
            }
            else
            {
                locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;
                
                UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Are you waking up?"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"NO"
                                                       otherButtonTitles:@"YES", nil];
                alert.tag = 1;
                [alert show];
            }
            NSLog(@"local2");
        }
    }
}

-(void)userMovedPhone
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserMovedPhone object:nil];
    [[MotionScanner getInstance] stopMotionScanner];
    
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Are you waking up?"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"NO"
                                           otherButtonTitles:@"YES", nil];
    alert.tag = 1;
    [alert show];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.foregroundManagedObjectContext;
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
- (NSManagedObjectContext *)foregroundManagedObjectContext
{
    if (_foregroundManagedObjectContext != nil) {
        return _foregroundManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _foregroundManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_foregroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _foregroundManagedObjectContext;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)backgroundManagedObjectContext
{
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_backgroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _backgroundManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WakeUp" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WakeUp.sqlite"];
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
//            [self scheduleLocalNotificationIsSnooze:NO];
//            [self showStatusController];
            [self showImagePicker];
        }
        else
        {
            [self scheduleLocalNotificationIsSnooze:YES];
        }
    }
}

-(void)showStatusControllerWithImage:(UIImage*)attachedImage WithImageId:(NSString*)attachedImageId
{
    StatusController *stsVC = [[StatusController alloc] initWithNibName:@"StatusController" bundle:nil];
    stsVC.delegate = self;
    stsVC.attachedImage = attachedImage;
    stsVC.attachedImageId = attachedImageId;
    
    UIViewController *vc = [[nav viewControllers] lastObject];
    [vc presentViewController:stsVC animated:YES completion:nil];
}

-(void)dismissStatusViewController:(UIViewController *)vc
{
    [vc dismissViewControllerAnimated:YES completion:nil];
}

-(void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = NO;
    
    UIViewController *vc = [[nav viewControllers] lastObject];
    
    [vc presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showStatusControllerWithImage:nil WithImageId:@""];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UserDefaultsManager showBusyScreenToView:picker.view WithLabel:@"Uploading Image"];
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if ([info objectForKey:@"UIImagePickerControllerMediaMetadata"])
    {
        int state = [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"] intValue];
        NSLog(@"State = %d", state);
        switch (state)
        {
            case 3:
                //Rotate image to the left twice.
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:[self rotateImage:img withRotationType:1] withRotationType:1];
                break;
                
            case 6:
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:img withRotationType:-1];
                break;
                
            case 8:
                img = [UIImage imageWithCGImage:[img CGImage]];
                img = [self rotateImage:img withRotationType:1];
                break;
                
            default:
                break;
        }
    }
    
    img = [self imageWithImage:img scaledToWidth:200];
    [self uploadImageWithImageData:UIImagePNGRepresentation(img) WithDismissingPicker:picker];
}

#pragma mark scale image

- (UIImage *) imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark rotate image

-(UIImage*)rotateImage:(UIImage*)img withRotationType:(int)rotation
{
    CGImageRef imageRef = [img CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
    {
        alphaInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    bitmap = CGBitmapContextCreate(NULL, img.size.height, img.size.width, CGImageGetBitsPerComponent(imageRef), 4 * img.size.height, colorSpaceInfo, alphaInfo);
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextTranslateCTM (bitmap, (rotation > 0 ? img.size.height : 0), (rotation > 0 ? 0 : img.size.width));
    CGContextRotateCTM (bitmap, rotation * M_PI / 2.0f);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, img.size.width, img.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGContextRelease(bitmap);
    return result;
}

#pragma mark upload image to server

-(void)uploadImageWithImageData:(NSData*)imageData WithDismissingPicker:(UIImagePickerController*)picker
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:kUploadphotoApi];
        
        NSData *data = imageData;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if (error || returnData == nil)
        {
            NSLog(@"%@", error.description);
        }
        else
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
            NSLog(@"%@ %@", responseObject, error.description);
            if([[responseObject objectForKey:@"status"] intValue] == 0)
            {
                NSLog(@"image uploaded successfully");
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [UserDefaultsManager hideBusyScreenToView:picker.view];
                    [picker dismissViewControllerAnimated:YES completion:^{
                        [self showStatusControllerWithImage:[UIImage imageWithData:imageData] WithImageId:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"imgid"]]];
                    }];
                });
            }
            else
            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                message:@"Could not upload photo to Server. Try again later"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Dismiss"
//                                                      otherButtonTitles:nil];
//                [alert show];
//                return;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [UserDefaultsManager hideBusyScreenToView:picker.view];
                    [picker dismissViewControllerAnimated:YES completion:^{
                        [self showStatusControllerWithImage:nil WithImageId:@""];
                    }];
                    
                });
                
            }
            NSLog(@"%@ %@", responseObject, error.description);
        }
    });
}

-(void)scheduleLocalNotificationIsSnooze:(BOOL)isSnooze
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
//    if([UIDevice currentDevice].systemVersion.intValue >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound| UIUserNotificationTypeAlert| UIUserNotificationTypeBadge) categories:nil]];
//    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(!isSnooze)
    {
        if([UserDefaultsManager isMotionDetectionOn])
        {
            localNotification.fireDate = [UserDefaultsManager motionAlarmTime];
        }
        else
        {
            localNotification.fireDate = [UserDefaultsManager alarmTime];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kAlarmNotificationArrived object:nil];
    }
    else
    {
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:[UserDefaultsManager snoozeInterval] * 60];
    }
    
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = @"Its time to Wake Up !!!";
    localNotification.alertAction = @"Go to app";
    localNotification.soundName = @"sound.caf";//UILocalNotificationDefaultSoundName;
    localNotification.hasAction = YES;
    localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"WakeUpAlert", @"wakeup", nil];
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyy-MM-DD HH:mm:ss";
    NSLog(@"next alarm %@",[df stringFromDate:localNotification.fireDate]);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(userLocation == nil)
    {
        userLocation = [locations lastObject];
        NSLog(@"got location");
        
        [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0)
            {
                placemark = [placemarks lastObject];
                
                [UserDefaultsManager setCurrentCountry:placemark.country];
                
                [self checkPhonebookContact];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentCountryFound object:nil];
            }
            else
            {
                NSLog(@"%@", error.debugDescription);
            }
        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([UserDefaultsManager currentCountry].length < 1)
    {
        [self getLocationFromGoogle];
    }
}

-(void)getLocationFromGoogle
{
    NSString *timeZoneName = [NSTimeZone systemTimeZone].name;
    NSArray *arr = [timeZoneName componentsSeparatedByString:@"/"];
    
    NSString *cityName = [arr lastObject];
    if(cityName.length < 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStartContactCheckFromVerification object:nil userInfo:nil];
        return;
    }
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",kGetCountryApi];
    [urlStr appendFormat:@"%@", cityName];
    
    NSLog(@"getCountryNameFromGoogle urlStr %@",urlStr);
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = 60;
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        NSLog(@"SendContactRequest request return %@  \nError %@ \n responseStr %@",responseObject, error, request.responseString);
        if([[responseObject objectForKey:@"status"] isEqualToString:@"OK"] && responseObject)
        {
            NSArray *arr = [responseObject objectForKey:@"results"];
            NSDictionary *tmpdic = [arr objectAtIndex:0];
            NSArray *addressComponents = [tmpdic objectForKey:@"address_components"];
            NSDictionary *componentDetails = [addressComponents lastObject];
            NSString *countryName = [componentDetails objectForKey:@"long_name"];
            
            [UserDefaultsManager setCurrentCountry:countryName];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentCountryFound object:nil];
            
            [self checkPhonebookContact];
        }
    }];
    [request setFailedBlock:^{
        
        NSLog(@"%@",[request.error localizedDescription]);
    }];
    
    [request startAsynchronous];
}

-(void)checkPhonebookContact
{
    if(![UserDefaultsManager isAccountVerified])
    {
        [[AddContactByPhoneBookManager getInstance] getAddressBook];
    }
}

@end
