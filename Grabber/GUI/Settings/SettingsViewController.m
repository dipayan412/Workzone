//
//  SettingsViewController.m
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SettingsViewController.h"
#import "CommonSwitchCell.h"
#import "ManageStoresViewController.h"
#import "CreateShopViewController.h"
#import "BecomeMerchantCell.h"
#import "ShopListViewController.h"
#import "ProfilePicCell.h"

@interface SettingsViewController () <CommonSwitchCellDelegate, BecomeMerchantCellDelegate, UIAlertViewDelegate>
{
    ProfilePicCell *topCell;
    
    BecomeMerchantCell *becomeMerchantCell;
    CommonSwitchCell *merchantCell;
    CommonSwitchCell *beaconCell;
    CommonSwitchCell *emailCell;
    CommonSwitchCell *socialCell;
}

@end

@implementation SettingsViewController

@synthesize drawerViewDelegate;

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
    
    self.navigationItem.title = @"SETTINGS";
    
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
            if([UserDefaultsManager isUserMerchant])
            {
                return merchantCell;
            }
            else
            {
                return becomeMerchantCell;
            }
            
        case 2:
            return beaconCell;
            
        case 3:
            return emailCell;
            
        case 4:
            return socialCell;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 140;
    }
    
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![UserDefaultsManager isUserMerchant])
    {
        if(indexPath.row == 1)
        {
            ShopListViewController *vc = [[ShopListViewController alloc] initWithNibName:@"ShopListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
            CreateShopViewController *vc1 = [[CreateShopViewController alloc] initWithNibName:@"CreateShopViewController" bundle:nil];
            [self.navigationController pushViewController:vc1 animated:YES];
        }
    }
}

-(void)cellConfiguration
{
    topCell = [[ProfilePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.accessoryType = UITableViewCellAccessoryNone;
    topCell.proPicImageView.image = [UIImage imageNamed:@"ProPicIcon.png"];
    
    becomeMerchantCell = [[BecomeMerchantCell alloc] init];
    becomeMerchantCell.delegate = self;
    
    merchantCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isMerchantModeOn] withTitle:@"Merchant Mode" withSubtitle:[UserDefaultsManager isMerchantModeOn] ? @"YES" : @"NO" withCellTypes:kMerchantCell];
    merchantCell.delegate = self;
    
    beaconCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isBeaconsEnabledOn] withTitle:@"Beacons Enabled" withSubtitle:[UserDefaultsManager isBeaconsEnabledOn] ? @"YES" : @"NO" withCellTypes:kBeaconCell];
    beaconCell.delegate = self;
    
    emailCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isEmailAlertsOn] withTitle:@"Email Alerts" withSubtitle:[UserDefaultsManager isEmailAlertsOn] ? @"YES" : @"NO" withCellTypes:kEmailCell];
    emailCell.delegate = self;
    
    socialCell = [[CommonSwitchCell alloc] initWithValue:[UserDefaultsManager isSocialShareOn] withTitle:@"Social Shares" withSubtitle:[UserDefaultsManager isSocialShareOn] ? @"YES" : @"NO" withCellTypes:kSocialCell];
    socialCell.delegate = self;
    
    [containerTableView reloadData];
}

-(void)switchValueChangedTo:(BOOL)value forCellType:(kCellTypes)_type
{
    switch (_type)
    {
        case kMerchantCell:
            merchantCell.subtitleString = merchantCell.fieldSwitch.isOn ? @"YES" : @"NO";
            break;
            
        case kBeaconCell:
            beaconCell.subtitleString = beaconCell.fieldSwitch.isOn ? @"YES" : @"NO";
            break;
            
        case kEmailCell:
            emailCell.subtitleString = emailCell.fieldSwitch.isOn ? @"YES" : @"NO";
            break;
            
        case kSocialCell:
            socialCell.subtitleString = socialCell.fieldSwitch.isOn ? @"YES" : @"NO";
            break;
            
        default:
            break;
    }
    [containerTableView reloadData];
}

-(void)becomeMerchantButtonActionDelegateMethod
{
//    [UserDefaultsManager setUserMerchant:YES];
//    [UserDefaultsManager setMerchantModeOn:YES];
    [self gotoManageStores];
}

-(void)gotoManageStores
{
    
}

-(IBAction)saveButtonAction:(UIButton*)sender
{
    [UserDefaultsManager setMerchantModeOn:merchantCell.fieldSwitch.isOn];
    [UserDefaultsManager setBeaconsEnabledOn:beaconCell.fieldSwitch.isOn];
    [UserDefaultsManager setEmailAlertsOn:emailCell.fieldSwitch.isOn];
    [UserDefaultsManager setSocialShareOn:socialCell.fieldSwitch.isOn];
    
//    if([UserDefaultsManager isBeaconsEnabledOn])
//    {
//        [[PromoScanner getInstance] startUpdatingLocation];
//    }
//    else
//    {
//        [[PromoScanner getInstance] stopUpdateingLocation];
//    }
    [[PromoScanner getInstance] startPromoScanner];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Changes Saved"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)drawViewAction:(id)sender
{
//    if (self.drawerViewDelegate)
//    {
//        [self.drawerViewDelegate showDrawerView];
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
