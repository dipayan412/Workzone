//
//  GroupAnnotation.h
//  ETrackPilot
//
//  Created by World on 7/9/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GroupAnnotation : NSObject <MKAnnotation>
{
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subTitle;

-(id)initWithLocation:(CLLocationCoordinate2D)location title:(NSString*)_title subTitle:(NSString*)_subtitle;

@end
