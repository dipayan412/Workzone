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
//  LocationMapViewController.h
//  LocationMap
//

#import <UIKit/UIKit.h>
#import "BingMaps/BingMaps.h"

@interface LocationMapViewController : UIViewController <BMMapViewDelegate, BMReverseGeocoderDelegate> {
	IBOutlet BMMapView* mapView;
	BMReverseGeocoder* reverseGeocode;
}

- (IBAction)zoomTapped:(id)sender;
- (IBAction)fitTapped:(id)sender;
- (IBAction)styleTapped:(id)sender;
- (IBAction)reverseGeocoderTapped:(id)sender;

@end

