//
//  LocateGroupPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "LocateGroupPageViewController.h"
#import "GroupAnnotation.h"
#import "UserDefaultsManager.h"
#import "AppDelegate.h"
#import "Devices.h"
#import "GroupLocationCell.h"

#define kGroupLocationCellHeight 114.0f

@interface LocateGroupPageViewController ()
{
    NSTimer *timer;
}


@end

@implementation LocateGroupPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        userLocationManager = [[CLLocationManager alloc] init];
        userLocationManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    lats = [[NSMutableArray alloc] init];
    lngs = [[NSMutableArray alloc] init];
    address = [[NSMutableArray alloc] init];
    deviceIds = [[NSMutableArray alloc] init];
    driverName = [[NSMutableArray alloc] init];
    icons = [[NSMutableArray alloc] init];
    eventDate = [[NSMutableArray alloc] init];
    
    [self getMyGroup];
   
    self.title = @"My Group";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    groupLocationTableView.separatorColor = [UIColor grayColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    locateGroupMapView.showsUserLocation = YES;
    
    [userLocationManager startUpdatingLocation];
   
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
//    
//    GroupAnnotation *ann = [[GroupAnnotation alloc] initWithLocation:coordinate title:@"Initial center" subTitle:@""];
//    [locateGroupMapView addAnnotation:ann];
    
}

-(void)viewDidUnload
{
    [timer invalidate];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [locateGroupMapView release];
    [groupLocationTableView release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(1.0f, 1.0f);
    
    locateGroupMapView.region = MKCoordinateRegionMake(location.coordinate, span);
    
    [userLocationManager stopUpdatingLocation];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGroupLocationCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *jobCellId = @"JobCell";
    
    GroupLocationCell *cell = (GroupLocationCell *)[tableView dequeueReusableCellWithIdentifier:jobCellId];
    if(cell == nil)
    {
        cell = [[GroupLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSURL *url = [NSURL URLWithString:[icons objectAtIndex:indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.iconView.image = img;
    
    cell.nameLabel.text = [self getDeviceNameForId:[deviceIds objectAtIndex:indexPath.row]];
    cell.addressLabel.text = [address objectAtIndex:indexPath.row];
    cell.timeLabel.text = [eventDate objectAtIndex:indexPath.row];
    
    return cell;
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    GroupAnnotation *ann = (GroupAnnotation*) annotation;
    if (annotation != locateGroupMapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        
        pinView = (MKPinAnnotationView *)[locateGroupMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if (pinView == nil)
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
//        pinView.pinColor = MKPinAnnotationColorRed;
//        pinView.canShowCallout = YES;
//        pinView.animatesDrop = YES;
        
        NSURL *url = [NSURL URLWithString:[icons objectAtIndex:ann.title.intValue]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        pinView.image = img;
    }
    else
    {
        return nil;
    }
    
    return pinView;
}

-(void)getMyGroup
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"http://etrack.ws/pilot.svc/getMyGroup"];
    [urlStr appendFormat:@"?token=%@",[UserDefaultsManager token]];
    [urlStr appendFormat:@"&lat=%f",[UserDefaultsManager lastLat]];
    [urlStr appendFormat:@"&lng=%f",[UserDefaultsManager lastLng]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *getMyGroupRequest = [ASIHTTPRequest requestWithURL:url];
    
    [getMyGroupRequest startSynchronous];
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"getMyGroup\":%@}",getMyGroupRequest.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        return;
    }
    
    NSArray *getMyGroupArray = [responseObject objectForKey:@"getMyGroup"];
    for (int i = 0; i < getMyGroupArray.count; i++)
    {
        NSDictionary *getMyGroupObject = [getMyGroupArray objectAtIndex:i];
        
        [lats addObject:[getMyGroupObject objectForKey:@"lat"]];
        [lngs addObject:[getMyGroupObject objectForKey:@"lng"]];
        [address addObject:[getMyGroupObject objectForKey:@"address"]];
        [eventDate addObject:[getMyGroupObject  objectForKey:@"evTime"]];
        [icons addObject:[getMyGroupObject objectForKey:@"iconUrl"]];
        [driverName addObject:[getMyGroupObject objectForKey:@"name"]];
        [deviceIds addObject:[getMyGroupObject objectForKey:@"id"]];
    }
    [self updateGroupLocation];
    [groupLocationTableView reloadData];
}

-(void)updateGroupLocation
{
    for (int i = 0; i < lats.count; i++)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[lats objectAtIndex:i] doubleValue], [[lngs objectAtIndex:i] doubleValue]);
        
        GroupAnnotation *ann = [[GroupAnnotation alloc] initWithLocation:coordinate title:[NSString stringWithFormat:@"%d",i] subTitle:[address objectAtIndex:i]];
        [locateGroupMapView addAnnotation:ann];
    }
}

-(NSString*)getDeviceNameForId:(NSString*)deviceId
{
    NSError *error = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.deviceId = %@",deviceId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *fetchedResult = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if(fetchedResult && [fetchedResult count] > 0)
    {
        Devices *device = [fetchedResult objectAtIndex:0];
        return device.name;
    }
    return nil;
}
@end
