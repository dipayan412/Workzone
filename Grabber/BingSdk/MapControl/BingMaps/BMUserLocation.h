//
//  BMUserLocation.h
//  BingMaps
//
//  Copyright (c) 2011 Microsoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMGeometry.h"
#import "BMTypes.h"
#import "BMMarker.h"

@class BMUserLocationInternal;

@interface BMUserLocation : NSObject <BMMarker> {
@private
    BMUserLocationInternal* _internal;
}

@property (readonly, nonatomic, getter=isUpdating) BOOL updating;
@property (readonly, nonatomic) CLLocation *location;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *subtitle;

@end
