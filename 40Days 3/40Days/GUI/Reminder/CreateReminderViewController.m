//
//  CreateReminderViewController.m
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "CreateReminderViewController.h"
#import "AppData.h"
#import "SinlgeDayReminderViewController.h"
#import "RepeatingReminderViewController.h"

@interface CreateReminderViewController ()

@end

@implementation CreateReminderViewController

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
    
    [AppData applyGenericButtonStylesOnButton:singleDayReminderButton];
    [AppData applyGenericButtonStylesOnButton:repeatingReminderButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singleDayReminder:(id)sender
{
    SinlgeDayReminderViewController *singleVC = [[SinlgeDayReminderViewController alloc] initWithNibName:@"SinlgeDayReminderViewController" bundle:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [newBackButton release];
    
    [self.navigationController pushViewController:singleVC animated:YES];
    [singleVC release];
}

- (IBAction)repeatingReminder:(id)sender
{
    RepeatingReminderViewController *singleVC = [[RepeatingReminderViewController alloc] initWithNibName:@"RepeatingReminderViewController" bundle:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [newBackButton release];
    
    [self.navigationController pushViewController:singleVC animated:YES];
    [singleVC release];
}
@end
