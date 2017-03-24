//
//  HomeViewController.m
//  iOS Prototype
//
//  Created by World on 2/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "HomeViewController.h"
#import "ReceiverSide.h"
#import "SettingsViewController.h"
#import "SocialViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    notificationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG-568h.png"]];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)back:(UIButton*)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    MapViewController *vc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)settingsButtonAction:(UIButton*)btn
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)associateButtonAction:(UIButton*)btn
{
    SocialViewController *vc = [[SocialViewController alloc] initWithNibName:@"SocialViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
