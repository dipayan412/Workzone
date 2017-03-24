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
//  MapMarkersViewController.m
//  MapMarkers
//


#import "MapMarkersViewController.h"
#import "MarkerViewController.h"
#import "SpaceNeedleMarker.h"
#import "SeattleMarker.h"

enum
{
    kSeattleMarkerIndex = 0,
    kSpaceNeedleMarkerIndex
};


@implementation MapMarkersViewController

@synthesize mapView, markerViewController, mapMarkers;


+ (CGFloat)markerPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}


- (void)gotoLocation
{
    BMCoordinateRegion newRegion;
    newRegion.center.latitude = 47.60445;
    newRegion.center.longitude = -122.34156;
    newRegion.span.latitudeDelta = 0.071872;
    newRegion.span.longitudeDelta = 0.080863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidLoad {
	
	self.mapView.delegate = self ;
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
    
    self.mapMarkers = [[NSMutableArray alloc] initWithCapacity:2];
    
	SeattleMarker *sMarker = [[SeattleMarker alloc] init];
    [self.mapMarkers insertObject:sMarker atIndex:kSeattleMarkerIndex];
    [sMarker release];
    
    SpaceNeedleMarker *needleMarker = [[SpaceNeedleMarker alloc] init];
    [self.mapMarkers insertObject:needleMarker atIndex:kSpaceNeedleMarkerIndex];
    [needleMarker release];
    
    [self gotoLocation];    
}


- (void)viewDidUnload
{
    self.mapMarkers = nil;
    self.markerViewController = nil;
    self.mapView = nil;
}


- (void)dealloc {
	[mapView release];
	[markerViewController release];
	[mapMarkers release];
    [super dealloc];
}

#pragma mark -
#pragma mark ButtonActions

- (IBAction)cityAction:(id)sender
{
    [self gotoLocation];
    
    [self.mapView removeMarkers:self.mapView.markers]; 
    
    [self.mapView addMarker:[self.mapMarkers objectAtIndex:kSeattleMarkerIndex]];
}

- (IBAction)needleAction:(id)sender
{
    [self gotoLocation];
    [self.mapView removeMarkers:self.mapView.markers];  
    
    [self.mapView addMarker:[self.mapMarkers objectAtIndex:kSpaceNeedleMarkerIndex]];
}

- (IBAction)allAction:(id)sender
{
    [self gotoLocation];
    [self.mapView removeMarkers:self.mapView.markers];  
    
    [self.mapView addMarkers:self.mapMarkers];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)showDetails:(id)sender
{	
    [self.navigationController pushViewController:self.markerViewController animated:YES];
}

- (BMMarkerView *)mapView:(BMMapView *)theMapView viewForMarker:(id <BMMarker>)marker
{
    if ([marker isKindOfClass:[BMUserLocation class]])
        return nil;
    
    if ([marker isKindOfClass:[SpaceNeedleMarker class]]) 
    {
        static NSString* SpaceNeedleMarkerIdentifier = @"spaceNeedleMarkerIdentifier";
        BMMarkerView* pinView = (BMMarkerView *)
		[mapView dequeueReusableMarkerViewWithIdentifier:SpaceNeedleMarkerIdentifier];
        if (!pinView)
        {
            BMPushpinView* customPinView = [[[BMPushpinView alloc]
                                             initWithMarker:marker reuseIdentifier:SpaceNeedleMarkerIdentifier] autorelease];
            customPinView.pinColor = BMPushpinColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
			customPinView.enabled=YES ;
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.calloutAccessoryView2 = rightButton;
			
            return customPinView;
        }
        else
        {
            pinView.marker= marker;
        }
        return pinView;
    }
    else if ([marker isKindOfClass:[SeattleMarker class]])   
    {
        static NSString* SeattleMarkerIdentifier = @"seattleMarkerIdentifier";
        BMMarkerView* pinView =
		(BMMarkerView *)[mapView dequeueReusableMarkerViewWithIdentifier:SeattleMarkerIdentifier];
        if (!pinView)
        {
            BMMarkerView *markerView = [[[BMMarkerView alloc] initWithMarker:marker
															 reuseIdentifier:SeattleMarkerIdentifier] autorelease];
            markerView.canShowCallout = YES;
			
            UIImage *cityImage = [UIImage imageNamed:@"pin_Misc.png"];
            
			markerView.enabled=YES ;
            markerView.image = cityImage;
            markerView.opaque = NO;
			markerView.centerOffset = CGPointMake(cityImage.size.width/2-17.0, -cityImage.size.height/2);
			
            UIImageView *seattleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home.png"]];
            markerView.calloutAccessoryView1 = seattleIconView;
            [seattleIconView release];
            
            return markerView;
        }
        else
        {
            pinView.marker= marker;
        }
        return pinView;
    }
    
    return nil;
}


@end
