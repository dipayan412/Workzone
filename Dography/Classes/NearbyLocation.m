//
//  NearbyLocation.m
//  RenoMate
//
//  Created by Nazmul Quader on 3/11/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "NearbyLocation.h"

@implementation NearbyLocation

@synthesize longitude;
@synthesize latitude;
@synthesize vicinity;
@synthesize name;
@synthesize icon;

-(NSComparisonResult)compareLocationByName:(NearbyLocation*)otherLocation
{
    return [self.name compare:otherLocation.name];
}

@end
