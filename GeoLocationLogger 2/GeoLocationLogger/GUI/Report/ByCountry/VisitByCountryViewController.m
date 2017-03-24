//
//  VisitByCountryViewController.m
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "VisitByCountryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VisitByCountryViewController ()

@end

@implementation VisitByCountryViewController

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
    
    self.title = @"By Country";
    
    self.view.backgroundColor = kApplicationBackground;
    
    visitInfoView.layer.borderColor = [UIColor grayColor].CGColor;
    visitInfoView.layer.borderWidth = 2;
    
    visitInfoView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    visitInfoView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    visitInfoView.layer.shadowOpacity = 0.5f;
    
    byYearButton.layer.borderColor = [UIColor grayColor].CGColor;
    byYearButton.layer.borderWidth = 2;
    
    byMonthButton.layer.borderColor = [UIColor grayColor].CGColor;
    byMonthButton.layer.borderWidth = 2;
    
    bySemesterButton.layer.borderColor = [UIColor grayColor].CGColor;
    bySemesterButton.layer.borderWidth = 2;
    
    byQuarterButton.layer.borderColor = [UIColor grayColor].CGColor;
    byQuarterButton.layer.borderWidth = 2;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    visitInfoType = 0;
    
    [self reloadVisitInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectCountry:(id)sender
{
    
}

-(IBAction)selectByYear:(id)sender
{
    visitInfoType = 0;
    [self reloadVisitInfo];
}

-(IBAction)selectBySemester:(id)sender
{
    visitInfoType = 1;
    [self reloadVisitInfo];
}

-(IBAction)selectByQuarter:(id)sender
{
    visitInfoType = 2;
    [self reloadVisitInfo];
}
-(IBAction)selectByMonth:(id)sender
{
    visitInfoType = 3;
    [self reloadVisitInfo];
}

-(void)reloadVisitInfo
{
    byYearButton.backgroundColor =
    bySemesterButton.backgroundColor =
    byQuarterButton.backgroundColor =
    byMonthButton.backgroundColor = [UIColor lightGrayColor];
    
    switch (visitInfoType)
    {
        case 0:
            byYearButton.backgroundColor = [UIColor whiteColor];
            break;
            
        case 1:
            bySemesterButton.backgroundColor = [UIColor whiteColor];
            break;
            
        case 2:
            byQuarterButton.backgroundColor = [UIColor whiteColor];
            break;
            
        case 3:
            byMonthButton.backgroundColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

@end
