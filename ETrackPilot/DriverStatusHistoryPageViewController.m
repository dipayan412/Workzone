//
//  DriverStatusHistoryPageViewController.m
//  ETrackPilot
//
//  Created by World on 7/23/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "DriverStatusHistoryPageViewController.h"

@interface DriverStatusHistoryPageViewController ()

@end

@implementation DriverStatusHistoryPageViewController

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
    self.title = @"Driver Status History";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [DriverStatusHistoryTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [DriverStatusHistoryTableView release];
    DriverStatusHistoryTableView = nil;
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
@end
