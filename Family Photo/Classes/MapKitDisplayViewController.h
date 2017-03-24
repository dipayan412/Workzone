//
//  MapKitDisplayViewController.h
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"
#import <MapKit/MKAnnotation.h>
#import "DisplayMap.h"

@class DisplayMap;

@protocol locationUpdated <NSObject>

-(void)sendLocationDetails:(NSString *)title:(double)lng:(double)lat;

@end

@interface MapKitDisplayViewController : UIViewController <
    MKMapViewDelegate,
    CLLocationManagerDelegate, 
    UITextFieldDelegate, 
    UITableViewDelegate, 
    UITableViewDataSource,
    UISearchBarDelegate>
{
    IBOutlet MKMapView *locationMapView;
    IBOutlet UITableView *locationsTable;
    IBOutlet UISegmentedControl *viewSelectionControl;
    UISearchBar *locationSearchBar;
    
    CLLocationManager *locationManager;
    NSMutableData *responseData;
    
    BOOL locationFound;
    
    UITextField * nameField;
    NSString *subtitle;
    id<locationUpdated> locObj;        // call back delegate
    
    NSString *mode;
    NSString *locTitle;
    NSString *locDes;
    
    CLGeocoder *geocoder;
    
    UIAlertView *loadingView;
    
    NSMutableArray *annotations;
}

@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) id<locationUpdated> locObj;
@property (nonatomic, retain) NSString *mode;
@property (nonatomic, retain) NSString *locTitle;
@property (nonatomic, retain) NSString *locDes;
@property (nonatomic, assign) CLLocationCoordinate2D coordonate;

-(IBAction)changeView:(UISegmentedControl*)sender;

@end
