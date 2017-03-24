//
//  RA_ShareManager.h
//  RestaurantApp
//
//  Created by Ashif on 2/6/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RA_MenuObject;

@interface RA_ShareManager : NSObject

+(void)shareToPlatfrom:(kSettingsOptions)_platform object:(RA_MenuObject*)_obj menuImage:(UIImage*)_image fromController:(UIViewController*)_controller;

@end
