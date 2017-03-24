//
//  RA_FindUsViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_FindUsViewController.h"
#import <MapKit/MapKit.h>

@interface RA_FindUsViewController ()
{
    float zoom;
    
    GMSCameraPosition *camera;
    GMSMapView *mapView;
    GMSMarker *marker;
    
    UIButton *plusButton;
    UIButton *minusButton;
}

@end

@implementation RA_FindUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        zoom = kGMSMinZoomLevel + 15;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    location = [[CLLocation alloc] initWithLatitude:kLatitude.floatValue longitude:kLongitude.floatValue];
    
    camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude
                                                                 zoom:zoom bearing:30 viewingAngle:40];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 264) camera:camera];
    
    plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.backgroundColor = [UIColor colorWithPatternImage:kPlusButtonIPhone];
    [plusButton addTarget:self action:@selector(plusButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setShowsTouchWhenHighlighted:YES];
    plusButton.frame = CGRectMake(280, 204, 20, 20);
    [mapView addSubview:plusButton];
    
    minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.backgroundColor = [UIColor colorWithPatternImage:kMinusButtonIPhone];
    [minusButton addTarget:self action:@selector(minusButtonAction) forControlEvents:UIControlEventTouchUpInside];
    minusButton.frame = CGRectMake(280, 224, 20, 20);
    [minusButton setShowsTouchWhenHighlighted:YES];
    [mapView addSubview:minusButton];
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    marker.appearAnimation = YES;
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.title = @"The Restaurant";
    marker.snippet = @"Delicious";
    marker.map = mapView;
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    restaurantAddressLabel.numberOfLines = 2;
    
    self.view.backgroundColor = kPageBGColor;
    
    restaurantEmailLabel.text = kEmail;
    restaurantAddressLabel.text = kAddress;
    restaurantNameLabel.text = restaurant_name;
    
    restaurantAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    restaurantAddressLabel.numberOfLines = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateStrings];
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        CGRect frame = mapView.frame;
        frame.size.height = 150;
        mapView.frame = frame;
        
        CGRect frame1 = plusButton.frame;
        frame1.origin.y = 90;
        plusButton.frame = frame1;
        
        CGRect frame2 = minusButton.frame;
        frame2.origin.y = 114;
        minusButton.frame = frame2;
    }
    else if([UIScreen mainScreen].bounds.size.height > 568)
    {
        restaurantAddressLabel.font = restaurantEmailLabel.font = [UIFont systemFontOfSize:18];
        restaurantNameLabel.font = [UIFont boldSystemFontOfSize:21];
        
        CGRect frame = mapView.frame;
        frame.size.height = 400;//self.view.frame.size.height / 2;
        frame.size.width = 768;
        mapView.frame = frame;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            plusButton.backgroundColor = [UIColor colorWithPatternImage:kplusButtonIPadRetina];
            minusButton.backgroundColor = [UIColor colorWithPatternImage:kMinusButtonIPadRetina];
        }
        else
        {
            plusButton.backgroundColor = [UIColor colorWithPatternImage:kPlusButtonIPad];
            minusButton.backgroundColor = [UIColor colorWithPatternImage:kMinusButtonIPad];
        }
        
        CGRect framePlusButton = plusButton.frame;
        framePlusButton.origin.y = 300;
        framePlusButton.origin.x = 700;
        framePlusButton.size.width = 40;
        framePlusButton.size.height = 40;
        plusButton.frame = framePlusButton;
        
        CGRect frameMinusButton = minusButton.frame;
        frameMinusButton.origin.y = 340;
        frameMinusButton.origin.x = 700;
        frameMinusButton.size.width = 40;
        frameMinusButton.size.height = 40;
        minusButton.frame = frameMinusButton;
        
        plusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        minusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        plusButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        minusButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        CGRect frameName = restaurantNameLabel.frame;
        frameName.origin.y = 500;
        restaurantNameLabel.frame = frameName;
        
        CGRect frameAddress = restaurantAddressLabel.frame;
        frameAddress.origin.y = 530;
        frameAddress.size.width = 400;
        restaurantAddressLabel.frame = frameAddress;
        
        CGRect frameEmail = restaurantEmailLabel.frame;
        frameEmail.origin.y = 565;
        restaurantEmailLabel.frame = frameEmail;
        
        CGRect frameCallUs = openNavigatorButton.frame;
        frameCallUs.origin.y = 700;
        openNavigatorButton.frame = frameCallUs;
        
        CGRect frameEmailUs = emailUsButton.frame;
        frameEmailUs.origin.y = 740;
        emailUsButton.frame = frameEmailUs;
    }
    [openNavigatorButton.layer insertSublayer:[RA_UserDefaultsManager getGradientLayerForBounds:openNavigatorButton.bounds] atIndex:0];
    [emailUsButton.layer insertSublayer:[RA_UserDefaultsManager getGradientLayerForBounds:emailUsButton.bounds] atIndex:0];
    openNavigatorButton.titleLabel.textColor = emailUsButton.titleLabel.textColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Method name: openNavigatorAction
 * Description: determines the path from the user location to the restaurant
 * Parameters: button which has been tapped
 */

-(IBAction)openNavigatorAction:(UIButton*)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(kLatitude.floatValue,kLongitude.floatValue);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

/**
 * Method name: emailUsButtonAction
 * Description: open up the mail viewcontroller
 * Parameters: button which has been tapped
 */

-(IBAction)emailUsButtonAction:(UIButton*)sender
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    controller.navigationBar.tintColor = [UIColor whiteColor];
    [controller setToRecipients:[NSArray arrayWithObject:restaurantEmailLabel.text]];
    [controller setSubject:@"My Subject"];
    [controller setMessageBody:@"Hello there." isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
}

/**
 * Method name: updateGoogleMap
 * Description: after every zoom in/out this method will be called and the mapview will be reorganised
 * Parameters: none
 */

-(void)updateGoogleMap
{
    camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                         longitude:location.coordinate.longitude
                                              zoom:zoom];
    [mapView removeFromSuperview];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 264) camera:camera];
    
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        CGRect frame = mapView.frame;
        frame.size.height = 150;
        mapView.frame = frame;
        
        CGRect frame1 = plusButton.frame;
        frame1.origin.y = 90;
        plusButton.frame = frame1;
        
        CGRect frame2 = minusButton.frame;
        frame2.origin.y = 114;
        minusButton.frame = frame2;
    }
    else if([UIScreen mainScreen].bounds.size.height > 568)
    {
        CGRect frame = mapView.frame;
        frame.size.height = 400;//self.view.frame.size.height / 2;
        frame.size.width = 768;
        mapView.frame = frame;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            plusButton.backgroundColor = [UIColor colorWithPatternImage:kplusButtonIPadRetina];
            minusButton.backgroundColor = [UIColor colorWithPatternImage:kMinusButtonIPadRetina];
        }
        else
        {
            plusButton.backgroundColor = [UIColor colorWithPatternImage:kPlusButtonIPad];
            minusButton.backgroundColor = [UIColor colorWithPatternImage:kMinusButtonIPad];
        }
        
        CGRect framePlusButton = plusButton.frame;
        framePlusButton.origin.y = 300;
        framePlusButton.origin.x = 700;
        framePlusButton.size.width = 40;
        framePlusButton.size.height = 40;
        plusButton.frame = framePlusButton;
        
        CGRect frameMinusButton = minusButton.frame;
        frameMinusButton.origin.y = 340;
        frameMinusButton.origin.x = 700;
        frameMinusButton.size.width = 40;
        frameMinusButton.size.height = 40;
        minusButton.frame = frameMinusButton;
        
        plusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        minusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        plusButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        minusButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    }
    
    [mapView addSubview:plusButton];
    [mapView addSubview:minusButton];
    mapView.delegate = self;
    marker.map = mapView;
    [self.view addSubview:mapView];
}

/**
 * Method name: plusButtonAction
 * Description: zoom in the map
 * Parameters: none
 */

-(void)plusButtonAction
{
    if(zoom < kGMSMaxZoomLevel)
    {
        zoom++;
        [self updateGoogleMap];
    }
}

/**
 * Method name: minusButtonAction
 * Description: zoom out the map
 * Parameters: none
 */

-(void)minusButtonAction
{
    if(zoom > kGMSMinZoomLevel)
    {
        zoom--;
        [self updateGoogleMap];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)mapView:(GMSMapView *)_mapView didTapMarker:(GMSMarker *)_marker
{
    mapView.selectedMarker = _marker;
    return YES;
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if(zoom < kGMSMaxZoomLevel)
    {
        zoom = kGMSMaxZoomLevel;
        [self updateGoogleMap];
    }
}

/**
 * Method name: updateStrings
 * Description: update static strings to the language chosen
 * Parameters: none
 */

-(void)updateStrings
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    [openNavigatorButton setTitle:AMLocalizedString(@"kOpenNavigator", nil) forState:UIControlStateNormal];
    [emailUsButton setTitle:AMLocalizedString(@"kEmailUs", nil) forState:UIControlStateNormal];
}

@end
