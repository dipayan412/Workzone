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
//  BMMapViewDynamicViewController.m
//  BMMapViewDynamic

#import "BMMapViewDynamicViewController.h"

@implementation BMMapViewDynamicViewController
@synthesize mapView ;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.mapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	self.mapView.delegate = self ;
	[self.view addSubview:self.mapView];
	
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	BMCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
    [self.mapView setRegion:newRegion animated:NO];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[mapView release];
    [super dealloc];
}

@end
