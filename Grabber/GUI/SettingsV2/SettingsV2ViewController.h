//
//  SettingsV2ViewController.h
//  Grabber
//
//  Created by World on 4/7/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsV2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableView;
}
@property (nonatomic, retain) UIImage *proPic;

@end
