//
//  WhosinAppDelegate.h
//  Whosin
//
//  Created by Kumar Aditya on 09/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBUser.h"
#import <Dropbox/Dropbox.h>

#define kDropboxDidLoginNotification @"kDropboxDidLoginNotification"
#define kDropboxFailedLoginNotification @"kDropboxFailedLoginNotification"

@interface WhosinAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>
{
    UIWindow *window;
	IBOutlet UINavigationController *navController;
    
//    DBRestClient *restClient;
    Facebook *faceBook;
    id<FBUser>listener;
    
    int folderCreated;
    NSArray *categoryArrary;
    
    int imageUploaded;
    NSArray *imageNameArray;
    
    BOOL dropboxPullInProgress;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@property (nonatomic, retain) Facebook *faceBook;
-(void)fbLogin:(id<FBUser>)_listener;
-(void)fbLogOut:(id<FBUser>)_listener;

@property (nonatomic, assign) int globalCategoryIndex;

-(void)checkAndCreateDatabase;
 
 @end

