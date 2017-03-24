//
//  DrawerViewController.m
//  iOS Prototype
//
//  Created by World on 3/5/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "DrawerViewController.h"
#import "SocialViewController.h"
#import "SettingsViewController.h"
#import "SignInSignUpViewController.h"

@interface DrawerViewController ()
{
    UINavigationController *navCon;
    
    UIViewController *currentVc;
}

@end

@implementation DrawerViewController

@synthesize currentViewController;

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
    
    navCon = [[UINavigationController alloc] init];
    
    self.navigationController.navigationBar.translucent = NO;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurrentViewController)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [self showCurrentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)back
{
    [currentVc removeFromParentViewController];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if([UserDefaultsManager isUserMerchant])
        {
            UIImageView *cellBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MerchantSideMenuCellBG.png"]];
            [cell setSelectedBackgroundView:cellBG];
        }
        else
        {
            UIView *bgColorView = [[UIView alloc] init];
            [bgColorView setBackgroundColor:[UIColor colorWithRed:226.0f/255.0f green:100.0f/255.0f blue:98.0f/255.0f alpha:1.0f]];
            [cell setSelectedBackgroundView:bgColorView];
        }
    }
    
    if([UserDefaultsManager isUserMerchant])
    {
        switch (indexPath.row)
        {
            case kProfile:
                cell.textLabel.text = @"Profile";
                break;
                
            case kOffers:
                cell.textLabel.text = @"Offers";
                break;
                
            case kActivity:
                cell.textLabel.text = @"Activity";
                break;
                
            case kGrabbers:
                cell.textLabel.text = @"Grabbers";
                break;
                
            case kLocations:
                cell.textLabel.text = @"Locations";
                break;
                
            case kReports:
                cell.textLabel.text = @"Reports";
                break;
                
            case kSettings:
                cell.textLabel.text = @"Settings";
                break;
                
            case kLogout:
                cell.textLabel.text = @"Logout";
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case kProfile:
                cell.textLabel.text = @"Edit Profile";
                break;
                
            case kOffers:
                cell.textLabel.text = @"Manage Stores";
                break;
                
            case kActivity:
                cell.textLabel.text = @"Manage Location Offers";
                break;
                
            case kGrabbers:
                cell.textLabel.text = @"Social Pages";
                break;
                
            case kLocations:
                cell.textLabel.text = @"Analytics";
                break;
                
            case kReports:
                cell.textLabel.text = @"Settings";
                break;
                
            case kSettings:
                cell.textLabel.text = @"Credits";
                break;
                
            case kLogout:
                cell.textLabel.text = @"Logout";
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UserDefaultsManager isUserMerchant])
    {
        
    }
    else
    {
        if(indexPath.row == kProfile)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            vc.drawerViewDelegate = self;
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kOffers)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kActivity)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kGrabbers)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kLocations)
        {
            [self.currentViewController.view removeFromSuperview];
            
//            MapViewController *vc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
//            vc.drawerViewDelegate = self;
//            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kReports)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kSettings)
        {
            [self.currentViewController.view removeFromSuperview];
            
            SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            vc.drawerViewDelegate = self;
            self.currentViewController = vc;
            
            [self showCurrentViewController];
        }
        else if(indexPath.row == kLogout)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [UserDefaultsManager setKeepMeSignedIn:NO];
        }
    }
}

-(void)showCurrentViewController
{
    [self.currentViewController.view removeGestureRecognizer:tapRecognizer];
    self.currentViewController.view.frame = CGRectMake(250, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.currentViewController.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)hideCurrentViewController
{
    self.currentViewController.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.currentViewController.view.layer.shadowOpacity = 0.5f;
    self.currentViewController.view.layer.shadowOffset = CGSizeMake(-5.0f, 0);
    self.currentViewController.view.layer.shadowRadius = 7.0f;
    
    [self.currentViewController.view addGestureRecognizer:tapRecognizer];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.currentViewController.view.frame = CGRectMake(250, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)showDrawerView
{
    [self hideCurrentViewController];
}

@end
