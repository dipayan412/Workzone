//
//  Project1AppDelegate.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "InAppPurchaseManager.h"

#import <Dropbox/Dropbox.h>

#define kDropboxDidLoginNotification @"kDropboxDidLoginNotification"
#define kDropboxFailedLoginNotification @"kDropboxFailedLoginNotification"

@class RootViewController;
@class SettingsViewController;
@class ReportListViewController;

@interface MyOvertimeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>
{
    UIWindow *window;
	UITabBarController *tabBarController;
	InAppPurchaseManager *purchaseManager;
	RootViewController *scheduleViewController;
	SettingsViewController *settingsViewController;
	ReportListViewController *reportListViewController;
	
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    
    UIAlertView *daysRminderAlert;
    UIAlertView *emailReportAlert;
    UIAlertView *dropBoxAlert;
    
    BOOL fromAlert;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIAlertView *daysRminderAlert;

@property (nonatomic, retain) IBOutlet RootViewController *scheduleViewController;
@property (nonatomic, retain) IBOutlet SettingsViewController *settingsViewController;
@property (nonatomic, retain) IBOutlet ReportListViewController *reportListViewController;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) NSMutableArray *localizedArray;
@property (nonatomic) BOOL canByPassLocalize, firstLoad;
@property (nonatomic, assign) BOOL fromAlert;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic) BOOL isProduct1Purchased,isProduct2Purchased, isProduct3Purchased;
- (void)saveContext;
//Derived attribute for quick checking
-(void) checkProductStatus;

-(void)checkIfDataExist;

-(void)showEmailAlert;
-(void)showDaysLimitAlert;
-(void)showDropBoxAlert;

- (void)resetCoreData;
-(void)resetApp;

@end

