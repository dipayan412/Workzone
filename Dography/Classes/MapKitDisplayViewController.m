//
//  MapKitDisplayViewController.m
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import "MapKitDisplayViewController.h"
#import "DisplayMap.h"
#import "JSON.h"
#import "NearbyLocation.h"
#import "UINavigationController+Operations.h"

@interface MapKitDisplayViewController()<UIAlertViewDelegate>
{
    UIAlertView *failureConnectionAlert;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSArray *sortedLocations;

@end

@implementation MapKitDisplayViewController

@synthesize subtitle;
@synthesize locObj;
@synthesize mode;
@synthesize locDes;
@synthesize locTitle;
@synthesize currentLocation;
@synthesize coordonate;
@synthesize sortedLocations;

int count_times; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.navigationController setNavigationBarHidden:NO];
    
//    self.title = @"Nearby Locations";
    
    CGRect frame = CGRectMake(0, 0, 210, 44);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        frame = CGRectMake(0, 0, 530, 44);
    }
    
    locationSearchBar = [[UISearchBar alloc] initWithFrame:frame];
    locationSearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    locationSearchBar.placeholder = @"Search nearby";
    locationSearchBar.tintColor = [UIColor colorWithRed:(85.0f/255.0f) green:(85.0f/255.0f) blue:(85.0f/255.0f) alpha:1.0f];
    locationSearchBar.delegate = self;
    
    self.navigationItem.titleView = locationSearchBar;
    
    loadingView = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@"Loading nearby locations..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationFound = NO;
    [locationManager startUpdatingLocation];
    
    responseData = [[NSMutableData alloc] init];
    
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)
    {
        viewSelectionControl.tintColor = [UIColor whiteColor];
    }
    
    count_times = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    locationMapView.hidden = YES;
    locationsTable.hidden = NO;
    
//    self.navigationItem.hidesBackButton = YES;
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *pinView = nil; 

	if(annotation != locationMapView.userLocation) 
	{
        DisplayMap *ann = (DisplayMap*)annotation;
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[locationMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil )
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }

		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        iconView.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.7f];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.image = ann.icon;
        
        pinView.leftCalloutAccessoryView = iconView;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    } 
	else
    {
		[locationMapView.userLocation setTitle:@"I am here"];
	}
	return pinView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!locationFound && abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120)
    {     
        self.currentLocation = newLocation;
        
        [self getNearByLocations];
        
        [locationManager stopUpdatingLocation];
        
        locationFound = YES;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.7f, 0.7f);
        MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
        [locationMapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Location service disabled"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)getNearByLocations
{
    [locationMapView removeAnnotations:annotations];
    [locationsTable reloadData];
    
    [loadingView show];
    
    NSURLConnection *connection;
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json"];
    [urlStr appendFormat:@"?location=%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    [urlStr appendFormat:@"&keyword=%@", locationSearchBar.text];
    [urlStr appendFormat:@"&rankby=distance"];
    [urlStr appendFormat:@"&types=(accounting|airport|amusement_park|aquarium|art_gallery|atm|bakery|bank|bar|beauty_salon|bicycle_store|book_store|bowling_alley|bus_station|cafe|campground|car_dealer|car_rental|car_repair|car_wash|casino|cemetery|church|city_hall|clothing_store|convenience_store|courthouse|dentist|department_store|doctor|electrician|electronics_store|embassy|establishment|finance|fire_station|florist|food|funeral_home|furniture_store|gas_station|general_contractor|grocery_or_supermarket|gym|hair_care|hardware_store|health|hindu_temple|home_goods_store|hospital|insurance_agency|jewelry_store|laundry|lawyer|library|liquor_store|local_government_office|locksmith|lodging|meal_delivery|meal_takeaway|mosque|movie_rental|movie_theater|moving_company|museum|night_club|painter|park|parking|pet_store|pharmacy|physiotherapist|place_of_worship|plumber|police|post_office|real_estate_agency|restaurant|roofing_contractor|rv_park|school|shoe_store|shopping_mall|spa|stadium|storage|store|subway_station|synagogue|taxi_stand|train_station|travel_agency|university|veterinary_care|zoo|administrative_area_level_1|administrative_area_level_2|administrative_area_level_3|colloquial_area|country|floor|geocode|intersection|locality|natural_feature|neighborhood|political|point_of_interest|post_box|postal_code|postal_code_prefix|postal_town|premise|room|route|street_address|street_number|sublocality|sublocality_level_4|sublocality_level_5|sublocality_level_3|sublocality_level_2|sublocality_level_1|subpremise|transit_station)"];
    [urlStr appendFormat:@"&sensor=false"];
    [urlStr appendFormat:@"&key=AIzaSyDRtsBwygK8h05I_mfhLXUm692c2HOiQg0"];
    
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:str] 
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"error==%@",error);
    [loadingView dismissWithClickedButtonIndex:0 animated:YES];
    
    failureConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load locations" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failureConnectionAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str); 
    
    NSDictionary *dict = [str JSONValue];
   
    NSDictionary *dict1 = [dict valueForKey:@"results"];
    
    NSMutableArray *latitute = [[[dict1 valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"];
    NSMutableArray *longitute = [[[dict1 valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"];
    NSMutableArray *name = [dict1 valueForKey:@"name"];
    NSMutableArray *description = [dict1  valueForKey:@"vicinity"];
    NSMutableArray *iconURLs = [dict1 valueForKey:@"icon"];
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [latitute count]; i++)
    {
        NearbyLocation *loc = [[NearbyLocation alloc] init];
        loc.longitude = [[longitute objectAtIndex:i] floatValue];
        loc.latitude = [[latitute objectAtIndex:i] floatValue];
        loc.name = [name objectAtIndex:i];
        loc.vicinity = [description objectAtIndex:i];
        loc.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[iconURLs objectAtIndex:i]]]];
        
        [locations addObject:loc];
        
        DisplayMap *a = [[DisplayMap alloc] init]; 
        a.title = loc.name;
        a.subtitle = loc.vicinity; 
        a.coordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude); 
        a.icon = loc.icon;
        
        [annotations addObject:a];
        [locationMapView addAnnotation:a];
    }
    
    self.sortedLocations = [locations sortedArrayUsingSelector:@selector(compareLocationByName:)];
    
    [locationsTable reloadData];
    
    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == failureConnectionAlert)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DisplayMap *ann = view.annotation;
    
    if (locObj)
    {
        [locObj sendLocationDetails:ann.title :ann.coordinate.latitude :ann.coordinate.longitude];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0)
{
      NSLog(@"%@", view.annotation.title );
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select location";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sortedLocations)
    {
        return sortedLocations.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 0;
    }
    
    NearbyLocation *loc = [sortedLocations objectAtIndex:indexPath.row];
    cell.imageView.image = loc.icon;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", loc.name, loc.vicinity];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyLocation *location = [sortedLocations objectAtIndex:indexPath.row];
    
    if (locObj)
    {
        [locObj sendLocationDetails:location.name :location.latitude :location.longitude];
    }
}

-(IBAction)changeView:(UISegmentedControl*)sender
{
    locationsTable.hidden = sender.selectedSegmentIndex != 0;
    locationMapView.hidden = sender.selectedSegmentIndex != 1;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    locationSearchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    locationSearchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [locationSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [locationSearchBar resignFirstResponder];
    [self getNearByLocations];
}

@end
