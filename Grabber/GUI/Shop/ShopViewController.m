//
//  ShopViewController.m
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ShopViewController.h"
#import "CreatePromoViewController.h"
#import "ShopListViewController.h"
#import "PromoListViewController.h"
#import "inputTextCell.h"
#import "ShopCreateLocationCell.h"
#import "PromoListViewController.h"
#import "CreateStoreTopCell.h"
#import "CustomMarker.h"

@interface ShopViewController () <BMMapViewDelegate>
{
    CreateStoreTopCell *topCell;
    
    inputTextCell *storeNameCell;
    inputTextCell *typeCell;
    inputTextCell *descriptionCell;
    ShopCreateLocationCell *locationCell;
}

@end

@implementation ShopViewController

@synthesize shopObject;

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
    
    self.navigationItem.title = shopObject.shopName;
    shopNameTextField.text = shopObject.shopName;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CreatePromoBG.png"]];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableView.backgroundColor = [UIColor clearColor];
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        containerTableView.scrollEnabled = YES;
    }
    else
    {
        containerTableView.scrollEnabled = NO;
    }
    
    [self cellConfiguration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return topCell;
            
        case 1:
            return storeNameCell;
            
        case 2:
            return typeCell;
            
        case 3:
            return locationCell;
            
        case 4:
            return descriptionCell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 120.0f;
    }
    if(indexPath.row == 3)
    {
        return 140.0f;
    }
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)cellConfiguration
{
    topCell = [[CreateStoreTopCell alloc] init];
    topCell.storeNameField.text = shopObject.shopName;
    topCell.storeNameField.enabled = NO;
    
    storeNameCell = [[inputTextCell alloc] initWithIsDescription:NO];
    storeNameCell.fieldTitleLabel.text = @"Store Name";
    storeNameCell.inputField.text = shopObject.shopName;
    storeNameCell.inputField.tag = 0;
    storeNameCell.inputField.returnKeyType = UIReturnKeyNext;
    [storeNameCell.inputField setEnabled:NO];
    storeNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    typeCell = [[inputTextCell alloc] initWithIsDescription:NO];
    typeCell.fieldTitleLabel.text = @"iBeacon Id";
    typeCell.inputField.text = shopObject.shopBeaconId;
    typeCell.inputField.tag = 1;
    typeCell.inputField.returnKeyType = UIReturnKeyNext;
    [typeCell.inputField setEnabled:NO];
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    descriptionCell = [[inputTextCell alloc] initWithIsDescription:YES];
    descriptionCell.fieldTitleLabel.text = @"Description";
    descriptionCell.inputTextView.text = @"";
    descriptionCell.inputTextView.returnKeyType = UIReturnKeyDone;
    [descriptionCell.inputTextView setEditable:NO];
    descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    locationCell = [[ShopCreateLocationCell alloc] init];
    locationCell.locationCellName.text = @"Location";
    locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    locationCell.locationMapView.delegate = self;
    
    BMCoordinateRegion newRegion;
    newRegion.center.latitude = shopObject.latitude;
    newRegion.center.longitude = shopObject.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    NSLog(@"lat %f lng %f",shopObject.latitude,shopObject.longitude);
    [locationCell.locationMapView setRegion:newRegion animated:NO];
    
    CustomMarker *marker = [[CustomMarker alloc] init];
    marker.latitude = [NSNumber numberWithFloat:shopObject.latitude];
    marker.longitude = [NSNumber numberWithFloat:shopObject.longitude];
    marker.titleStr = shopObject.shopName;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:marker];
    
    [locationCell.locationMapView addMarkers:arr];
    
    [containerTableView reloadData];
}

-(BMMarkerView*)mapView:(BMMapView *)mapView viewForMarker:(id<BMMarker>)marker
{
    static NSString* SpaceNeedleMarkerIdentifier = @"spaceNeedleMarkerIdentifier";
    BMMarkerView* pinView = (BMMarkerView *)
    [mapView dequeueReusableMarkerViewWithIdentifier:SpaceNeedleMarkerIdentifier];
    if (!pinView)
    {
        BMPushpinView* customPinView = [[BMPushpinView alloc]
                                        initWithMarker:marker
                                        reuseIdentifier:SpaceNeedleMarkerIdentifier];
        
        customPinView.pinColor = BMPushpinColorRed;
        //        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.enabled=YES ;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails)
              forControlEvents:UIControlEventTouchUpInside];
//        customPinView.calloutAccessoryView2 = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.marker= marker;
    }
    return pinView;
}

-(void)showDetails
{
    
}

-(IBAction)promoButtonAction:(UIButton*)btn
{
    PromoListViewController *vc = [[PromoListViewController alloc] initWithNibName:@"PromoListViewController" bundle:nil];
    [self changeBackbuttonTitle];
    vc.shopObject = shopObject;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeBackbuttonTitle
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

@end
