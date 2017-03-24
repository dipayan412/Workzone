//
//  CustomMarker.m
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "CustomMarker.h"

@implementation CustomMarker

@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize subTitleStr;
@synthesize titleStr;

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude floatValue];
    theCoordinate.longitude = [self.longitude floatValue];;
    return theCoordinate;
}

- (NSString *)title
{
    return self.titleStr;
}

- (NSString *)subtitle
{
    return self.subTitleStr;
}

@end
