//
//  SearchLocationViewController.m
//  Grabber
//
//  Created by World on 3/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SearchLocationViewController.h"

@interface SearchLocationViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    CLLocation *userLocation;
    NSMutableArray *locationArray;
    UIAlertView *loadingAlert;
}
@property (nonatomic, retain) ASIHTTPRequest *searchLocationRequest;

@end

@implementation SearchLocationViewController

@synthesize searchLocationRequest;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"SEARCH LOCATION";
    
    userLocationManeger = [[CLLocationManager alloc] init];
    userLocationManeger.delegate = self;
    [userLocationManeger startUpdatingLocation];
    
    locationArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)searchLocationOperation
{
    [locationArray removeAllObjects];
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json"];
    [urlStr appendFormat:@"?location=%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    [urlStr appendFormat:@"&keyword=%@",locationSearchBar.text];
    [urlStr appendFormat:@"&rankby=distance"];
    [urlStr appendFormat:@"&types=(accounting|airport|amusement_park|aquarium|art_gallery|atm|bakery|bank|bar|beauty_salon|bicycle_store|book_store|bowling_alley|bus_station|cafe|campground|car_dealer|car_rental|car_repair|car_wash|casino|cemetery|church|city_hall|clothing_store|convenience_store|courthouse|dentist|department_store|doctor|electrician|electronics_store|embassy|establishment|finance|fire_station|florist|food|funeral_home|furniture_store|gas_station|general_contractor|grocery_or_supermarket|gym|hair_care|hardware_store|health|hindu_temple|home_goods_store|hospital|insurance_agency|jewelry_store|laundry|lawyer|library|liquor_store|local_government_office|locksmith|lodging|meal_delivery|meal_takeaway|mosque|movie_rental|movie_theater|moving_company|museum|night_club|painter|park|parking|pet_store|pharmacy|physiotherapist|place_of_worship|plumber|police|post_office|real_estate_agency|restaurant|roofing_contractor|rv_park|school|shoe_store|shopping_mall|spa|stadium|storage|store|subway_station|synagogue|taxi_stand|train_station|travel_agency|university|veterinary_care|zoo|administrative_area_level_1|administrative_area_level_2|administrative_area_level_3|colloquial_area|country|floor|geocode|intersection|locality|natural_feature|neighborhood|political|point_of_interest|post_box|postal_code|postal_code_prefix|postal_town|premise|room|route|street_address|street_number|sublocality|sublocality_level_4|sublocality_level_5|sublocality_level_3|sublocality_level_2|sublocality_level_1|subpremise|transit_station)"];
    [urlStr appendFormat:@"&sensor=false"];
    [urlStr appendFormat:@"&key=AIzaSyDRtsBwygK8h05I_mfhLXUm692c2HOiQg0"];
    NSLog(@"request %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.searchLocationRequest = [ASIHTTPRequest requestWithURL:url];
    self.searchLocationRequest.delegate = self;
    [self.searchLocationRequest startAsynchronous];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    [loadingAlert show];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSArray *resultsArray = [responseObject objectForKey:@"results"];
    NSLog(@"response google api --> %@",resultsArray);
    for(int i = 0; i < resultsArray.count; i++)
    {
        LocationObject *locationObject = [[LocationObject alloc] init];
        
        locationObject.locationLatitude = [[[[[resultsArray objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"]        objectForKey:@"lat"] floatValue];
        locationObject.locationLongitude = [[[[[resultsArray objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        
        locationObject.locationIconUrl = [[resultsArray objectAtIndex:i] objectForKey:@"icon"];
        locationObject.locationName = [[resultsArray objectAtIndex:i] objectForKey:@"name"];
        locationObject.locationAddress = [[resultsArray objectAtIndex:i] objectForKey:@"vicinity"];
        locationObject.locationIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:locationObject.locationIconUrl]];
        
        [locationArray addObject:locationObject];
    }
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [containerTableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:[request.error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    userLocation = [locations lastObject];
    [self searchLocationOperation];
    [userLocationManeger stopUpdatingLocation];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"locationId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    LocationObject *locationObject = [locationArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:locationObject.locationIconData];
    cell.textLabel.text = locationObject.locationName;
    cell.detailTextLabel.text = locationObject.locationAddress;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LocationObject *locationObject = [locationArray objectAtIndex:indexPath.row];
    if(delegate)
    {
        [delegate locationSelected:locationObject];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location selected"
                                                    message:[NSString stringWithFormat:@"Selected location is %@",locationObject.locationName]
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:@"Take it",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchLocationOperation];
    [self.view endEditing:YES];
}

@end
