//
//  JobPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "JobPageViewController.h"
#import "NewJobPageViewController.h"
#import "JobItemPageViewController.h"

@interface JobPageViewController ()

@end

@implementation JobPageViewController

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
    
    UIImage *backgroundImage = [UIImage imageNamed:@"title.png"];
    [[UIToolbar appearance] setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [jobsTableView release];
    [newJobBarButton release];
    [super dealloc];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *jobCellId = @"JobCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobCellId];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobCellId] autorelease];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobItemPageViewController *vc = [[JobItemPageViewController alloc] initWithNibName:@"JobItemPageViewController" bundle:nil];
    vc.title = @"Job #";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)newJobButtonAction:(UIBarButtonItem *)sender
{
    NewJobPageViewController *vc = [[NewJobPageViewController alloc] initWithNibName:@"NewJobPageViewController" bundle:nil];
    vc.title = @"New Job";
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
