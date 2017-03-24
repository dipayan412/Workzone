//*********************************************************
//
//    Copyright (c) 2011 Microsoft Corporation. All rights reserved.
//    This code is licensed under the Microsoft Public License.
//    THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
//    ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
//    IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
//    PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
//*********************************************************
//
//  SpaceNeedleMarker.m
//  MapMarkers
//

#import "SpaceNeedleMarker.h"


@implementation SpaceNeedleMarker

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 47.61989;
    theCoordinate.longitude = -122.34825;
    return theCoordinate; 
}

- (NSString *)title
{
    return @"Space Needle";
}

- (NSString *)subtitle
{
    return @"Opened: April 21, 1962";
}

- (void)dealloc
{
    [super dealloc];
}


@end
