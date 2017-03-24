//
//  ReportViewController.m
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "ReportViewController.h"
#import "VisitByCountryViewController.h"
#import "VisitByYearViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Ricerca";
    
    self.view.backgroundColor = kApplicationBackground;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)visitByCountry:(id)sender
{
    VisitByCountryViewController *vc = [[VisitByCountryViewController alloc] initWithNibName:@"VisitByCountryViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)visitByYear:(id)sender
{
    VisitByYearViewController *vc = [[VisitByYearViewController alloc] initWithNibName:@"VisitByYearViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
