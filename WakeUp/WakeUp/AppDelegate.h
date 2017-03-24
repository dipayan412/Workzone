//
//  AppDelegate.h
//  WakeUp
//
//  Created by World on 6/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StatusController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, StatusControllerDelegate>
{
    DrawerViewController *drawerVc;
    UINavigationController *nav;
    
    ASIHTTPRequest *addWakeUpRequest;
    
    NSString *statusString;
    
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    BOOL noInternetConnection;
}

@property (nonatomic) BOOL syncOnProgress;
@property (nonatomic) BOOL addPhonebookContactsDone;
@property (nonatomic) BOOL phonebookCheckDone;
@property (strong, nonatomic) NSMutableArray *registeredContacts;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *foregroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) BOOL backgroundModeOn;
@property (nonatomic, assign) BOOL isInChatRoom;

@property (nonatomic, strong) UIAlertView *loadingAlert;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

-(void)checkPhonebookContact;

@end
