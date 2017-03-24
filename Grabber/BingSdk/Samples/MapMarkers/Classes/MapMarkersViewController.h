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
//  MapMarkersViewController.h
//  MapMarkers
//

#import <UIKit/UIKit.h>
#import "BingMaps/BingMaps.h"

@class MarkerViewController;

@interface MapMarkersViewController : UIViewController <BMMapViewDelegate> {
	BMMapView *mapView;
	MarkerViewController *markerViewController;
	NSMutableArray *mapMarkers;

}

@property (nonatomic, retain) IBOutlet BMMapView *mapView;
@property (nonatomic, retain) IBOutlet MarkerViewController *markerViewController;

@property (nonatomic, retain) NSMutableArray *mapMarkers;

+ (CGFloat)markerPadding;
+ (CGFloat)calloutHeight;

- (IBAction)cityAction:(id)sender;
- (IBAction)needleAction:(id)sender;
- (IBAction)allAction:(id)sender;

@end

