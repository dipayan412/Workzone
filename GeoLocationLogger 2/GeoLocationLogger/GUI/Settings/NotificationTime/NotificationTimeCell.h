//
//  NotificationTimeCell.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationTimeCellDelegate <NSObject>

-(void)notificationTimePickerValueChangedTo:(NSDate*)time;

@end

@interface NotificationTimeCell : UITableViewCell
{
    UIView *pickerContainerView;
    UIDatePicker *notificationTimePicker;
    UILabel *cellNameLabel;
}

@property (nonatomic, retain) id <NotificationTimeCellDelegate> delegate;
@property (nonatomic, retain) UIDatePicker *notificationTimePicker;
@property (nonatomic, retain) UILabel *cellNameLabel;

@end
