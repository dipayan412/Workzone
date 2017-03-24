//
//  RA_HomeViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_HomeViewController.h"
#import "RA_RestaurantViewController.h"
#import "RA_NewsViewController.h"
#import "RA_TakeAwayViewController.h"
#import "RA_ReservationViewController.h"
#import "RA_SettingsViewController.h"
#import "RA_HomeCell.h"
#import "RA_GalleryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RA_HomeViewController () <SettingsViewControllerDelegate>
{
    NSArray *tableViewCellNames;
    NSArray *slideshowImageArray;
    
    int indexOfSlideShowImageArray;
    
    RA_HomeCell *restaurantPageCell;
    RA_HomeCell *imageGalleryCell;
    RA_HomeCell *newsCell;
}

@end

@implementation RA_HomeViewController

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
    
    self.navigationController.navigationBar.translucent = NO;
    //defining the settings button
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:kSettingsButton style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonAction)];
    settingsButton.tintColor = [UIColor whiteColor];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    }
    else
    {
        self.navigationController.navigationBar.tintColor = kNavigationBarColor;
    }
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    // defining call button
    UIBarButtonItem *callButton = [[UIBarButtonItem alloc] initWithImage:kCallButton style:UIBarButtonItemStylePlain target:self action:@selector(callButtonAction)];
    callButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = callButton;
    
    indexOfSlideShowImageArray = 0;
    
    // name of the features in home page initialised
    tableViewCellNames = [[NSArray alloc] initWithObjects:@"Our Restaurant",@"The Menu",@"News & Offers",@"Take Away",@"Reservation",nil];
    
    // initial picture for the slideshow
    slideshowImageView.image = [UIImage imageNamed:kRestaurantSlide4];
    
    //populating the imageArray with images for showing slideshow
    slideshowImageArray = [[NSArray alloc] initWithObjects:kRestaurantSlide1,kRestaurantSlide2,kRestaurantSlide3,kRestaurantSlide4, nil];
    
    // a timer created to autoswitch the images in the slideshow
    NSTimer *slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(commitSlideshow) userInfo:nil repeats:YES];
    [slideshowTimer fire];
    
    //the tableview, containing the features of the this page, attributes are changed according to docs provided
    containerTableView.separatorColor = [UIColor clearColor];
    containerTableView.layer.cornerRadius = 4.0f;
    containerTableView.layer.borderWidth = 1.0f;
    containerTableView.layer.borderColor = kBorderColor;
    containerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    containerTableView.backgroundColor = [UIColor whiteColor];
    
    // handling view for 3.5 display
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        CGRect frame = containerTableView.frame;
        frame.size.height = 150;
        containerTableView.frame = frame;
    }
    
    //setting view background
    self.view.backgroundColor = kPageBGColor;
    [containerTableView setBackgroundColor:kPageBGColor];
    slideshowImageView.backgroundColor = kPageBGColor;
    
    // changing attributes to the slideshowview
    slightShowBGView.layer.borderWidth = 1.0f;
    slightShowBGView.layer.borderColor = kBorderColor;
    slightShowBGView.layer.cornerRadius = 4.0f;
    
    [self cellConfiguration];
    
    if([UIScreen mainScreen].bounds.size.height > 568) // this scope is executed when the device is iPad and and the view is re-arranged
    {
        CGRect frameImageView = slideshowImageView.frame;
        frameImageView.size.height = 400;
        slideshowImageView.frame = frameImageView;
        
        CGRect frameImageBGView = slightShowBGView.frame;
        frameImageBGView.size.height = 410;
        slightShowBGView.frame = frameImageBGView;
        
        CGRect frameLeftButton = leftButton.frame;
        frameLeftButton.size.width = 25;
        frameLeftButton.size.height = 25;
        frameLeftButton.origin.y = slideshowImageView.frame.size.height / 2 - frameLeftButton.size.height / 2;
        leftButton.frame = frameLeftButton;
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        CGRect frameRightButton = rightButton.frame;
        frameRightButton.origin.x -= 10;
        frameRightButton.size.width = 25;
        frameRightButton.size.height = 25;
        frameRightButton.origin.y = slideshowImageView.frame.size.height / 2 - frameRightButton.size.height / 2;
        rightButton.frame = frameRightButton;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        CGRect frameTable = containerTableView.frame;
        frameTable.origin.y = 450;
        frameTable.size.height = 300;
        containerTableView.frame = frameTable;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //localizing texts according to user chosen language
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    [self changeLanguage];
}

/**
 * Method name: callButtonAction
 * Description: call button funtionality, check whether the device has call action capability
 * Parameters: none
 */

-(void)callButtonAction
{
    //
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kPhone]]];
    }
    else
    {
        // case if call functionality not present in the device
        LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:AMLocalizedString(@"kPhoneCall", nil) delegate:nil cancelButtonTitle:AMLocalizedString(@"kDismiss", nil) otherButtonTitles:nil];
        [alert show];
    }
}

/**
 * Method name: settingsButtonAction
 * Description: settings button action, opens the setting page
 * Parameters: none
 */

-(void)settingsButtonAction
{
    // settings button action, opens the setting page
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    RA_SettingsViewController *vc = [[RA_SettingsViewController alloc] initWithNibName:@"RA_SettingsViewController" bundle:nil];
    vc.title = AMLocalizedString(@"kSettings", nil);
    vc.delegate = self;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * Method name: updateBackButton
 * Description: configuring the back button
 * Parameters: none
 */

-(void)updateBackButton
{
    //
    UIBarButtonItem *newBackButton = (UIBarButtonItem*) [[self navigationItem] backBarButtonItem];
    newBackButton.title = AMLocalizedString(@"kBack", nil);
}

/**
 * Method name: commitSlideshow
 * Description: slideshow animation, image trasition handled through CATransition
 * Parameters: none
 */

-(void)commitSlideshow
{
    slideshowImageView.image = [UIImage imageNamed:[slideshowImageArray objectAtIndex:indexOfSlideShowImageArray]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [slideshowImageView.layer addAnimation:transition forKey:nil];
    
    if(indexOfSlideShowImageArray == 3)
        indexOfSlideShowImageArray = -1;
    indexOfSlideShowImageArray++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // showing feature cells at approprite position
    switch (indexPath.row)
    {
        case 0:
            return restaurantPageCell;
            
        case 1:
            return imageGalleryCell;
            
        case 2:
            return newsCell;
            
        default:
            break;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //opening approprite features tapping on feature cells
    [containerTableView deselectRowAtIndexPath:indexPath animated:YES];
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);

    UIViewController *vc;
    if(indexPath.row == 0)
    {
        vc = [[RA_RestaurantViewController alloc] initWithNibName:@"RA_RestaurantViewController" bundle:nil];
        vc.title = AMLocalizedString(@"kOurRestaurant", nil);
    }
    else if(indexPath.row == 1)
    {
        vc = [[RA_GalleryViewController alloc] initWithNibName:@"RA_GalleryViewController" bundle:nil];
        vc.title = AMLocalizedString(@"kImageGallery", nil);
    }
    else if(indexPath.row == 2)
    {
        vc = [[RA_NewsViewController alloc] initWithNibName:@"RA_NewsViewController" bundle:nil];
        vc.title = AMLocalizedString(@"kNews_Offers", nil);
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: AMLocalizedString(@"kBack", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //handling cases for height of each feature cells for ipad,ipohone 4 inch and iphone3.5inch
    if([UIScreen mainScreen].bounds.size.height < 568)
    {
        return 50;
    }
    if([UIScreen mainScreen].bounds.size.height > 568)
    {
        return 100;
    }
    return 63;
}

/**
 * Method name: leftButtonAction
 * Description: swith image to previous image in slideshow
 * Parameters: button which has been tapped
 */

-(IBAction)leftButtonAction:(UIButton*)sender
{
    //
    if(indexOfSlideShowImageArray <= 0)
        indexOfSlideShowImageArray = 4;
    indexOfSlideShowImageArray--;
    
    slideshowImageView.image = [UIImage imageNamed:[slideshowImageArray objectAtIndex:indexOfSlideShowImageArray]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [slideshowImageView.layer addAnimation:transition forKey:nil];
}

/**
 * Method name: rightButtonAction
 * Description: swith image to next image in slideshow
 * Parameters: button which has been tapped
 */

-(IBAction)rightButtonAction:(UIButton*)sender
{
    //
    if(indexOfSlideShowImageArray == 3)
        indexOfSlideShowImageArray = -1;
    indexOfSlideShowImageArray++;
    
    slideshowImageView.image = [UIImage imageNamed:[slideshowImageArray objectAtIndex:indexOfSlideShowImageArray]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [slideshowImageView.layer addAnimation:transition forKey:nil];
}

/**
 * Method name: cellConfiguration
 * Description: configuring static cells which are restaurantPageCell,GalleryPageCell and NewsPageCell
 * Parameters: none
 */

-(void)cellConfiguration
{
    restaurantPageCell = [[RA_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomePageCellId"];
    restaurantPageCell.pageNameLabel.text = AMLocalizedString(@"kOurRestaurant", nil);
    restaurantPageCell.pageImageView.image = kRestaurantCellImage;
    
    imageGalleryCell = [[RA_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomePageCellId"];
    imageGalleryCell.pageNameLabel.text = AMLocalizedString(@"kImageGallery", nil);
    imageGalleryCell.pageImageView.image = kGalleryCellImage;
    
    newsCell = [[RA_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomePageCellId"];
    newsCell.pageNameLabel.text = AMLocalizedString(@"kNews_Offers", nil);
    newsCell.pageImageView.image = kNewsCellImage;
}

/**
 * Method name: changeLanguage
 * Description: localizing static strings according to user chosen language
 * Parameters: none
 */
-(void)changeLanguage
{
    restaurantPageCell.pageNameLabel.text = AMLocalizedString(@"kOurRestaurant", nil);
    imageGalleryCell.pageNameLabel.text = AMLocalizedString(@"kImageGallery", nil);
    newsCell.pageNameLabel.text = AMLocalizedString(@"kNews_Offers", nil);
    
    [containerTableView reloadData];
}

@end
