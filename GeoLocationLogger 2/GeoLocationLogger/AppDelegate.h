//
//  AppDelegate.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *tabController;
    HomeViewController *homeVC;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) BOOL needManualCheckin;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showCheckinPage;

@end
