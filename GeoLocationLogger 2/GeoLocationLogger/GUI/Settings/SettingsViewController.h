//
//  SettingsViewController.h
//  GeoLocationLogger
//
//  Created by Nazmul Quader on 11/14/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyNotificationCell.h"
#import "NotificationTimeCell.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DailyNotificationCellDelegate, NotificationTimeCellDelegate>
{
    IBOutlet UITableView *containerTableView;
    
    DailyNotificationCell *dailyCell;
    NotificationTimeCell *timeCell;
}

@end
