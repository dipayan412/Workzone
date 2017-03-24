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
//  BMTemplateAppDelegate.h
//  BMTemplate
//

#import <UIKit/UIKit.h>

@class BMTemplateViewController;

@interface BMTemplateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BMTemplateViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BMTemplateViewController *viewController;

@end

