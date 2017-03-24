//
//  JobPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *jobsTableView;
    IBOutlet UIToolbar *bottomToolbar;
    IBOutlet UIBarButtonItem *newJobBarButton;
}
- (IBAction)newJobButtonAction:(UIBarButtonItem *)sender;

@end
