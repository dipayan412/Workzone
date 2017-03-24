//
//  NotificationViewController.h
//  WakeUp
//
//  Created by World on 6/25/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
}
@property (nonatomic, assign) id <DrawerViewDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;

@end
