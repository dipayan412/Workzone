//
//  HomeViewController.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    IBOutlet UIButton *checkinButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *okButton;
    
    IBOutlet UIView *visitInfoView;
    IBOutlet UIView *countryCityInsertView;
    
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *totalVisitLabel;
    IBOutlet UILabel *lastVisitLabel;
    
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *cityField;
    
    IBOutlet UITableView *containerTableView;
    
    IBOutlet MKMapView *mapView;
    
    CLLocationManager *userLocationManager;
}

-(IBAction)checkin:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;
-(IBAction)okButtonAction:(id)sender;

-(void)showCheckinButton;
-(void)hideCheckinButton;

@end
