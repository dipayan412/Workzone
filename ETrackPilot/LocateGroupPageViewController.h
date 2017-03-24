//
//  LocateGroupPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"

@interface LocateGroupPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet MKMapView *locateGroupMapView;
    IBOutlet UITableView *groupLocationTableView;
    
    CLLocationManager *userLocationManager;

    NSMutableArray *lats;
    NSMutableArray *lngs;
    NSMutableArray *address;
    NSMutableArray *driverName;
    NSMutableArray *eventDate;
    NSMutableArray *icons;
    NSMutableArray *deviceIds;
}

@end
