//
//  SettingsViewController.h
//  iOS Prototype
//
//  Created by World on 3/4/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *containerTableView;
    IBOutlet UIImageView *shopImageView;
    
    IBOutlet UIView *customNavigatonBarView;
}

-(IBAction)saveButtonAction:(UIButton*)sender;

@property (nonatomic, strong) id<DrawerViewDelegate> drawerViewDelegate;

@end
