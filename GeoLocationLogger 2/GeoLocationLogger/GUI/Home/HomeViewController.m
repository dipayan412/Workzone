//
//  HomeViewController.m
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "CheckInCell.h"
#import "SettingsViewController.h"

@interface HomeViewController ()
{
    CLLocation *userLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (nonatomic, retain) NSArray *gllVisitArray;

@end

@implementation HomeViewController

@synthesize gllVisitArray;

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
    
    self.navigationItem.title = @"my Position";
    
    self.view.backgroundColor = kApplicationBackground;
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65.0f / 255.0f green:52.0f/255.0f blue:52.0f / 255.0f alpha:1.0f];
    }
    
    userLocationManager = [[CLLocationManager alloc] init];
    userLocationManager.delegate = self;
    geocoder = [[CLGeocoder alloc] init];
    
    visitInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"visitInfoBG.png"]];
    
    countryCityInsertView.frame = CGRectMake(-320, 90, 320, 146);
    [self.view addSubview:countryCityInsertView];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
    [settingsButton sizeToFit];
    [settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)settingsButtonAction
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mapView.showsUserLocation = YES;
    
    [userLocationManager startUpdatingLocation];
    
    [self fetchGllVisitList];
    [containerTableView reloadData];
    
    if (self.gllVisitArray)
    {
        GLLVisit *lastVisit = [self.gllVisitArray lastObject];
        locationLabel.text = [NSString stringWithFormat:@"%@, %@", lastVisit.city, lastVisit.country];
        
        int totalVisit = [self countVisitByCountry:lastVisit.country];
        totalVisitLabel.text = [NSString stringWithFormat:@"Total visit: %d", totalVisit];
        
        NSDate *lastVisitDate = [self lastVisitByCountry:lastVisit.country];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"dd/MM/yyyy";
        
        lastVisitLabel.text = [NSString stringWithFormat:@"Last: %@",[df stringFromDate:lastVisitDate]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (userLocation == nil)
    {
        userLocation = newLocation;
        MKCoordinateSpan span = MKCoordinateSpanMake(1.0f, 1.0f);
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        mapView.region = region;
        [userLocationManager stopUpdatingLocation];
        
        [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0)
            {
                placemark = [placemarks lastObject];

                countryField.text = [NSString stringWithFormat:@"%@",placemark.country];
                cityField.text = [NSString stringWithFormat:@"%@",placemark.locality];
            }
            else
            {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (userLocation == nil)
    {
        userLocation = [locations objectAtIndex:0];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        mapView.region = region;
        [userLocationManager stopUpdatingLocation];
        
        [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0)
            {
                placemark = [placemarks lastObject];
//                NSLog(@"%@",[NSString stringWithFormat:@"%@ -> %@ -> %@ -> %@ -> %@ ->%@",
//                                     placemark.subThoroughfare, placemark.thoroughfare,
//                                     placemark.postalCode, placemark.locality,
//                                     placemark.administrativeArea,
//                                     placemark.country]);
                countryField.text = [NSString stringWithFormat:@"%@",placemark.country];
                cityField.text = [NSString stringWithFormat:@"%@",placemark.locality];
            }
            else
            {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
}

-(void)fetchGllVisitList
{
    NSError *error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if(fetchedResult.count > 0)
    {
        self.gllVisitArray = fetchedResult;
    }
    else
    {
        self.gllVisitArray = nil;
    }
}

-(NSDate*)lastVisitByCountry:(NSString*)country
{
    NSError *error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.country LIKE %@", country];
    [fetchRequest setPredicate:predicate1];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    GLLVisit *visit = nil;
    if(fetchedResult.count > 0)
    {
        visit = [fetchedResult lastObject];
    }
    return visit.date;
}

-(int)countVisitByCountry:(NSString*)country
{
    NSError *error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.country LIKE %@", country];
    [fetchRequest setPredicate:predicate];

    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedResult.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)hideKeyboard
{
    [countryField resignFirstResponder];
    [cityField resignFirstResponder];
}

-(IBAction)checkin:(id)sender
{
    [self animateInsertCountryView:0];
}

-(IBAction)cancelButtonAction:(id)sender
{
    [self animateInsertCountryView:-320];
    [self hideKeyboard];
}

-(IBAction)okButtonAction:(id)sender
{
    [self animateInsertCountryView:-320];
    [self hideKeyboard];
    
    if(countryField.text == nil || [countryField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Country Name" message:@"Plase fill up country name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(cityField.text == nil || [cityField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter City Name" message:@"Plase fill up city name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self insertCountryCityNameInDBwithCityName:cityField.text Country:countryField.text];
    [self fetchGllVisitList];
    [containerTableView reloadData];
    
    if (self.gllVisitArray)
    {
        GLLVisit *lastVisit = [self.gllVisitArray lastObject];
        locationLabel.text = [NSString stringWithFormat:@"%@, %@", lastVisit.city, lastVisit.country];
        
        int totalVisit = [self countVisitByCountry:lastVisit.country];
        totalVisitLabel.text = [NSString stringWithFormat:@"Total visit: %d", totalVisit];
        
        NSDate *lastVisitDate = [self lastVisitByCountry:lastVisit.country];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yyyy";
        
        lastVisitLabel.text = [NSString stringWithFormat:@"Last: %@",[df stringFromDate:lastVisitDate]];
    }
}

-(void)insertCountryCityNameInDBwithCityName:(NSString*)city Country:(NSString*)country
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    
    NSError *error = nil;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"GLLVisit" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date = %@",[df dateFromString:dateStr]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    static int i = 1;
    i++;
    NSString *countryName;
    NSString *cityName;
    
    if(i % 3 == 0)
    {
        countryName = @"Bangladesh";
        cityName = @"Dhaka";
    }
    else if(i % 3 == 1)
    {
        countryName = @"Spain";
        cityName = @"Barcelona";
    }
    else if(i % 3 == 2)
    {
        countryName = [NSString stringWithFormat:@"%@",country];
        cityName = [NSString stringWithFormat:@"%@",city];
    }
    
    GLLVisit *visit = nil;
    if(fetchedResult.count > 0)
    {
        visit = [fetchedResult objectAtIndex:0];
        
        visit.latitude = [NSNumber numberWithFloat:0];
        visit.longitude = [NSNumber numberWithFloat:0];
        visit.city = cityName;
        visit.country = countryName;
        visit.date = [df dateFromString:dateStr];
        visit.hasPhoto = [NSNumber numberWithBool:NO];
        
        visit.remoteId = [NSNumber numberWithInt:0];
        visit.rowStatus = [NSNumber numberWithInt:0];
    }
    else
    {
        visit = [NSEntityDescription insertNewObjectForEntityForName:@"GLLVisit" inManagedObjectContext:context];
        visit.latitude = [NSNumber numberWithFloat:0];
        visit.longitude = [NSNumber numberWithFloat:0];
        visit.city = cityName;
        visit.country = countryName;
        visit.date = [df dateFromString:dateStr];
        visit.hasPhoto = [NSNumber numberWithBool:NO];
        
        visit.remoteId = [NSNumber numberWithInt:0];
        visit.rowStatus = [NSNumber numberWithInt:0];
    }
    
//    NSLog(@"Date---> %@",dateStr);
    
    [context save:&error];
}

-(NSDate *)addDays:(int)days WithDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd/MM/yyyy";
    if(date != nil)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:days];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *dateRet = [calendar dateByAddingComponents:components toDate:date options:0];
        
        return dateRet;
    }
    NSDate *dates = [NSDate date];
    return [dates earlierDate:[NSDate date]];
}

-(void)animateInsertCountryView:(int)x
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    countryCityInsertView.frame = CGRectMake(x, 90, 320, 146);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    countryCityInsertView.frame = CGRectMake(0, 30, 320, 146);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    countryCityInsertView.frame = CGRectMake(0, 90, 320, 146);
    [UIView commitAnimations];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gllVisitArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"checkinCell";
    
    CheckInCell *cell = (CheckInCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CheckInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    GLLVisit *gv = [gllVisitArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    cell.dateLabel.text = [df stringFromDate:gv.date];
    cell.cityCountryLabel.text = [NSString stringWithFormat:@"%@, %@",gv.city,gv.country];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showCheckinButton
{
    checkinButton.hidden = NO;
}

-(void)hideCheckinButton
{
    checkinButton.hidden = YES;
}

@end
