//
//  SettingsViewController.m
//  WakeUp
//
//  Created by World on 6/16/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "SettingsViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "UserDefaultsManager.h"
#import "RightViewController.h"

@interface SettingsViewController ()
{
    BOOL isShowingController;
    NSDateFormatter *df;
}
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation SettingsViewController

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
    
    alarmTextField.inputView = alarmDatePicker;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1;
    
    self.view.backgroundColor = kAppBGColor;
    
//    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMDeviceMotion *motion, NSError *error)
//     {
//         [self motionMethod:motion];
//     }];
    
    self.navigationItem.title = @"Settings";
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor colorWithRed:1 green:192.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSettingSnooze)];
    [doneButton setTintColor:[UIColor whiteColor]];
    [toolBar setItems:[NSArray arrayWithObjects:space1 ,doneButton, space2, nil]];
    snoozeField.inputAccessoryView = alarmTextField.inputAccessoryView = toolBar;
    
    snoozeField.text = [NSString stringWithFormat:@"%d",[UserDefaultsManager snoozeInterval]];
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    if(![UserDefaultsManager motionAlarmTime])
    {
        NSString *dateString = @"05:30";
        [alarmDatePicker setDate:[df dateFromString:dateString]];
    }
    else
    {
        [alarmDatePicker setDate:[UserDefaultsManager motionAlarmTime]];
    }
    alarmTextField.text = [df stringFromDate:alarmDatePicker.date];
    
    updateButton.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:188.0f/255.0f blue:45.0f/255.0f alpha:1.0f];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateButton.layer.cornerRadius = 4.0f;
}

-(void)motionMethod:(CMDeviceMotion *)deviceMotion
{
    //    CMAcceleration userAcceleration = deviceMotion.userAcceleration;
    //    if (fabs(userAcceleration.x) > accelerationThreshold
    //        || fabs(userAcceleration.y) > accelerationThreshold
    //        || fabs(userAcceleration.z) > accelerationThreshold)
    //    {
    //        //Motion detected, handle it with method calls or additional
    //        //logic here.
    //        [self foo];
    //    }
    NSLog(@"%f",deviceMotion.rotationRate.x);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"motion motion");
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"a");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"b");
}

-(IBAction)updateButtonAction:(UIButton*)sender
{
    if([snoozeField.text intValue] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Interval can not be less than a minute"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [UserDefaultsManager setSnoozeInterval:[snoozeField.text intValue]];
    [UserDefaultsManager setMotionAlarmTime:alarmDatePicker.date];
    
    if([UserDefaultsManager isMotionDetectionOn])
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [UserDefaultsManager motionAlarmTime];
        localNotification.timeZone = [NSTimeZone localTimeZone];
        localNotification.alertBody = @"Its time to Wake Up !!!";
        localNotification.alertAction = @"Go to app";
        localNotification.soundName = @"sound.caf";//UILocalNotificationDefaultSoundName;
        localNotification.hasAction = YES;
        localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"WakeUpAlert", @"wakeup", nil];
        localNotification.repeatInterval = NSDayCalendarUnit;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Changes saved"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)alarmDataChangedTo:(UIDatePicker*)sender
{
    NSString *dateStr = [df stringFromDate:alarmDatePicker.date];
    alarmTextField.text = dateStr;
}

-(IBAction)backButtonAction:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.view endEditing:YES];
        [delegate showDrawerView];
    }
}

-(void)doneSettingSnooze
{
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [alarmDatePicker setDate:[[NSDate date] dateByAddingTimeInterval:60]];
//
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"HH:mm";
//    NSString *dateStr = [df stringFromDate:alarmDatePicker.date];
//
//    alarmTextField.text = dateStr;
    if(textField == snoozeField)
    {
        snoozeField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == snoozeField && [textField.text isEqualToString:@""])
    {
        snoozeField.text = [NSString stringWithFormat:@"%d",[UserDefaultsManager snoozeInterval]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [alarmTextField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([str intValue] > 60)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Interval must be less than an hour" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
