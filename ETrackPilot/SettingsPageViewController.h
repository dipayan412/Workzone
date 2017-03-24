//
//  SettingsPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultsManager.h"
#import "SyncListener.h"
#import "DBIListener.h"
#import "DWIListener.h"

@interface SettingsPageViewController : UIViewController <UITextFieldDelegate, SyncListener, DBIListener, DWIListener>
{
    IBOutlet UITextField *syncFrequencyLabel;
    IBOutlet UITextField *purgeDelayLabel;
    
    IBOutlet UIButton *saveSettingsButton;
    IBOutlet UIButton *syncNowButton;
    IBOutlet UIButton *resetAllButton;
}
@property (nonatomic, retain) id<SyncListener> syncListener;
@property (nonatomic, retain) id<DBIListener> dbiListener;
@property (nonatomic, retain) id<DWIListener> dwiListener;

- (IBAction)saveSettingsButtonAction:(UIButton *)sender;
- (IBAction)SyncNowButtonAction:(UIButton *)sender;
- (IBAction)resetAllButtonAction:(UIButton *)sender;
- (IBAction)backGroundTap:(id)sender;

@end
