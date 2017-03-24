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
//  LocationMapViewController.m
//  LocationMap
//

#import "LocationMapViewController.h"

@implementation LocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
	
	//setRegion to Western Europe
	/*
	CLLocationCoordinate2D coords;
	coords.latitude = 51.508742;
	coords.longitude = -0.175781;	
	
	BMCoordinateSpan span;
	span.latitudeDelta = 50;
	span.longitudeDelta = 50;
	
	BMCoordinateRegion region = BMCoordinateRegionMake( coords, span );
	region = [mapView regionThatFits:region];
	[mapView setRegion:region animated:YES];
	 */
}

- (IBAction)zoomTapped:(id)sender {
	// Zoom to User Location
    BMUserLocation* loc = [mapView userLocation];
    CLLocation* pos = [loc location];
    BMCoordinateRegion region = BMCoordinateRegionMakeWithDistance( [pos coordinate], [pos verticalAccuracy], [pos horizontalAccuracy] );
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];    
}

- (IBAction)fitTapped:(id)sender {
	// Fit to world view
    BMCoordinateRegion region;
    region.center.latitude = 0;
    region.center.longitude = 0;
    region.span.latitudeDelta = 400;
    region.span.longitudeDelta = 400;
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (IBAction)styleTapped:(id)sender {
    BMMapMode current = [mapView mapMode];
    BMMapMode next;
    switch( current ) {
        case BMMapModeRoad:
            next = BMMapModeAerialWithLabels;
            break;
        case BMMapModeAerialWithLabels:
            next = BMMapModeAerial;
            break;
        default:
        case BMMapModeAerial:
            next = BMMapModeRoad;
            break;
    }
    [mapView setMapMode:next];
}

- (IBAction)reverseGeocoderTapped:(id)sender {
	//Initialize the reverse geocoder instance with the current region's center point
	reverseGeocode = [[BMReverseGeocoder alloc] initWithCoordinate:[mapView region].center];
	reverseGeocode.delegate = self;
	[reverseGeocode start];	
	
}

- (void)mapView:(BMMapView *)aMapView regionWillChangeAnimated:(BOOL)animated {
    BMCoordinateRegion region = [mapView region];
    NSLog( @"will change animated:%d - c %g,%g s %g,%g", animated, region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta );
}

- (void)mapView:(BMMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    BMCoordinateRegion region = [mapView region];
    NSLog( @"did change animated:%d - c %g,%g s %g,%g", animated, region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta );
}

- (void)mapViewWillStartLoadingMap:(BMMapView *)aMapView {
    NSLog( @"will start loading" );
}

- (void)mapViewDidFinishLoadingMap:(BMMapView *)aMapView {
    NSLog( @"did finish loading" );
}

- (void)mapViewDidFailLoadingMap:(BMMapView *)aMapView withError:(NSError *)error {
    NSLog( @"did fail loading" );
}

-(void)reverseGeocoder:(BMReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog( @"did fail reverse geocoding with error, [%@]", error.description);	
	UIAlertView *reverseGeocodeAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[reverseGeocodeAlert show];
	[reverseGeocodeAlert release];
    [reverseGeocode release];
}

-(void)reverseGeocoder:(BMReverseGeocoder *)geocoder didFindEntity:(BMEntity *)entity {
	NSLog(@"Reverse geocoder has returned: %@", [entity addressDictionary]);

	//Show the results of the reverse geocode operation as an alert
	UIAlertView *reverseGeocodeAlert = [[UIAlertView alloc] initWithTitle: [entity adminDistrict] message: [entity formattedAddress] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[reverseGeocodeAlert show];
	[reverseGeocodeAlert release];
    [reverseGeocode release];
}

- (void)dealloc {
    [super dealloc];
}

@end
