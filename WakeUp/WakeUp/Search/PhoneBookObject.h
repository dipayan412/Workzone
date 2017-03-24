//
//  PhoneBookObject.h
//  WakeUp
//
//  Created by World on 8/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneBookObject : NSObject

@property (nonatomic) BOOL isInvited;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImage *image;

@end
