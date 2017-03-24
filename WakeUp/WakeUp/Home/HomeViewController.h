//
//  HomeViewController.h
//  WakeUp
//
//  Created by World on 6/10/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *alarmTextField;
    IBOutlet UIButton *setAlarmButton;
    IBOutlet UIDatePicker *alarmDatePicker;
}

-(IBAction)setAlarmButtonAction:(UIButton*)sender;
-(IBAction)alarmDataChangedTo:(UIDatePicker*)sender;
@end
