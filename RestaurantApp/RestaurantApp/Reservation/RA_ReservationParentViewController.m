//
//  RA_ReservationParentViewController.m
//  RestaurantApp
//
//  Created by World on 12/26/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_ReservationParentViewController.h"
#import "RA_TakeAwayViewController.h"
#import "RA_ReservationViewController.h"
#import "RA_HomeCell.h"

@interface RA_ReservationParentViewController ()
{
    RA_HomeCell *takeAwayCell;
    RA_HomeCell *reservationCell;
}

@end

@implementation RA_ReservationParentViewController

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
    
    //tableview attributes modified
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.layer.cornerRadius = 4.0f;
    containerTableView.layer.borderWidth = 1.0f;
    containerTableView.layer.borderColor = kBorderColor;
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableView.backgroundColor = [UIColor whiteColor];
    
    //background color of the page and tableview set
    self.view.backgroundColor = kPageBGColor;
    [containerTableView setBackgroundColor:kPageBGColor];
    
    [self cellConfiguration];
    
    if([UIScreen mainScreen].bounds.size.width > 568)//tableview frame for ipad
    {
        CGRect frame = containerTableView.frame;
        frame.size.height = 200;
        containerTableView.frame = frame;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateStrings];//localize static strings to user selected language
    [containerTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    showing takeAwayCell and reservationCell
    switch (indexPath.row)
    {
        case 0:
            return reservationCell;
        
        case 1:
            return takeAwayCell;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIScreen mainScreen].bounds.size.width > 568)//ipad
    {
        return 100;
    }
    return 63.0f;//iphone
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //open the page for which cell has been selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    
    UIViewController *vc = nil;
    if(indexPath.row == 0)
    {
        vc = [[RA_ReservationViewController alloc] initWithNibName:@"RA_ReservationViewController" bundle:nil];
        vc.title = AMLocalizedString(@"kReserveTable", nil);
    }
    else
    {
        vc = [[RA_TakeAwayViewController alloc] initWithNibName:@"RA_TakeAwayViewController" bundle:nil];
        vc.title = AMLocalizedString(@"kTakeAway", nil);
    }
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * Method name: cellConfiguration
 * Description: configuring static cells(takeAway cell and reservation cell)
 * Parameters: none
 */

-(void)cellConfiguration
{
    takeAwayCell = [[RA_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reservationCellId"];
    takeAwayCell.pageImageView.image = kRestaurantCellImage;
    
    reservationCell = [[RA_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reservationCellId"];
    reservationCell.pageImageView.image = kGalleryCellImage;
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    takeAwayCell.pageNameLabel.text = AMLocalizedString(@"kTakeAway", nil);
    reservationCell.pageNameLabel.text = AMLocalizedString(@"kReserveTable", nil);
}

/**
 * Method name: updateStrings
 * Description: update the static strings according to the laguage chosen
 * Parameters: none
 */

-(void)updateStrings
{
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    takeAwayCell.pageNameLabel.text = AMLocalizedString(@"kTakeAway", nil);
    reservationCell.pageNameLabel.text = AMLocalizedString(@"kReserveTable", nil);
}

@end
