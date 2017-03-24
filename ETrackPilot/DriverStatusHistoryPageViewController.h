//
//  DriverStatusHistoryPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/23/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverStatusHistoryPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *DriverStatusHistoryTableView;
    
}

@end
