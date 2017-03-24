//
//  HomeV2ViewController.m
//  iOS Prototype
//
//  Created by World on 3/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "HomeV2ViewController.h"
#import "ProfileViewController.h"
#import "ManageStoresViewController.h"
#import "SettingsViewController.h"
#import "SignInSignUpViewController.h"
#import "CreditViewController.h"
#import "ShopListViewController.h"
#import "AnalyticsViewController.h"
#import "SocialViewController.h"
#import "HomeCell.h"
#import "OffersViewController.h"
#import "MerchantProfileViewController.h"
#import "PageUnderConstructionViewController.h"

@interface HomeV2ViewController ()
{
    HomeCell *editProfileCell;
    HomeCell *manageStoresCell;
    HomeCell *ManageLocationOffersCell;
    HomeCell *socialPagesCell;
    HomeCell *analyticsCell;
    HomeCell *settingsCell;
    HomeCell *creditsCell;
    
    HomeCell *profileCell;
    HomeCell *offersCell;
    HomeCell *activityCell;
    HomeCell *grabbersCell;
    HomeCell *locationCell;
    HomeCell *reportsCell;
    
    HomeCell *logoutCell;
}

@end

@implementation HomeV2ViewController

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
    
    self.navigationItem.title = @"GRABBER";
    
    [self.navigationItem setHidesBackButton:YES];
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self cellConfiguration];
    
    [[PromoScanner getInstance] startPromoScanner];
    
    if([[FBSession activeSession] isOpen])
    {
        NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbToken %@",token);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [containerTableView reloadData];
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
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UserDefaultsManager isUserMerchant] && [UserDefaultsManager isMerchantModeOn])
    {
        switch (indexPath.row)
        {
            case kEditProfile:
                return editProfileCell;
                
            case kManageStores:
                return manageStoresCell;
                
            case kManageLocationOffers:
                return ManageLocationOffersCell;
                
            case kSocialPages:
                return socialPagesCell;
                
            case kAnalytics:
                return analyticsCell;
                
            case kSettingsMerchant:
                return settingsCell;
                
            case kCredits:
                return creditsCell;
                
            case kLogout:
                return logoutCell;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case kProfile:
                return profileCell;
                
            case kOffers:
                return offersCell;
                
            case kActivity:
                return activityCell;
                
            case kGrabbers:
                return grabbersCell;
                
            case kLocations:
                return locationCell;
                
            case kReports:
                return reportsCell;
                
            case kSettings:
                return settingsCell;
                
            case kLogout:
                return logoutCell;
                
            default:
                break;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([UserDefaultsManager isUserMerchant] && [UserDefaultsManager isMerchantModeOn])
    {
        if(indexPath.row == kEditProfile)
        {
            if([UIScreen mainScreen].bounds.size.height < 568)
            {
                [self changeBackbuttonTitle];
                MerchantProfileViewController *vc = [[MerchantProfileViewController alloc] initWithNibName:@"MerchantProfileViewController_small" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self changeBackbuttonTitle];
                MerchantProfileViewController *vc = [[MerchantProfileViewController alloc] initWithNibName:@"MerchantProfileViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(indexPath.row == kManageStores)
        {
            ShopListViewController *vc = [[ShopListViewController alloc] initWithNibName:@"ShopListViewController" bundle:nil];
            [self changeBackbuttonTitle];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kManageLocationOffers)
        {
            [self changeBackbuttonTitle];
            PageUnderConstructionViewController *vc = [[PageUnderConstructionViewController alloc] initWithNibName:@"PageUnderConstructionViewController" bundle:nil WithTitle:@"MANAGE LOCATION OFFERS"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kSocialPages)
        {
            SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
            [self changeBackbuttonTitle];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kAnalytics)
        {
            if([UIScreen mainScreen].bounds.size.height < 568)
            {
                AnalyticsViewController *vc = [[AnalyticsViewController alloc] initWithNibName:@"AnalyticsViewController_small" bundle:nil];
                [self changeBackbuttonTitle];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                AnalyticsViewController *vc = [[AnalyticsViewController alloc] initWithNibName:@"AnalyticsViewController" bundle:nil];
                [self changeBackbuttonTitle];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(indexPath.row == kSettingsMerchant)
        {
            SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            [self changeBackbuttonTitle];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kCredits)
        {
            if([UIScreen mainScreen].bounds.size.height >= 568)
            {
                CreditViewController *vc = [[CreditViewController alloc] initWithNibName:@"CreditViewController" bundle:nil];
                [self changeBackbuttonTitle];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                CreditViewController *vc = [[CreditViewController alloc] initWithNibName:@"CreditViewController_small" bundle:nil];
                [self changeBackbuttonTitle];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(indexPath.row == kLogoutMerchant)
        {
            [UserDefaultsManager setSessionToken:@""];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
    {
        if(indexPath.row == kProfile)
        {
            [self changeBackbuttonTitle];
            ProfileViewController *vc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kOffers)
        {
            [self changeBackbuttonTitle];
            OffersViewController *vc = [[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kActivity)
        {
            [self changeBackbuttonTitle];
            PageUnderConstructionViewController *vc = [[PageUnderConstructionViewController alloc] initWithNibName:@"PageUnderConstructionViewController" bundle:nil WithTitle:@"ACTIVITY"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kGrabbers)
        {
            [self changeBackbuttonTitle];
            PageUnderConstructionViewController *vc = [[PageUnderConstructionViewController alloc] initWithNibName:@"PageUnderConstructionViewController" bundle:nil WithTitle:@"GRABBERS"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kLocations)
        {
//            [self changeBackbuttonTitle];
//            MapViewController *vc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kReports)
        {
            [self changeBackbuttonTitle];
            PageUnderConstructionViewController *vc = [[PageUnderConstructionViewController alloc] initWithNibName:@"PageUnderConstructionViewController" bundle:nil WithTitle:@"REPORTS"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kSettings)
        {
            SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            [self changeBackbuttonTitle];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == kLogout)
        {
            [UserDefaultsManager setSessionToken:@""];
            [[PromoScanner getInstance] stopUpdateingLocation];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)cellConfiguration
{
    profileCell = [[HomeCell alloc] initWithAccessoryView:NO];
    profileCell.cellImageView.image = [UIImage imageNamed:@"ProfilePicIcon1.png"];
    profileCell.cellName.text = @"Profile";
    
    offersCell = [[HomeCell alloc] initWithAccessoryView:NO];
    offersCell.cellImageView.image = [UIImage imageNamed:@"OffersIcon.png"];
    offersCell.cellName.text = @"Offers";
    
    activityCell = [[HomeCell alloc] initWithAccessoryView:YES];
    activityCell.cellImageView.image = [UIImage imageNamed:@"ActivityIcon.png"];
    activityCell.customAccessoryViewLabelText = @"0";
    activityCell.cellName.text = @"Activity";
    
    grabbersCell = [[HomeCell alloc] initWithAccessoryView:YES];
    grabbersCell.cellImageView.image = [UIImage imageNamed:@"GrabbersIcon.png"];
    grabbersCell.customAccessoryViewLabelText = @"0";
    grabbersCell.cellName.text = @"Grabbers";
    
    locationCell = [[HomeCell alloc] initWithAccessoryView:NO];
    locationCell.cellImageView.image = [UIImage imageNamed:@"LocationsIcon.png"];
    locationCell.cellName.text = @"Locations";
    
    reportsCell = [[HomeCell alloc] initWithAccessoryView:NO];
    reportsCell.cellImageView.image = [UIImage imageNamed:@"ReportsIcon.png"];
    reportsCell.cellName.text = @"Reports";
    
    settingsCell = [[HomeCell alloc] initWithAccessoryView:NO];
    settingsCell.cellImageView.image = [UIImage imageNamed:@"SettingsIcon.png"];
    settingsCell.cellName.text = @"Settings";
    
    
    
    editProfileCell = [[HomeCell alloc] initWithAccessoryView:NO];
    editProfileCell.cellImageView.image = [UIImage imageNamed:@"ProfilePicIcon.png"];
    editProfileCell.cellName.text = @"Edit Profile";
    
    manageStoresCell = [[HomeCell alloc] initWithAccessoryView:NO];
    manageStoresCell.cellImageView.image = [UIImage imageNamed:@"ManageStoreIcon.png"];
    manageStoresCell.cellName.text = @"Manage Stores";
    
    ManageLocationOffersCell = [[HomeCell alloc] initWithAccessoryView:YES];
    ManageLocationOffersCell.cellImageView.image = [UIImage imageNamed:@"ManageLocationOffersIcon.png"];
    ManageLocationOffersCell.cellName.text = @"Manage Location Offers";
    ManageLocationOffersCell.customAccessoryViewLabelText = @"0";
    
    socialPagesCell = [[HomeCell alloc] initWithAccessoryView:NO];
    socialPagesCell.cellImageView.image = [UIImage imageNamed:@"SocialPagesIcon.png"];
    socialPagesCell.cellName.text = @"Social Pages";
    
    analyticsCell = [[HomeCell alloc] initWithAccessoryView:NO];
    analyticsCell.cellImageView.image = [UIImage imageNamed:@"AnalyticsIcon.png"];
    analyticsCell.cellName.text = @"Analytics";
    
    creditsCell = [[HomeCell alloc] initWithAccessoryView:NO];
    creditsCell.cellImageView.image = [UIImage imageNamed:@"CreditsIcon.png"];
    creditsCell.cellName.text = @"Credits";
    
    logoutCell = [[HomeCell alloc] initWithAccessoryView:NO];
    logoutCell.cellImageView.image = [UIImage imageNamed:@"LogoutIcon.png"];
    logoutCell.cellName.text = @"Logout";
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
