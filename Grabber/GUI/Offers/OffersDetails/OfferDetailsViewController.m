//
//  OfferDetailsViewController.m
//  Grabber
//
//  Created by World on 3/19/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "OfferDetailsViewController.h"

@interface OfferDetailsViewController ()

@end

@implementation OfferDetailsViewController

@synthesize promo;

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
    
    self.navigationController.title = @"OFFER DETAILS";
    
    promoDetailsLabel.text = promo.promoDetails;
    promoNameLabel.text = promo.promoName;
    shopNameLabel.text = promo.shopName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
