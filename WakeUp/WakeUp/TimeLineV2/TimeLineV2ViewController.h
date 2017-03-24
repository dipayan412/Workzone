//
//  TimeLineV2ViewController.h
//  WakeUp
//
//  Created by World on 8/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"
#import "ClockSetupViewController.h"
#import "TimeLineV2Cell.h"
#import "TimelineObject.h"

@interface TimeLineV2ViewController : UIViewController <DrawerViewDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate,ClockSetupViewControllerDelegate>
{
    ClockSetupViewController *clockSetupVC;
    
    IBOutlet UITableView *containerTableView;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)alarmClockButtonAction:(UIButton*)sender;

@end
