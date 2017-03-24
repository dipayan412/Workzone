//
//  SettingsViewController.m
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "SettingsViewController.h"
#import "NSDate+Extension.h"
#import <QuartzCore/QuartzCore.h>

#define kHeaderViewHeight 35.0f

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    self.title = @"Setting";
    self.view.backgroundColor = kApplicationBackground;
    
    containerTableView.backgroundColor = [UIColor clearColor];
    containerTableView.backgroundView = nil;
    
    dailyCell = [[DailyNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    dailyCell.backgroundColor = [UIColor clearColor];
    dailyCell.delegate = self;
    dailyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dailyCell.cellNameLabel.text = @"Daily Notification";
    
    timeCell = [[NotificationTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    timeCell.backgroundColor = [UIColor clearColor];
    timeCell.delegate = self;
    timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    timeCell.cellNameLabel.text = @"Notification Time";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:YES];
    [super viewWillDisappear:animated];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return dailyCell;
    }
    else if(indexPath.section == 1)
    {
        return timeCell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderViewHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 300, kHeaderViewHeight - 6)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
        
    switch (section)
    {
        case 0:
            label.text = @"Daily Notification";
            break;
            
        case 1:
            label.text = @"Notification Time";
            break;
    }
    
    UIView *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kHeaderViewHeight)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SectionHeaderBG.png"]];
    
    [view addSubview:label];
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            if([UIScreen mainScreen].bounds.size.height < 568)
            {
                return 80;
            }
            return 140;

        case 1:
            return 220;
    }
    return 0;
}

-(void)dailyNotificationSwitchValueChangedTo:(BOOL)value
{
    [UserDefaultsManager setDailyNotification:value];
}

-(void)notificationTimePickerValueChangedTo:(NSDate *)time
{
    NSLog(@"time->%d",[time timeIntervalSinceMidnight]);
    [UserDefaultsManager setNotificationTime:[time timeIntervalSinceMidnight]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
