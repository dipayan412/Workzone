//
//  HomeViewController.m
//  WakeUp
//
//  Created by World on 6/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "UserDefaultsManager.h"
#import "RightViewController.h"

@interface HomeViewController ()
{
    
}

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation HomeViewController

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
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         [self motionMethod:motion];
     }];
    
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"|||" style:UIBarButtonItemStylePlain target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = btn;
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
    NSLog(@"%f",deviceMotion.magneticField.field.y);
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

-(IBAction)setAlarmButtonAction:(UIButton*)sender
{
    if([alarmTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Select a time first"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    [alarmTextField resignFirstResponder];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
//    if([UIDevice currentDevice].systemVersion.intValue >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound| UIUserNotificationTypeAlert| UIUserNotificationTypeBadge) categories:nil]];
//    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [UserDefaultsManager setAlarmTime:[df dateFromString:[df stringFromDate:alarmDatePicker.date]]];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [UserDefaultsManager alarmTime];
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.alertBody = @"Its time to Wake Up !!!";
    localNotification.alertAction = @"Go to app";
    localNotification.soundName = @"sound.caf";//UILocalNotificationDefaultSoundName;
    localNotification.hasAction = YES;
    localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"WakeUpAlert", @"wakeup", nil];
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(IBAction)alarmDataChangedTo:(UIDatePicker*)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm";
    NSString *dateStr = [df stringFromDate:alarmDatePicker.date];
    
    alarmTextField.text = dateStr;
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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [alarmTextField resignFirstResponder];
    return YES;
}

-(void)backButton
{
    RightViewController *nc = (RightViewController *)self.navigationController;
    [nc openDrawerView];
}

@end
