//
//  UserDefaultsManager.m
//  PhotoPuzzle
//
//  Created by World on 10/30/13.
//  Copyright (c) 2013 Swengg-Co. All rights reserved.
//

#import "UserDefaultsManager.h"

#define proUpgradeDoneKey @"proUpgradeDoneKey"

@implementation UserDefaultsManager

+(BOOL)isProUpgradePurchaseDone
{
    BOOL storedPref = [[NSUserDefaults standardUserDefaults] boolForKey:proUpgradeDoneKey];
    return storedPref;
}

+(void)setProUpgradePurchaseDone:(BOOL)done
{
    [[NSUserDefaults standardUserDefaults] setBool:done forKey:proUpgradeDoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
