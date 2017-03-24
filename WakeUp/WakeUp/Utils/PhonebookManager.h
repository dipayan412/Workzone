//
//  PhonebookManager.h
//  WakeUp
//
//  Created by World on 8/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhonebookManager : NSObject

+(PhonebookManager*)getInstance;

-(NSArray*)getPhoneBookContact;

@end
