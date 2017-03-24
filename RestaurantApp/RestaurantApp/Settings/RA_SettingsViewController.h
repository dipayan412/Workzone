//
//  RA_SettingsViewController.h
//  RestaurantApp
//
//  Created by World on 12/19/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate <NSObject>

-(void)updateBackButton;

@end

@interface RA_SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *containerTableview;
}

@property (nonatomic, retain) id <SettingsViewControllerDelegate> delegate;

@end
