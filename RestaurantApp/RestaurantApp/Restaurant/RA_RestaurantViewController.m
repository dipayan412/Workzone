//
//  RA_RestaurantViewController.m
//  RestaurantApp
//
//  Created by World on 12/18/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "RA_RestaurantViewController.h"
#import "RA_GalleryViewController.h"
#import "RA_FindUsViewController.h"
#import "RA_HomeCell.h"

@interface RA_RestaurantViewController ()

@end

@implementation RA_RestaurantViewController

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
    
    //setting title label to white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //setting page background
    self.view.backgroundColor = kPageBGColor;
    
    //configuring imageview background
    restaurantImageBGView.layer.borderWidth = 1.0f;
    restaurantImageBGView.layer.borderColor = kBorderColor;
    restaurantImageBGView.layer.cornerRadius = 4.0f;
    
    //configuring textview background
    restaurantDetailsTextviewBGView.layer.borderWidth = 1.0f;
    restaurantDetailsTextviewBGView.layer.borderColor = kBorderColor;
    restaurantDetailsTextviewBGView.layer.cornerRadius = 4.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //re-organizing view for ipad
    if([UIScreen mainScreen].bounds.size.height > 568)
    {
        CGRect frameImageView = restaurantImageView.frame;
        frameImageView.size.height = 400;
        frameImageView.origin.x = 20;
        frameImageView.origin.y = 20;
        frameImageView.size.width = self.view.frame.size.width - 40;
        restaurantImageView.frame = frameImageView;
        
        CGRect frameImageBG = restaurantImageBGView.frame;
        frameImageBG.size.height = 410;
        frameImageBG.size.width = self.view.frame.size.width - 30;
        frameImageBG.origin.x = 15;
        frameImageBG.origin.y = 15;
        restaurantImageBGView.frame = frameImageBG;
        
        CGRect frameLabel = restaurantDetailsTextview.frame;
        frameLabel.origin.x = 20;
        frameLabel.size.width = self.view.frame.size.width - 40;
        frameLabel.origin.y = 470;
        frameLabel.size.height += 200;
        restaurantDetailsTextview.frame = frameLabel;
        restaurantDetailsTextview.font = [UIFont systemFontOfSize:17];
        
        CGRect frameLabelBG = restaurantDetailsTextviewBGView.frame;
        frameLabelBG.origin.x = 15;
        frameLabelBG.size.width = self.view.frame.size.width - 30;
        frameLabelBG.origin.y = 465;
        frameLabelBG.size.height += 200;
        restaurantDetailsTextviewBGView.frame = frameLabelBG;
    }
    else if([UIScreen mainScreen].bounds.size.height < 568)//re-organizing view for iPhone 3.5 inch display size
    {
        CGRect frameLabel = restaurantDetailsTextview.frame;
        frameLabel.size.height -= 30;
        restaurantDetailsTextview.frame = frameLabel;
        
        CGRect frameLabelBG = restaurantDetailsTextviewBGView.frame;
        frameLabelBG.size.height -= 30;
        restaurantDetailsTextviewBGView.frame = frameLabelBG;
    }
    
    LocalizationSetLanguage([RA_UserDefaultsManager appLanguage]);
    restaurantDetailsTextview.text = AMLocalizedString(@"kOurRestaurant", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
