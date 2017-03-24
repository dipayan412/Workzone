//
//  JobItemPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "JobItemPageViewController.h"
#import "EditJobPageViewController.h"

@interface JobItemPageViewController ()

@end

@implementation JobItemPageViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [customerLabel release];
    [addressLabel release];
    [contactLabel release];
    [phoneLabel release];
    [dueDateLabel release];
    [statusLabel release];
    [detailsLabel release];
    [editJobButton release];
    [removeJobButton release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editJobButtonAction:(UIButton *)sender
{
    EditJobPageViewController *vc = [[EditJobPageViewController alloc] initWithNibName:@"EditJobPageViewController" bundle:nil];
    vc.title = @"Edit Job";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)removeJobButtonAction:(UIButton *)sender
{
    
}
@end
