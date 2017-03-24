//
//  ReminderViewController.m
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "ReminderViewController.h"
#import "CreateReminderViewController.h"
#import "AppData.h"

@interface ReminderViewController ()

@end

@implementation ReminderViewController

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
    
    self.title = kAppTitle;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    
    [AppData applyGenericButtonStylesOnButton:createReminderButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createReminder:(id)sender
{
    CreateReminderViewController *createVC = [[CreateReminderViewController alloc] initWithNibName:@"CreateReminderViewController" bundle:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [newBackButton release];
    
    [self.navigationController pushViewController:createVC animated:YES];
    [createVC release];
}
@end
