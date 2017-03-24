//
//  ClockSetupViewController.h
//  WakeUp
//
//  Created by World on 7/9/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClockSetupViewControllerDelegate <NSObject>

-(void)backButtonPressedAction;

@end

@interface ClockSetupViewController : UIViewController
{
    IBOutlet UIDatePicker *alarmTimePicker;
    IBOutlet UISwitch *motionSwitch;
    IBOutlet UISwitch *alarmSwitch;
    IBOutlet UITextField *alarmTimeField;
    IBOutlet UILabel *alarmClockLabel;
    IBOutlet UIButton *updateButton;
}
@property (nonatomic, assign) id <ClockSetupViewControllerDelegate> delegate;

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)updateButtonAction:(UIButton*)sender;
-(IBAction)timePickerValueChanged:(UIDatePicker*)sender;
-(IBAction)switchValueChanged:(UISwitch*)sender;

@end
