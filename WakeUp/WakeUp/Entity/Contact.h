//
//  Contact.h
//  WakeUp
//
//  Created by World on 8/8/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * givenName;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * uphotoId;
@property (nonatomic, retain) NSString * phoneNumber;

@end
