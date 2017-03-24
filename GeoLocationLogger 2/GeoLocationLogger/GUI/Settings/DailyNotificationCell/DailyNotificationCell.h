//
//  DailyNotificationCell.h
//  MyPosition
//
//  Created by World on 11/15/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DailyNotificationCellDelegate <NSObject>

-(void)dailyNotificationSwitchValueChangedTo:(BOOL)value;

@end

@interface DailyNotificationCell : UITableViewCell
{
    UILabel *cellNameLabel;
    UISwitch *dailyNotificationSwitch;
    UISegmentedControl *dailyNotificationSegmentedControl;
}

@property (nonatomic, retain) id <DailyNotificationCellDelegate> delegate;
@property (nonatomic, retain) UILabel *cellNameLabel;
@property (nonatomic, retain) UISwitch *dailyNotificationSwitch;
@property (nonatomic, retain) UISegmentedControl *dailyNotificationSegmentedControl;

@end
