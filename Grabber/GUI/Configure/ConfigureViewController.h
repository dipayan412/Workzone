//
//  ConfigureViewController.h
//  Grabber
//
//  Created by World on 4/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ConfigureViewController : UIViewController <CBCentralManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CBCentralManager *myCentralManager;
    
    NSMutableArray *devicesArray;
    
    IBOutlet UITableView *devicesTable;
    
    UIBarButtonItem *startButton;
    UIBarButtonItem *stopButton;
    
    BOOL searching;
}

@end
