//
//  SettingsViewController.h
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *alarmTextField;
    IBOutlet UITextField *snoozeField;
    IBOutlet UIDatePicker *alarmDatePicker;
    IBOutlet UIButton *updateButton;
}
@property (nonatomic, strong) id <DrawerViewDelegate> delegate;

-(IBAction)alarmDataChangedTo:(UIDatePicker*)sender;
-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)updateButtonAction:(UIButton*)sender;
@end
