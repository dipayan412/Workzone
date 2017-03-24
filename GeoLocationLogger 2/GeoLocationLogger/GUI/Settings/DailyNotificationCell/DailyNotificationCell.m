//
//  DailyNotificationCell.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "DailyNotificationCell.h"

@implementation DailyNotificationCell

@synthesize cellNameLabel;
@synthesize dailyNotificationSwitch;
@synthesize delegate;
@synthesize dailyNotificationSegmentedControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellNameLabel = [[UILabel alloc] init];
        cellNameLabel.font = [UIFont systemFontOfSize:13];
        
        dailyNotificationSwitch = [[UISwitch alloc] init];
        dailyNotificationSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Yes", @"No", nil]];
        dailyNotificationSegmentedControl.tintColor = [UIColor colorWithRed:252.0f/255.0f green:136.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
        dailyNotificationSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        
        cellNameLabel.backgroundColor = [UIColor clearColor];
        
        dailyNotificationSwitch.backgroundColor = [UIColor clearColor];
        dailyNotificationSwitch.onTintColor = [UIColor colorWithRed:252.0f/255.0f green:136.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
        
        [dailyNotificationSwitch setOn:[UserDefaultsManager dailyNotification]];
        
        [dailyNotificationSegmentedControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if([UserDefaultsManager dailyNotification])
        {
            [dailyNotificationSegmentedControl setSelectedSegmentIndex:0];
        }
        else
        {
            [dailyNotificationSegmentedControl setSelectedSegmentIndex:1];
        }
        
        [self.contentView addSubview:cellNameLabel];
        [self.contentView addSubview:dailyNotificationSegmentedControl];
    }
    return self;
}

-(void)switchValueChanged:(UISegmentedControl*)sender
{
    BOOL value;
    if(delegate)
    {
        if(sender.selectedSegmentIndex == 0)
        {
            value = YES;
        }
        else
        {
            value = NO;
        }
        [delegate dailyNotificationSwitchValueChangedTo:value];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width;
//    CGFloat h = self.contentView.bounds.size.height;
    
    cellNameLabel.frame = CGRectMake(x + 10, y + 10, w/2, 30);
    dailyNotificationSegmentedControl.frame = CGRectMake(2*w/3, y + 10, w/3 - 15, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
