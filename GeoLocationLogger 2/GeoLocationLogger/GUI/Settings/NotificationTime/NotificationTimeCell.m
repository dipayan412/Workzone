//
//  NotificationTimeCell.m
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "NotificationTimeCell.h"
#import "NSDate+Extension.h"

@implementation NotificationTimeCell

@synthesize cellNameLabel;
@synthesize notificationTimePicker;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellNameLabel = [[UILabel alloc] init];
        cellNameLabel.font = [UIFont systemFontOfSize:13];
        
        pickerContainerView = [[UIView alloc] init];
        pickerContainerView.backgroundColor = [UIColor whiteColor];
        
        notificationTimePicker = [[UIDatePicker alloc] init];
        
        cellNameLabel.backgroundColor = [UIColor clearColor];
        notificationTimePicker.backgroundColor = [UIColor clearColor];
        
        cellNameLabel.numberOfLines = 0;
        
        notificationTimePicker.datePickerMode = UIDatePickerModeTime;
        notificationTimePicker.backgroundColor = [UIColor clearColor];
        
        NSDate *midnight = [[NSDate date] dateByAddingTimeInterval:(-[[NSDate date] timeIntervalSinceMidnight])];
        
        [notificationTimePicker setDate: [midnight dateByAddingTimeInterval:[UserDefaultsManager notificationTime]]];
        [notificationTimePicker addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:cellNameLabel];
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            [self.contentView addSubview:pickerContainerView];
        }
        
        [self.contentView addSubview:notificationTimePicker];
    }
    return self;
}

-(void)timePickerValueChanged:(UIDatePicker*)sender
{
    if(delegate)
    {
        [delegate notificationTimePickerValueChangedTo:sender.date];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = self.contentView.bounds.origin.x;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = self.contentView.bounds.size.height;
    
    
    pickerContainerView.frame = CGRectMake(w/2, y + 10, w/2 - 15, h - 20);
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        cellNameLabel.frame = CGRectMake(x + 10, y + 100, w/2, 20);
        notificationTimePicker.frame = CGRectMake(w/2, y + 10, w/2 - 15, h - 20);
    }
    else
    {
        cellNameLabel.frame = CGRectMake(x + 10, y + 100, w/2 - 50, 40);
        notificationTimePicker.frame = CGRectMake(w/2 - 45, y + 10, w/2 + 30, h - 20);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
