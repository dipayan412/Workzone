//
//  RA_MenuObject.m
//  RestaurantApp
//
//  Created by World on 12/30/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_MenuObject.h"

@implementation RA_MenuObject

@synthesize menuId;
@synthesize menuImagePath;
@synthesize menuName;
@synthesize menuPrice;
@synthesize menuDetails;
@synthesize menuServeFor;
@synthesize numberOfOrder;

-(id)init
{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.menuId = [decoder decodeObjectForKey:@"menuId"];
        self.menuImagePath = [decoder decodeObjectForKey:@"menuImagePath"];
        self.menuName = [decoder decodeObjectForKey:@"menuName"];
        self.menuPrice = [decoder decodeObjectForKey:@"menuPrice"];
        self.menuDetails = [decoder decodeObjectForKey:@"menuDetails"];
        self.menuServeFor = [decoder decodeObjectForKey:@"menuServeFor"];
        self.numberOfOrder = [decoder decodeIntForKey:@"numberOfOrder"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:menuId forKey:@"menuId"];
    [encoder encodeObject:menuImagePath forKey:@"menuImagePath"];
    [encoder encodeObject:menuName forKey:@"menuName"];
    [encoder encodeObject:menuPrice forKey:@"menuPrice"];
    [encoder encodeObject:menuDetails forKey:@"menuDetails"];
    [encoder encodeObject:menuServeFor forKey:@"menuServeFor"];
    [encoder encodeInt:numberOfOrder forKey:@"numberOfOrder"];
}

@end
