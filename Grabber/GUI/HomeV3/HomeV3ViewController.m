//
//  HomeV3ViewController.m
//  Grabber
//
//  Created by World on 4/2/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "HomeV3ViewController.h"
#import "AppDelegate.h"
#import "SettingsV2ViewController.h"
#import "SocialSharingUtil.h"
#import "CustomMarker.h"
#import "SelectedPictureViewController.h"
#import "SHHTTPRequest.h"
#import "GrabObject.h"
#import "RA_ImageCache.h"

#define kDescriptipnTextViewPlaceholder @"What did you grabbed?"

@interface HomeV3ViewController () <CLLocationManagerDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, SocialSharingUtilDelegate, MKMapViewDelegate, SHHTTPRequestDelegate>
{
    NSMutableArray *myGrabsArray;
    NSMutableArray *friendsGrabArray;
    NSMutableArray *allGrabsArray;
    
    NSMutableArray *tempArray;
    
    CLLocationManager *userLocationManager;
    CLLocation *userLocation;
    
    NSString *firstname;
    NSString *lastname;
    
    ASIHTTPRequest *getLocationRequest;
    ASIHTTPRequest *addRewardRequest;
    ASIHTTPRequest *getGrabByLocationRequest;
    
    GrabObject *garbToBeShared;
    
    NSString *userLocationString;
    
    enum kAlertTag{
        kAutomatedLocation = 1000,
        kManualLocation,
        kValidation,
        kShareConfirmation
    };
    
    enum kSharingOptions{
        kShareOnFB = 0,
        kShareOnTwitter,
        kShareOnPinterest,
        kShareOnInstagram
    };
    
    UIAlertView *loadingAlert;
    
    NSMutableArray *markersArray;
    NSMutableArray *cellArray;
    
    BOOL isMapViewSelected;
    BOOL isCaptureButtonClicked;
    BOOL isThisMyGrab;
    
    NSIndexPath *selectedImageIndexPath;
    
    NSString *imageUrlStr;
    
    RA_ImageCache *imgCh;
}

@property (nonatomic, retain) UIImage *productImage;
@property (nonatomic, strong) UIDocumentInteractionController *docController;

@end

@implementation HomeV3ViewController

@synthesize productImage;
@synthesize userNameStr;
@synthesize proPic;
@synthesize docController;

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
    
    allGrabsArray = [[NSMutableArray alloc] init];
    myGrabsArray = [[NSMutableArray alloc] init];
    friendsGrabArray = [[NSMutableArray alloc] init];
    
    tempArray = [[NSMutableArray alloc] init];
    
    imgCh = [[RA_ImageCache alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"GRABBER";
    
    [self.navigationItem setHidesBackButton:YES];
//    [closeShareButton setHidden:YES];
    
    userLocationManager = [[CLLocationManager alloc] init];
    userLocationManager.delegate = self;
    [userLocationManager startUpdatingLocation];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:self.proPic];
    img.frame = CGRectMake(0, 0, 32, 32);
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addSubview:img];
    [button addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    mapContainerView.frame = CGRectMake(0, 0, 320, mapContainerView.frame.size.height);
    gridView.frame = CGRectMake(640, 0, 320, gridView.frame.size.height);
    takePhotoView.frame = CGRectMake(320, 0, 320, takePhotoView.frame.size.height);
    
    [self.view insertSubview:mapContainerView atIndex:0];
    [self.view insertSubview:gridView atIndex:0];
    [self.view insertSubview:takePhotoView atIndex:0];
    
    markersArray = [[NSMutableArray alloc] init];
    
    [myMapView setShowsUserLocation:YES];
    myMapView.showsBuildings = YES;
    
    [filterSegmentedControlForMap setTitle:@"You" forSegmentAtIndex:0];
    [filterSegmentedControlForMap setTitle:@"Friends" forSegmentAtIndex:1];
    [filterSegmentedControlForMap setTitle:@"Everyone" forSegmentAtIndex:2];
    
    [filterSegmentedControlForGrid setTitle:@"You" forSegmentAtIndex:0];
    [filterSegmentedControlForGrid setTitle:@"Friends" forSegmentAtIndex:1];
    [filterSegmentedControlForGrid setTitle:@"Everyone" forSegmentAtIndex:2];
    
    markerImageBGView.layer.cornerRadius = 4.0f;
    markerImageBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    markerImageBGView.layer.borderWidth = 0.5f;
    
    sharePhotoBGView.layer.cornerRadius = 4.0f;
    sharePhotoBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sharePhotoBGView.layer.borderWidth = 0.5f;
    
    [shareView setHidden:YES];
    
    UINib *cellNib = [UINib nibWithNibName:@"GridCell" bundle:nil];
    [gridCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    gridCollectionView.backgroundColor = [UIColor whiteColor];
    gridCollectionView.allowsMultipleSelection = NO;
    cellArray = [[NSMutableArray alloc] init];
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@"Sharing on Social Networks. Please wait for a while..."
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        grabLocationLabel.frame = CGRectMake(10, 220, 300, 45);
        grabCreatedTime.frame = CGRectMake(10, 265, 300, 30);
    }
    else
    {
        grabLocationLabel.frame = CGRectMake(10, 240, 300, 45);
        grabCreatedTime.frame = CGRectMake(10, 285, 300, 30);
    }
}

-(IBAction)mapViewButtonAction:(id)sender
{
    [self mapViewButtonActionProcedure];
}

-(void)mapViewButtonActionProcedure
{
    [self hideMarkerSelectionView];
    [self dismissShareView];
    isMapViewSelected = YES;
    [segmentView setHidden:NO];
    [mapViewButton setHidden:NO];
    [gridViewButton setHidden:NO];
    isCaptureButtonClicked = NO;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = mapContainerView.frame;
        frame.origin.x = 0;
        mapContainerView.frame = frame;
        
        CGRect frame1 = gridView.frame;
        frame1.origin.x = 640;
        gridView.frame = frame1;
        
        CGRect frame2 = takePhotoView.frame;
        frame2.origin.x = 320;
        takePhotoView.frame = frame2;
        
        closeShareButton.alpha = 0.0f;
    }];
    
    [captureButton setImage:[UIImage imageNamed:@"CaptureButtonIcon.png"] forState:UIControlStateNormal];
    [captureButton setTitle:@"" forState:UIControlStateNormal];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:self.proPic];
    img.frame = CGRectMake(0, 0, 32, 32);
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addSubview:img];
    [button addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(IBAction)gridViewButtonAction:(id)sender
{
    [self hideMarkerSelectionView];
    [self dismissShareView];
    isMapViewSelected = NO;
    [segmentView setHidden:NO];
    [mapViewButton setHidden:NO];
    [gridViewButton setHidden:NO];
    isCaptureButtonClicked = NO;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = mapContainerView.frame;
        frame.origin.x = -640;
        mapContainerView.frame = frame;
        
        CGRect frame1 = gridView.frame;
        frame1.origin.x = 0;
        gridView.frame = frame1;
        
        CGRect frame2 = takePhotoView.frame;
        frame2.origin.x = -320;
        takePhotoView.frame = frame2;
    }];
    
    [captureButton setImage:[UIImage imageNamed:@"CaptureButtonIcon.png"] forState:UIControlStateNormal];
    [captureButton setTitle:@"" forState:UIControlStateNormal];
}

-(void)updateMap
{
    [userLocationManager stopUpdatingLocation];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = userLocation.coordinate.latitude;
    newRegion.center.longitude = userLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [myMapView setRegion:newRegion animated:NO];
}

#pragma mark - BMMapView delegate stack

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* SpaceNeedleMarkerIdentifier = @"spaceNeedleMarkerIdentifier";
    MKAnnotationView* pinView = (MKAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:SpaceNeedleMarkerIdentifier];
    if (!pinView)
    {
        MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                        initWithAnnotation:annotation
                                        reuseIdentifier:SpaceNeedleMarkerIdentifier];
        
        customPinView.image = [UIImage imageNamed:@"GrabberMarkerIcon.png"];
        customPinView.canShowCallout = NO;
        customPinView.enabled = YES;
        
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self
//                        action:@selector(showDetails)
//              forControlEvents:UIControlEventTouchUpInside];
//        
//        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    
    pinView.image = [UIImage imageNamed:@"GrabberMarkerIcon.png"];
    pinView.annotation= annotation;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    for(int i = 0; i < markersArray.count; i++)
    {
        CustomMarker *v = [markersArray objectAtIndex:i];
        if(v == view.annotation)
        {
            GrabObject *grab = [allGrabsArray objectAtIndex:i];
            
            int time = [grab.grabCreatedDate timeIntervalSinceDate:[NSDate date]];
            time = time * (-1);
            int hour = time / 3600;
            time = time % 3600;
            int min = time / 60;
            
            promoImageView.image = grab.grabImage;
            
            promoDetailsLabel.text = [NSString stringWithFormat:@"%@ grabbed this offer at %@ %d Hours and %d Minutes ago",grab.grabOwnerFbFullName, grab.grabLoaction, hour, min];
            garbToBeShared = grab;
        }
    }
    
    [self showDetails];
}

-(void)showDetails
{
    markerSelectionView.frame = CGRectMake(0, 568, 320, 190);
    markerSelectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MarkerSelectionBGView.png"]];
    [self.view addSubview:markerSelectionView];
    [UIView animateWithDuration:0.3f animations:^{
        if([UIScreen mainScreen].bounds.size.height < 568)
        {
            CGRect frame = markerSelectionView.frame;
            frame.origin.y = 156;
            markerSelectionView.frame = frame;
        }
        else
        {
            CGRect frame = markerSelectionView.frame;
            frame.origin.y = 244;
            markerSelectionView.frame = frame;
        }
    }];
}

-(IBAction)dowArrowButtonAction:(id)sender
{
    [self hideMarkerSelectionView];
}

-(void)hideMarkerSelectionView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = markerSelectionView.frame;
        frame.origin.y = 568;
        markerSelectionView.frame = frame;
    }];
}

#pragma mark - filterSegmentedControlAction

-(IBAction)filterSegmentedControlAction:(UISegmentedControl*)sender
{
    if(sender == filterSegmentedControlForMap)
    {
        [tempArray removeAllObjects];
        if(sender.selectedSegmentIndex == 0)
        {
            [tempArray addObjectsFromArray:myGrabsArray];
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            [tempArray addObjectsFromArray:friendsGrabArray];
        }
        else if(sender.selectedSegmentIndex == 2)
        {
            [tempArray addObjectsFromArray:allGrabsArray];
        }
        
        [markersArray removeAllObjects];
        for(int i = 0; i < tempArray.count; i++)
        {
            GrabObject *grab = [tempArray objectAtIndex:i];
            
            CustomMarker *customMarker = [[CustomMarker alloc] init];
            customMarker.latitude = [NSNumber numberWithFloat:grab.grabLat];
            customMarker.longitude = [NSNumber numberWithFloat:grab.grabLong];
            customMarker.titleStr = grab.grabDescription;
            
            [markersArray addObject:customMarker];
        }
        [myMapView removeAnnotations:[myMapView annotations]];
        [myMapView addAnnotations:markersArray];
    }
    else if(sender == filterSegmentedControlForGrid)
    {
        [tempArray removeAllObjects];
        if(sender.selectedSegmentIndex == 0)
        {
            [tempArray addObjectsFromArray:myGrabsArray];
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            [tempArray addObjectsFromArray:friendsGrabArray];
        }
        else if(sender.selectedSegmentIndex == 2)
        {
            [tempArray addObjectsFromArray:allGrabsArray];
        }
        
        [gridCollectionView reloadData];
    }
    
    [self hideMarkerSelectionView];
}

-(IBAction)disclosureButtonAction:(id)sender
{
    
}

#pragma marks cellConfigurationForArray

-(void)cellConfigurationForArray:(NSMutableArray*)array
{
    [cellArray removeAllObjects];
    for(int i = 0; i < array.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        static NSString *identifier = @"Cell";
        UICollectionViewCell *cell = nil;
        cell = [gridCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if(cell == nil)
        {
            cell = [[UICollectionViewCell alloc] init];
        }
        
        GrabObject *grab = [array objectAtIndex:i];
        
        UIImageView *iv = (UIImageView*)[cell viewWithTag:100];
        iv.image = grab.grabImage;
        [cellArray addObject:cell];
    }
    [gridCollectionView reloadData];
}

-(IBAction)viewButtonAction:(id)sender
{
    GrabObject *grab = [myGrabsArray objectAtIndex:selectedImageIndexPath.row];

    SelectedPictureViewController *vc = [[SelectedPictureViewController alloc] initWithNibName:@"SelectedPictureViewController" bundle:nil];
    vc.selectedPicture = grab.grabImage;
    [self changeBackbuttonTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)sharingButtonAction:(id)sender
{
    GrabObject *grab = [myGrabsArray objectAtIndex:selectedImageIndexPath.row];
    
    int time = [grab.grabCreatedDate timeIntervalSinceDate:[NSDate date]];
    time = time * (-1);
    int hour = time / 3600;
    time = time % 3600;
    int min = time / 60;
    
    promoImageView.image = grab.grabImage;
    promoDetailsLabel.text = [NSString stringWithFormat:@"%@ grabbed this offer at %@ %d Hours and %d Minutes ago",grab.grabOwnerFbFullName, grab.grabLoaction, hour, min];
    [self showDetails];
    garbToBeShared = grab;
}

#pragma mark - UICollectionView delegate stack

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tempArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [cellArray objectAtIndex:indexPath.row];
//    selectedImageIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//    return cell;
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    GrabObject *grab = [tempArray objectAtIndex:indexPath.row];
    
    UIImageView *iv = (UIImageView*)[cell viewWithTag:100];
    iv.image = grab.grabImage;
    return cell;
}

- (void)collectionView:(UICollectionView *)_collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    selectedImageIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//    [cell addSubview:selectionView];
    
    GrabObject *grab = [tempArray objectAtIndex:selectedImageIndexPath.row];
    
    int time = [grab.grabCreatedDate timeIntervalSinceDate:[NSDate date]];
    time = time * (-1);
    int hour = time / 3600;
    time = time % 3600;
    int min = time / 60;
    
    garbToBeShared = grab;
    promoImageView.image = grab.grabImage;
    promoDetailsLabel.text = [NSString stringWithFormat:@"%@ grabbed this offer at %@ %d Hours and %d Minutes ago",grab.grabOwnerFbFullName, grab.grabLoaction, hour, min];
    [self shareFromMarkerProcedure];
}

-(void)settingsButtonAction
{
    SettingsV2ViewController *vc = [[SettingsV2ViewController alloc] initWithNibName:@"SettingsV2ViewController" bundle:nil];
    vc.proPic = self.proPic;
    [self changeBackbuttonTitle];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CLLocationManager delegate stack

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(userLocation == nil)
    {
        userLocation = [locations lastObject];
//        [self getLocationRequest];
        [self getGrabByLocationRequestCall];
    }
    [self updateMap];
    
//    CLLocationCoordinate2D ground = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//    CLLocationCoordinate2D eye = CLLocationCoordinate2DMake(userLocation.coordinate.latitude - 0.002, userLocation.coordinate.longitude);
//    MKMapCamera *mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:ground
//                                                        fromEyeCoordinate:eye
//                                                              eyeAltitude:50];
//    myMapView.camera = mapCamera;
//    myMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
//    myMapView.showsBuildings = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)shareFromMarkerSelectionView:(id)sender
{
    [self shareFromMarkerProcedure];
}

-(void)shareFromMarkerProcedure
{
    isThisMyGrab = NO;
    
    [self hideMarkerSelectionView];
    [self showShareView];
    isMapViewSelected = YES;
    isCaptureButtonClicked = YES;
    closeShareButton.alpha = 1.0f;
    
    [captureButton setImage:nil forState:UIControlStateNormal];
    [captureButton setTitle:@"Share It" forState:UIControlStateNormal];
    [mapViewButton setHidden:YES];
    [gridViewButton setHidden:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = mapContainerView.frame;
        frame.origin.x = -320;
        mapContainerView.frame = frame;
        
        CGRect frame1 = gridView.frame;
        frame1.origin.x = 320;
        gridView.frame = frame1;
        
        CGRect frame2 = takePhotoView.frame;
        frame2.origin.x = 0;
        takePhotoView.frame = frame2;
    }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             descriptionTextView.text = [NSString stringWithFormat:@"%@", garbToBeShared.grabDescription];//[NSString stringWithFormat:@"%@ grabbed this offer",garbToBeShared.grabOwnerFbFullName];
             descriptionTextView.textColor = [UIColor lightGrayColor];
             descriptionTextView.font = [UIFont systemFontOfSize:15.0f];
             numberOfCharecterLabel.text = [NSString stringWithFormat:@"%d",descriptionTextView.text.length];
             productImageView.image = garbToBeShared.grabImage;
             self.productImage = garbToBeShared.grabImage;
         }
     }];
    
    
//    if([garbToBeShared.grabLoaction isEqualToString:@""])
//    {
//       
//    }
    grabLocationLabel.text = [NSString stringWithFormat:@"@%@",garbToBeShared.grabLoaction];
    
    int time = [garbToBeShared.grabCreatedDate timeIntervalSinceDate:[NSDate date]];
    time = time * (-1);
    int hour = time / 3600;
    time = time % 3600;
    int min = time / 60;
    
    grabCreatedTime.text = [NSString stringWithFormat:@"%d Hours and %d Minutes ago",hour, min];
}

#pragma mark captureButtonAction

-(IBAction)captureButtonAction:(UIButton*)sender
{
    if(isCaptureButtonClicked)
    {
        [self shareGrabProcedure];
    }
    else
    {
        [self hideMarkerSelectionView];
        [self dismissShareView];
        isMapViewSelected = YES;
        isCaptureButtonClicked = YES;
        
        descriptionTextView.text = kDescriptipnTextViewPlaceholder;//[NSString stringWithFormat:@"%@ grabbed this offer",[UserDefaultsManager fbUsername]];//@"Whether it is Twitter, Facebook, Yelp or just a post to co-workers, and business officials, aaaaaaa";//
        descriptionTextView.textColor = [UIColor lightGrayColor];
        descriptionTextView.font = [UIFont systemFontOfSize:15.0f];
        
        numberOfCharecterLabel.text = @"0";//[NSString stringWithFormat:@"%d",descriptionTextView.text.length];
        [captureButton setImage:[UIImage imageNamed:@"CaptureButtonIcon.png"] forState:UIControlStateNormal];
        [captureButton setTitle:@"" forState:UIControlStateNormal];
        [mapViewButton setHidden:YES];
        [gridViewButton setHidden:YES];
        closeShareButton.alpha = 1.0f;
        isThisMyGrab = YES;
        
        if(userLocationString)
        {
            grabLocationLabel.text = [NSString stringWithFormat:@"@%@",userLocationString];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = mapContainerView.frame;
            frame.origin.x = -320;
            mapContainerView.frame = frame;
            
            CGRect frame1 = gridView.frame;
            frame1.origin.x = 320;
            gridView.frame = frame1;
            
            CGRect frame2 = takePhotoView.frame;
            frame2.origin.x = 0;
            takePhotoView.frame = frame2;
        }];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(IBAction)closeSharePageButtonAction:(id)sender
{
    [self mapViewButtonActionProcedure];
}

#pragma mark - UIImagePickerController delegate stack

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.productImage = [self imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    NSData *data = UIImagePNGRepresentation(img);
    NSLog(@"original Image length %lu",(unsigned long)[data length]);
    
    NSData *data1 = UIImagePNGRepresentation([self imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)]);
    NSLog(@"shrink Image length %lu",(unsigned long)[data1 length]);
    
    [captureButton setImage:nil forState:UIControlStateNormal];
    [captureButton setTitle:@"Share It" forState:UIControlStateNormal];
    
    isCaptureButtonClicked = YES;
    
    grabCreatedTime.text = @"0 Hours and 0 Minutes ago";
    
    [self showShareView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self mapViewButtonActionProcedure];
}

-(UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    float heightToWidthRatio = image.size.height / image.size.width;
    float scaleFactor = 1;
    if(heightToWidthRatio > 0)
    {
        scaleFactor = newSize.height / image.size.height;
    }
    else
    {
        scaleFactor = newSize.width / image.size.width;
    }
    
    CGSize newSize2 = newSize;
    newSize2.width = image.size.width * scaleFactor;
    newSize2.height = image.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(newSize2);
    [image drawInRect:CGRectMake(0,0,newSize2.width,newSize2.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)getLocationRequest
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:@"http://maps.googleapis.com/maps/api/geocode/json"];
    [urlStr appendFormat:@"?latlng=%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    [urlStr appendFormat:@"&sensor=false"];
    [urlStr appendFormat:@"&language=en"];
    
    getLocationRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    getLocationRequest.delegate = self;
    [getLocationRequest startAsynchronous];
}

#pragma mark - ASIHTTPRequest delegate stack

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(request == getLocationRequest)
    {
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        
        NSArray *tmp = [responseObject objectForKey:@"results"];
        NSDictionary *tmpDic = [tmp objectAtIndex:0];
        NSString *str = [tmpDic objectForKey:@"formatted_address"];
        userLocationString = str;
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#grabber #grabify %@ Grabbed this offer at ",self.userNameStr]];
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:userLocationString];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: atr];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:221.0f/255.0f green:76.0f/255.0f blue:72.0f/255.0f alpha:1.0f] range: NSMakeRange(0, atr.length)];
        
        [str1 appendAttributedString:text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:[NSString stringWithFormat:@"Your current location is at %@",str]
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        alert.tag = kAutomatedLocation;
//        [alert show];
    }
    else if(getGrabByLocationRequest == request)
    {
        
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        
        NSLog(@"responsePost %@",request.responseString);
        
        [allGrabsArray removeAllObjects];
        [friendsGrabArray removeAllObjects];
        [myGrabsArray removeAllObjects];
        
        NSDictionary *grabData = [responseObject objectForKey:@"grabdata"];
        NSArray *allGrabs = [grabData objectForKey:@"allgrabs"];
        NSArray *friendsGrabs = [grabData objectForKey:@"friendsgrab"];
        NSArray *myGrabs = [grabData objectForKey:@"mygrabs"];
        
//        NSArray *arrayOfArray = [NSArray arrayWithObjects:allGrabs, friendsGrabs, myGrabs, nil];
//        NSArray *arrayOfMutableArray = [NSArray arrayWithObjects:allGrabsArray, friendsGrabArray, myGrabsArray, nil];
//        
//        for(int j = 0; j < arrayOfArray.count; j++)
//        {
//            for(int i = 0; i < [[arrayOfArray objectAtIndex:j] count]; i++)
//            {
//                NSDictionary *tmp = [allGrabs objectAtIndex:i];
//                
//                GrabObject *grab = [[GrabObject alloc] init];
//                grab.grabId = [tmp objectForKey:@"_id"];
//                grab.grabDescription = [tmp objectForKey:@"description"];
//                grab.grabOwnerFbId = [tmp objectForKey:@"facebook_username"];
//                grab.grabLat = [[tmp objectForKey:@"lat"] floatValue];
//                grab.grabLong = [[tmp objectForKey:@"lon"] floatValue];
//                grab.grabImage = [imgCh getImage:[tmp objectForKey:@"link"]];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tmp objectForKey:@"link"]]]];
//                grab.grabOwnerUsername = [tmp objectForKey:@"user_name"];
//                
//                [[arrayOfMutableArray objectAtIndex:j] addObject:grab];
//            }
//        }
        
        for(int i = 0; i < allGrabs.count; i++)
        {
            NSDictionary *tmp = [allGrabs objectAtIndex:i];
            
            GrabObject *grab = [[GrabObject alloc] init];
            grab.grabId = [tmp objectForKey:@"_id"];
            grab.grabDescription = [[tmp objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            grab.grabOwnerFbId = [tmp objectForKey:@"facebook_username"];
            grab.grabLat = [[tmp objectForKey:@"lat"] floatValue];
            grab.grabLong = [[tmp objectForKey:@"lon"] floatValue];
            grab.grabImage = [imgCh getImage:[tmp objectForKey:@"link"]];
            grab.grabOwnerUsername = [tmp objectForKey:@"user_name"];
            grab.grabLoaction = [[tmp objectForKey:@"location"] stringByRemovingPercentEncoding];
            grab.grabOwnerFbFullName = [tmp objectForKey:@"facebook_name"];
            
            NSArray *arr = [[tmp objectForKey:@"date"] componentsSeparatedByString:@"."];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [df dateFromString:[arr objectAtIndex:0]];
            grab.grabCreatedDate = date;
            
            [allGrabsArray addObject:grab];
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"grabCreatedDate"
                                                                       ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [allGrabsArray sortedArrayUsingDescriptors:sortDescriptors];
        [allGrabsArray removeAllObjects];
        [allGrabsArray addObjectsFromArray:sortedArray];
        
        for(int i = 0; i < friendsGrabs.count; i++)
        {
            NSDictionary *tmp = [friendsGrabs objectAtIndex:i];
            
            GrabObject *grab = [[GrabObject alloc] init];
            grab.grabId = [tmp objectForKey:@"_id"];
            grab.grabDescription = [[tmp objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            grab.grabOwnerFbId = [tmp objectForKey:@"facebook_username"];
            grab.grabLat = [[tmp objectForKey:@"lat"] floatValue];
            grab.grabLong = [[tmp objectForKey:@"lon"] floatValue];
            grab.grabImage = [imgCh getImage:[tmp objectForKey:@"link"]];
            grab.grabOwnerUsername = [tmp objectForKey:@"user_name"];
            grab.grabLoaction = [[tmp objectForKey:@"location"] stringByRemovingPercentEncoding];
            grab.grabOwnerFbFullName = [tmp objectForKey:@"facebook_name"];
            
            NSArray *arr = [[tmp objectForKey:@"date"] componentsSeparatedByString:@"."];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [df dateFromString:[arr objectAtIndex:0]];
            grab.grabCreatedDate = date;
            
            [friendsGrabArray addObject:grab];
        }
        
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"grabCreatedDate"
                                                                       ascending:NO];
        NSArray *sortDescriptors1 = [NSArray arrayWithObject:sortDescriptor1];
        NSArray *sortedArray1 = [friendsGrabArray sortedArrayUsingDescriptors:sortDescriptors1];
        [friendsGrabArray removeAllObjects];
        [friendsGrabArray addObjectsFromArray:sortedArray1];
        
        for(int i = 0; i < myGrabs.count; i++)
        {
            NSDictionary *tmp = [myGrabs objectAtIndex:i];
            
            GrabObject *grab = [[GrabObject alloc] init];
            grab.grabId = [tmp objectForKey:@"_id"];
            grab.grabDescription = [[tmp objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            grab.grabOwnerFbId = [tmp objectForKey:@"facebook_username"];
            grab.grabLat = [[tmp objectForKey:@"lat"] floatValue];
            grab.grabLong = [[tmp objectForKey:@"lon"] floatValue];
            grab.grabImage = [imgCh getImage:[tmp objectForKey:@"link"]];
            grab.grabOwnerUsername = [tmp objectForKey:@"user_name"];
            grab.grabLoaction = [[tmp objectForKey:@"location"] stringByRemovingPercentEncoding];
            grab.grabOwnerFbFullName = [tmp objectForKey:@"facebook_name"];
            
            NSArray *arr = [[tmp objectForKey:@"date"] componentsSeparatedByString:@"."];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [df dateFromString:[arr objectAtIndex:0]];
            grab.grabCreatedDate = date;
            
            [myGrabsArray addObject:grab];
        }
        
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"grabCreatedDate"
                                                     ascending:NO];
        NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];
        NSArray *sortedArray2 = [myGrabsArray sortedArrayUsingDescriptors:sortDescriptors2];
        [myGrabsArray removeAllObjects];
        [myGrabsArray addObjectsFromArray:sortedArray2];
        
        [markersArray removeAllObjects];
        for(int i = 0; i < myGrabsArray.count; i++)
        {
            GrabObject *grab = [myGrabsArray objectAtIndex:i];
            
            CustomMarker *customMarker = [[CustomMarker alloc] init];
            customMarker.latitude = [NSNumber numberWithFloat:grab.grabLat];
            customMarker.longitude = [NSNumber numberWithFloat:grab.grabLong];
            customMarker.titleStr = grab.grabDescription;
            
            [markersArray addObject:customMarker];
        }
        [myMapView addAnnotations:markersArray];
        
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:myGrabsArray];
//        [self cellConfigurationForArray:tempArray];
        [gridCollectionView reloadData];
        
        [self getLocationRequest];
    }
    else if(addRewardRequest == request)
    {
//        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        NSError *error = nil;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        
        NSLog(@"responsePost %@",request.responseString);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total reward point"
                                                        message:[NSString stringWithFormat:@"%d",[[responseObject objectForKey:@"message"] integerValue]]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = kShareConfirmation;
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self promptForManualLocationInput];
}

-(void)promptForManualLocationInput
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location"
                                                    message:@"Please enter your current location address"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = kManualLocation;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertView delegate stack

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case kAutomatedLocation:{
                
                [self promptForManualLocationInput];
                break;
            }
            case kManualLocation:{
                
                if([[alertView textFieldAtIndex:0].text isEqualToString:@""] || [[[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Please enter valid address"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    alert.tag = kValidation;
                    [alert show];
                }
                else
                {
                    userLocationString = [alertView textFieldAtIndex:0].text;
                    
                    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#grabber #grabify %@ Grabbed this offer at ",self.userNameStr]];
                    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:userLocationString];
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: atr];
                    [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:221.0f/255.0f green:76.0f/255.0f blue:72.0f/255.0f alpha:1.0f] range: NSMakeRange(0, atr.length)];
                    
                    [str1 appendAttributedString:text];
                    
                    [self getGrabByLocationRequestCall];
                }
                
                break;
            }
                
            case kValidation:{
                
                [self promptForManualLocationInput];
                break;
            }
                
            case kShareConfirmation:{
                isCaptureButtonClicked = NO;
                [self mapViewButtonActionProcedure];
            }
                
            default:
                break;
        }
    }
    if(buttonIndex == 1)
    {
        [self getGrabByLocationRequestCall];
    }
}

-(void)getGrabByLocationRequestCall
{
    NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"fbToken %@",token);
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",getGrabByLocationApi];
    [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%@/",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"%f/",userLocation.coordinate.latitude];
    [urlStr appendFormat:@"%f/",userLocation.coordinate.longitude];
    [urlStr appendFormat:@"%@/",@"1000"];
    
    getGrabByLocationRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [getGrabByLocationRequest setDelegate:self];
    [getGrabByLocationRequest startAsynchronous];
}

#pragma mark - UITextView delegate stack

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if([textView.text length] > 100)
    {
        return NO;
    }
    if(![descriptionTextView.text isEqualToString:kDescriptipnTextViewPlaceholder])
    {
        numberOfCharecterLabel.text = [NSString stringWithFormat:@"%d",[descriptionTextView.text length]];
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        [self commitAnimation:-30];
    }
    if([textView.text isEqualToString:kDescriptipnTextViewPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        [self commitAnimation:0];
    }
    if([textView.text isEqualToString:@""])
    {
        textView.text = kDescriptipnTextViewPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)commitAnimation:(int)y
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    
    CGRect frame = shareView.frame;
    frame.origin.y = y;
    shareView.frame = frame;
    
    [UIView commitAnimations];
}

-(void)showShareView
{
    [shareView setHidden:NO];
    
    shareView.alpha = 1.0f;
    shareView.frame = CGRectMake(0, 0, 320, 350);
    
    productImageView.image = self.productImage;
    productImageView.layer.masksToBounds = YES;
    
    [self.view addSubview:shareView];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    img.frame = CGRectMake(-10, 7, 19, 19);
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addSubview:img];
    [button addTarget:self action:@selector(mapViewButtonActionProcedure) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if(isThisMyGrab)
    {
        [descriptionTextView setEditable:YES];
    }
    else
    {
        [descriptionTextView setEditable:NO];
    }
}

-(IBAction)bgTap:(id)sender
{
    [self dismissShareView];
}

-(IBAction)closeButtonAction:(UIButton*)sender
{
    [self dismissShareView];
}

-(void)dismissShareView
{
    [UIView animateWithDuration:0.3f animations:^{
        
        shareView.alpha = 0.0f;
        productImageView.image = nil;
    }];
    [self.view endEditing:YES];
}

-(void)changeBackbuttonTitle
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

-(IBAction)shareButtonAction:(UIButton*)sender
{
    
}

-(void)shareGrabProcedure
{
    if(isThisMyGrab)
    {
        if([descriptionTextView.text isEqualToString:kDescriptipnTextViewPlaceholder])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter some description about your grab"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        else if(userLocation == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please activate GPS"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            
            [userLocationManager startUpdatingLocation];
            [alert show];
            return;
        }
        
        loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading"
                                                  message:@"Saving image in Server"
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        [loadingAlert show];
        
        [self imageUploadOperation];
    }
    else
    {
        [self showShareOptions];
    }
}

-(void)imageUploadOperation
{
    NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"fbToken %@",token);
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",addGrabApi];
    [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%@/",[token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"%@/",[descriptionTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlStr appendFormat:@"%f/",userLocation.coordinate.latitude];
    [urlStr appendFormat:@"%f/",userLocation.coordinate.longitude];
    [urlStr appendFormat:@"%@/",[userLocationString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //description
    //lat  lon
    
    SHHTTPRequest *request = [[SHHTTPRequest alloc] initWithURL:urlStr data:@{@"filedata":self.productImage} delegate:self];
    
    [request initPostRequest];
    
//    [loadingAlert show];
}

-(void)showShareOptions
{
    [self getGrabByLocationRequestCall];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@",descriptionTextView.text];
    if(userLocationString && ![userLocationString isEqualToString:@""])
    {
        [str appendFormat:@" @%@",userLocationString];
    }
    
    SocialSharingUtil *util = [[SocialSharingUtil alloc] initWithViewController:self shareImage:self.productImage imageURL:imageUrlStr shareText:str userLocation:userLocation];
    util.delegate = self;
    [util startSharing];
}

#pragma mark - SHHTTPRequest delegate stack

- (void)request:(SHHTTPRequest *)fetcher didFinishLoadingData:(NSData *)data
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSDictionary *response = [data getDeserializedDictionary];
    NSLog(@"data %@",response);
    NSLog(@"statusCode %ld",(long)fetcher.statusCode);
    
    if(fetcher.statusCode == 200)
    {
        imageUrlStr = [response objectForKey:@"link"];
        [self showShareOptions];
    }
}

- (void)request:(SHHTTPRequest *)fetcher didFailedWithError:(NSError *)error
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"%@", error.description);
}

#pragma mark - UIActionSheet delegate stack

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case kShareOnFB:{
//            if([UserDefaultsManager isFacebookEnabled])
//            {
//                [util shareOnFacebook];
//            }
//            else
//            {
//                [self promptAlertFor:@"Facebook"];
//                return;
//            }
//        }
//            
//            break;
//            
//        case kShareOnTwitter:{
//            if([UserDefaultsManager isTwitterEnabled])
//            {
//                [util shareOnTwitter];
//            }
//            else
//            {
//                [self promptAlertFor:@"Twitter"];
//                return;
//            }
//        }
//            break;
//            
//        case kShareOnPinterest:{
//            if([UserDefaultsManager isPinterestEnabled])
//            {
//                [util shareOnPinterest];
//            }
//            else
//            {
//                [self promptAlertFor:@"Pinterest"];
//                return;
//            }
//        }
//            
//            break;
//            
//        case kShareOnInstagram:{
//            if([UserDefaultsManager isInstagramEnabled])
//            {
//                [util shareOnInstagram];
//            }
//            else
//            {
//                [self promptAlertFor:@"Instagram"];
//                return;
//            }
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
//}

-(void)promptAlertFor:(NSString*)socialNetwork
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"Enable %@ in Profile page",socialNetwork] delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIDocumentInteractionController delegate stack

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    NSLog(@"Left app to share on instagram");
}

#pragma mark - SocialSharingUtilDelegate stack

-(void)openOptionToShareOnInstagramWithImagePath:(NSString *)imagePath
{
    /*
    
    NSString *url = [NSString stringWithFormat:@"instagram://tag?name=TAG"];
    NSURL *instagramURL = [NSURL URLWithString:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    */
//    /*
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    self.docController.delegate = self;
    self.docController.UTI = @"com.instagram.photo";
    
    if (UI_USER_INTERFACE_IDIOM())
    {
        [self.docController presentOpenInMenuFromBarButtonItem:nil animated:YES];
    }
    else
    {
        [self.docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
    }
//     */
}

-(void)totalSharesCompleted:(int)_value
{
    NSLog(@"number of shares %d",_value);
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"%@",baseUrl];
    [urlStr appendFormat:@"%@",addRewardPoinApi];
    [urlStr appendFormat:@"%@/",[UserDefaultsManager sessionToken]];
    [urlStr appendFormat:@"%d/",_value * 10];
    
    addRewardRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    addRewardRequest.delegate = self;
    [addRewardRequest startAsynchronous];
}

@end
