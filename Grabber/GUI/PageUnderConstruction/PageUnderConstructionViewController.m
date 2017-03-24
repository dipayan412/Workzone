//
//  PageUnderConstructionViewController.m
//  iOS Prototype
//
//  Created by World on 3/14/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "PageUnderConstructionViewController.h"

@interface PageUnderConstructionViewController () <UIAlertViewDelegate>
{
    NSString *pageName;
}

@end

@implementation PageUnderConstructionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithTitle:(NSString*)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        pageName = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title = pageName;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon"
                                                    message:@"Page under construction"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
