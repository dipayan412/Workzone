//
//  UserDefaultsManager.h
//  PhotoPuzzle
//
//  Created by World on 10/30/13.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+(BOOL)isProUpgradePurchaseDone;

+(void)setProUpgradePurchaseDone:(BOOL)done;

@end
