//
//  PhoneBookObject.m
//  WakeUp
//
//  Created by World on 8/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PhoneBookObject.h"

@implementation PhoneBookObject

@synthesize isInvited;
@synthesize name;
@synthesize phoneNumber;
@synthesize image;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:name forKey:@"name"];
    [coder encodeBool:isInvited forKey:@"isInvited"];
    [coder encodeObject:image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.isInvited = [coder decodeBoolForKey:@"isInvited"];
        self.image = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
