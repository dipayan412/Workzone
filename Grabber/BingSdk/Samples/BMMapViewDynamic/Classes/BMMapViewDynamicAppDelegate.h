//*********************************************************
//
//    Copyright (c) 2011 Microsoft Corporation. All rights reserved.
//    This code is licensed under the Microsoft Public License.
//    THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
//    ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
//    IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
//    PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
//*********************************************************
//
//  BMMapViewDynamicAppDelegate.h
//  BMMapViewDynamic


#import <UIKit/UIKit.h>

@class BMMapViewDynamicViewController;

@interface BMMapViewDynamicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BMMapViewDynamicViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BMMapViewDynamicViewController *viewController;

@end

