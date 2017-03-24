//
//  SelectedPictureViewController.m
//  Grabber
//
//  Created by World on 4/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SelectedPictureViewController.h"

@interface SelectedPictureViewController ()

@end

@implementation SelectedPictureViewController

@synthesize selectedPicture;

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
    selectedPictureImageView.image = self.selectedPicture;
    self.navigationItem.title = @"GRABBER";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
