//
//  ClockSetupViewController.m
//  WakeUp
//
//  Created by World on 7/9/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ClockSetupViewController.h"

@interface ClockSetupViewController () <UITextFieldDelegate>
{
    NSDateFormatter *df;
}
@end

@implementation ClockSetupViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePickingTime)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space1, doneButton, space2, nil]];
    alarmTimeField.inputAccessoryView = toolBar;
    alarmTimeField.inputView = alarmTimePicker;
    
    [motionSwitch setOn:[UserDefaultsManager isMotionDetectionOn]];
    [alarmSwitch setOn:[UserDefaultsManager isAlarmOn]];
    alarmTimeField.alpha = alarmClockLabel.alpha = alarmSwitch.isOn ? 1.0f : 0.0f;
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    if(![UserDefaultsManager alarmTime])
    {
        NSString *dateString = @"05:00";
        [alarmTimePicker setDate:[df dateFromString:dateString]];
    }
    else
    {
        [alarmTimePicker setDate:[UserDefaultsManager alarmTime]];
    }
    alarmTimeField.text = [df stringFromDate:alarmTimePicker.date];
    
    if(kIsThreePointFiveInch)
    {
        CGRect frame = updateButton.frame;
        frame.origin.y -= 100;
        frame.size.height = 30;
        updateButton.frame = frame;
    }
    
    updateButton.layer.cornerRadius = 4.0f;
    updateButton.backgroundColor = [UIColor whiteColor];
    [updateButton setTitleColor:[UIColor colorWithRed:252.0f/255.0f green:188.0f/255.0f blue:45.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [alarmSwitch setOn:[UserDefaultsManager isAlarmOn]];
        [motionSwitch setOn:[UserDefaultsManager isMotionDetectionOn]];
        
        [self.delegate backButtonPressedAction];
    }
}

-(IBAction)updateButtonAction:(UIButton*)sender
{
    [UserDefaultsManager setAlarmOn:alarmSwitch.isOn];
    [UserDefaultsManager setMotionDetectionOn:motionSwitch.isOn];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
//    if([UIDevice currentDevice].systemVersion.intValue >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound| UIUserNotificationTypeAlert| UIUserNotificationTypeBadge) categories:nil]];
//    }
    
    [UserDefaultsManager setAlarmTime:alarmTimePicker.date];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if([UserDefaultsManager isMotionDetectionOn])
    {
        localNotification.fireDate = [UserDefaultsManager motionAlarmTime];
    }
    else
    {
        localNotification.fireDate = [UserDefaultsManager alarmTime];
    }
    
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = @"Its time to Wake Up !!!";
    localNotification.alertAction = @"Go to app";
    localNotification.soundName = @"sound.caf";//UILocalNotificationDefaultSoundName;
    localNotification.hasAction = YES;
    localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"WakeUpAlert", @"wakeup", nil];
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    if(self.delegate)
    {
        [self.delegate backButtonPressedAction];
    }
}

-(IBAction)switchValueChanged:(UISwitch*)sender
{
    if(sender == alarmSwitch)
    {
        [motionSwitch setOn:!sender.isOn animated:YES];
    }
    else if(sender == motionSwitch)
    {
        [alarmSwitch setOn:!sender.isOn animated:YES];
    }
    [self changeClockTimeAndLabelAlarmSwitchOn:alarmSwitch.isOn];
}

-(void)changeClockTimeAndLabelAlarmSwitchOn:(BOOL)value
{
    [UIView animateWithDuration:0.35f animations:^{
        alarmTimeField.alpha = alarmClockLabel.alpha = value ? 1.0f : 0.0f;
    }];
}

-(IBAction)timePickerValueChanged:(UIDatePicker*)sender
{
    alarmTimeField.text = [df stringFromDate:alarmTimePicker.date];
}

-(void)donePickingTime
{
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goUpView:self.view ForTextField:textField];
    }
    else
    {
        [self commitAnimationsToViewFrameWithYValue:-100];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(kIsThreePointFiveInch)
    {
        [UserDefaultsManager goDownView:self.view];
    }
    else
    {
        [self commitAnimationsToViewFrameWithYValue:0];
    }
}

-(void)commitAnimationsToViewFrameWithYValue:(int)_value
{
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = _value;
        self.view.frame = frame;
    }];
}

@end
