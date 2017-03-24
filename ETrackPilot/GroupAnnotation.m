//
//  GroupAnnotation.m
//  ETrackPilot
//
//  Created by World on 7/9/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "GroupAnnotation.h"

@implementation GroupAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subTitle;

-(id)initWithLocation:(CLLocationCoordinate2D)location title:(NSString*)_title subTitle:(NSString*)_subtitle
{
    self = [super init];
    if (self)
    {
        self.coordinate = location;
        self.title = _title;
        self.subTitle = _subtitle;
    }
    return self;
}

@end
