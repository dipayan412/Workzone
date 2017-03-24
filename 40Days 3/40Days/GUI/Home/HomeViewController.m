//
//  HomeViewController.m
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "HomeViewController.h"
#import "ReminderViewController.h"
#import "PreviousSessionViewController.h"
#import "AppData.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppNavBarImage]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kAppBackGroung]];
    self.title = kAppTitle;
    
    [AppData applyGenericButtonStylesOnButton:devotionalButton];
    [AppData applyGenericButtonStylesOnButton:previousSessionButton];
    [AppData applyGenericButtonStylesOnButton:remindersButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    currentDay = [AppData getCurrentDay];
    NSDate *today = [AppData lastOpenedDate];
//    NSLog(@"lastDate %@", today);
    int daysDifference = [AppData daysBetweenDate:today andDate:[NSDate date]];
//    NSLog(@"day dif %d", daysDifference);
    if(daysDifference > 0)
    {
        [AppData setAppOpenedDate:[NSDate date]];
        currentDay += 1;
        [AppData setCurrentDay:currentDay];
    }
    
    dayInfoLabel.text = [NSString stringWithFormat:@"TODAY IS DAY %d!", currentDay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)devotionButtonPressed:(id)sender
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSError *error = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/40Days", documentPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    NSString *fileName = [NSString stringWithFormat:@"Day_%d.mp3", currentDay];
    NSMutableArray *audioFile = [[NSMutableArray alloc] init];
    for(int i=0; i<files.count; i++)
    {
        if([fileName isEqualToString:[files objectAtIndex:i]])
        {
            [audioFile addObject:[files objectAtIndex:i]];
//            break;
        }
    }
    
    NSString *fullPath = [filePath stringByAppendingPathComponent:[audioFile objectAtIndex:0]];
//    NSLog(@"fullPath %@", fullPath);
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    
    PlayerViewController *playerVC = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    playerVC.audioData = data;
    playerVC.currnetDay = currentDay;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style: UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    [self.navigationController pushViewController:playerVC animated:YES];
    [audioFile release];
    [playerVC release];
}

- (IBAction)previousSessionButtonPressed:(id)sender
{
    PreviousSessionViewController *previousVC = [[PreviousSessionViewController alloc] initWithNibName:@"PreviousSessionViewController" bundle:nil];
    [self.navigationController pushViewController:previousVC animated:YES];
    [previousVC release];
}

- (IBAction)remindersButtonPressed:(id)sender
{
    ReminderViewController *reminderVC = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Home" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [newBackButton release];
    
    [self.navigationController pushViewController:reminderVC animated:YES];
    [reminderVC release];
}

@end
