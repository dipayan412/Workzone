//
//  WhosinAppDelegate.m
//  Whosin
//
//  Created by Kumar Aditya on 09/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import "WhosinAppDelegate.h"
#import "DataBaseManager.h"
#import "ApplicationPreference.h"
#import "UINavigationController+Operations.h"

@implementation WhosinAppDelegate

@synthesize window;
@synthesize faceBook;

#pragma mark -
#pragma mark Application lifecycle

@synthesize navController;
@synthesize globalCategoryIndex;

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES" forKey:@"enableRotation"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    // for saving photos to iPhone
    [defaults setValue:@"set" forKey:@"iPhonePhotoSwitch"];
    // default value to be used for twiiter 
    [defaults setValue:@"set" forKey:@"twitterSwitch"];
    
    [self checkAndCreateDatabase];
    
    dropboxPullInProgress = NO;
    
    [ApplicationPreference setLaunchCount:([ApplicationPreference launchCount] + 1)];
    [ApplicationPreference setDroboxAlertShown:YES];
//    [ApplicationPreference setProUpgradePurchaseDone:YES];
    
    DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:@"7cy2qyj742w10e6" secret:@"2y5x3ulok6b0ow7"];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = accountMgr.linkedAccount;
    
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        
        [[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:[DBPath root] block:^()
        {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self pullDataFromDropbox];
            });
        }];
    }
    
    //FaceBook Integration
    
//    faceBook = [[Facebook alloc] initWithAppId:@"197160393776537" andDelegate:self];
    faceBook = [[Facebook alloc] initWithAppId:@"610435985663476" urlSchemeSuffix:@"travel" andDelegate:self];
    
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        faceBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        faceBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
//	[self.window addSubview:navController.view];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"App linked successfully!");
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dropbox" message:@"You have successfully enabled dropbox. It will  initially take time to sync all your files while you keep using the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
        [[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:[DBPath root] block:^()
         {
             NSLog(@"Dropbox change detected...");
             dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 
                 [self pullDataFromDropbox];

             });
             
         }];
        
        [ApplicationPreference setDropboxEnabled:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxDidLoginNotification object:self userInfo:nil];
        
        return YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxFailedLoginNotification object:self userInfo:nil];
    
//    return NO;
    return [faceBook handleOpenURL:url];
}

-(void)pullDataFromDropbox
{
    if (dropboxPullInProgress)
    {
        return;
    }
    
    dropboxPullInProgress = YES;
    
    NSLog(@"Pulling data from dropbox...");
    
    NSArray *categoryArray = [[DataBaseManager getInstance] getCatagoryNames];
    
    NSArray *folders = [[DBFilesystem sharedFilesystem] listFolder:[DBPath root] error:nil];
    NSMutableArray *folderNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < folders.count; i++)
    {
        DBFileInfo *folderPath = [folders objectAtIndex:i];
        NSString *folderName = [folderPath.path.stringValue lastPathComponent];
        
        if (![categoryArray containsObject:folderName])
        {
            [[DataBaseManager getInstance] insertCatName:folderName];
            
            NSLog(@"Category created: %@", folderName);
        }
        
        [folderNames addObject:folderName];
        
        [self pullFilesFromDropboxFolder:folderName];
    }
    
    for (int i = 0; i < categoryArray.count; i++)
    {
        NSString *categoryName = [categoryArray objectAtIndex:i];
        
        if (![folderNames containsObject:categoryName])
        {
            [[DataBaseManager getInstance] removeCat:categoryName];
            NSLog(@"Category removed: %@", categoryName);
        }
    }
    
    dropboxPullInProgress = NO;
}

-(void)pullFilesFromDropboxFolder:(NSString*)folderName
{
    NSArray *subCatArray = [[DataBaseManager getInstance] getSubCat:folderName];
    NSMutableArray *imageFileNames = [[NSMutableArray alloc] init];
    for (int j = 0; j < subCatArray.count; j++)
    {
        CategoryDescriptionDB *subCat = [subCatArray objectAtIndex:j];
        NSString *imageFileName = [subCat.PhotoRef lastPathComponent];
//        NSLog(@"Image file name: %@", imageFileName);
        [imageFileNames addObject:imageFileName];
    }
    
    NSArray *imageFiles = [[DBFilesystem sharedFilesystem] listFolder:[[DBPath root] childPath:folderName] error:nil];

    for (int j = 0; j < imageFiles.count; j++)
    {
        DBFileInfo *filePath = [imageFiles objectAtIndex:j];
        NSString *fileName = [filePath.path.stringValue lastPathComponent];
        
        if ([fileName isEqualToString:@"Info"])
        {
            continue;
        }
        
        if (![imageFileNames containsObject:fileName])
        {
            NSLog(@"Downloading image");
            CategoryDescriptionDB *ob = [[CategoryDescriptionDB alloc] init];
            
//            DBPath *infoFilePath = [[[[DBPath root] childPath:folderName] childPath:@"Info"] childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
//            DBFile *textFile = [[DBFilesystem sharedFilesystem] openFile:infoFilePath error:nil];
            
//            if (textFile)
//            {
//                NSString *fileText = [textFile readString:nil];
//                NSArray *components = [fileText componentsSeparatedByString:@"\n"];
//                NSString *latitudeStr = components.count > 0 ? [components objectAtIndex:0] : @"0.0f";
//                NSString *longitudeStr = components.count > 1 ? [components objectAtIndex:1] : @"0.0f";
//                NSString *locationStr = components.count > 2 ? [components objectAtIndex:2] : @"";
//                NSString *notesStr = components.count > 3 ? [components objectAtIndex:3] : @"";
//                
//                ob.notes = notesStr;
//                ob.location = locationStr;
//                ob.latitute = latitudeStr.floatValue;
//                ob.longitute = longitudeStr.floatValue;
//            }
//            else
//            {
                ob.notes = @"";
                ob.location = @"";
                ob.latitute = 0.0f;
                ob.longitute = 0.0f;
//            }
            
            DBFile *imageFile = [[DBFilesystem sharedFilesystem] openFile:filePath.path error:nil];
            NSData *data = [imageFile readData:nil];
            
            UIImage *img = [UIImage imageWithData:data];
            
            ob.PhotoRef = [self savePhotoToDocumentFolder:img name:fileName];
            ob.name = folderName;
            
            NSLog(@"Photo ref: %@", ob.PhotoRef);
            
            [[DataBaseManager getInstance] insertCatDescription:ob];
        }
    }
}

-(NSString *)savePhotoToDocumentFolder:(UIImage*)img name:(NSString*)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults valueForKey:@"iPhonePhotoSwitch"];
    if ([str isEqualToString:@"set"])
    {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [NSString stringWithFormat:@"%@",[paths1 objectAtIndex:0]];
    NSString *PhotoDesc = [NSString stringWithFormat:@"%@/%@", documentsDirectory1, name];
    
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:PhotoDesc atomically:NO];
    
    return PhotoDesc;
}

////////////////////
// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [faceBook handleOpenURL:url];
}

// For iOS 4.2+ support

-(void)fbLogin:(id<FBUser>)_listener
{
    listener = _listener;
    
    if(![faceBook isSessionValid])
    {        
        NSArray* permissions = [NSArray arrayWithObjects:
                                @"read_stream",
                                @"publish_stream",
                                @"offline_access",
                                @"user_checkins",
                                @"user_location",
                                @"publish_actions",
                                @"user_photos",
                                nil];
        
        [faceBook authorize:permissions];
    }
    else
    {
        [listener facebookDidLogin];
    }
}

- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[faceBook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[faceBook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [listener facebookDidLogin];
}

-(void)fbLogOut:(id<FBUser>)_listener
{
    listener = _listener;
    [faceBook logout];
//    [ApplicationPreference setFacebookEnabled:NO];
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
    [listener faceBookDidNotLogin];
    //protocol method
}

-(void)fbDidLogout
{
    NSLog(@"loggedOut");
    [listener faceBookDidLogOut];
    // protocol method
}

-(void)fbSessionInvalidated
{
    //protocol method
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    //protocol method
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application{
    
    [[DBFilesystem sharedFilesystem] removeObserver:self];
}


-(void) checkAndCreateDatabase{
    
    
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"renomate.sqlite"];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
   
    NSArray *categoryNames = [NSArray arrayWithObjects:@"Australia",
                              @"Brazil",
                              @"Canada",
                              @"China",
                              @"France",
                              @"Germany",
                              @"Greece",
                              @"Hong Kong",
                              @"India",
                              @"Italy",
                              @"Japan",
                              @"Malaysia",
                              @"New Zealand",
                              @"Russia",
                              @"Singapore",
                              @"South Africa",
                              @"Spain",
                              @"Thailand",
                              @"United Arab Emirates",
                              @"United Kingdom",
                              @"United States",
                              @"Africa",
                              @"Europe",
                              @"South America",
                              @"Asia",
                              nil];
    
    DataBaseManager *db = [DataBaseManager getInstance];
    
    for (int i = 0; i < categoryNames.count; i++)
    {
        [db insertCatName:[categoryNames objectAtIndex:i]];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



@end
