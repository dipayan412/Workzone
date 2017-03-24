//
//  DrawerViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightViewController.h"
#import "DrawerViewDelegate.h"

@interface DrawerViewController : UIViewController <DrawerViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITapGestureRecognizer *tapRecognizer;
    RightViewController *homeNC;
    RightViewController *settingsNC;
    RightViewController *timeLineNC;
    RightViewController *contactNC;
    
    IBOutlet UITableView *containerTableView;
    
    BOOL open;
}
@property (nonatomic, assign) BOOL isWakeUpCallReceived;

//-(id)init;

@end
