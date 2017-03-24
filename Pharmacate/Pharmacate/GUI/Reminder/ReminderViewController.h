//
//  ReminderViewController.h
//  Pharmacate
//
//  Created by Dipayan Banik on 6/21/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController
{
    IBOutlet UIView *detailsView;
    IBOutlet UIView *reminderView;
    
    IBOutlet UITextField *strengthTextField;
    IBOutlet UITextField *typeTextField;
    IBOutlet UITextField *frequencyTextField;
    IBOutlet UITextField *noteTextField;
    IBOutlet UITextField *timeTextField;
    
    IBOutlet UIDatePicker *timePicker;
    IBOutlet UIPickerView *frequencyPicker;
    IBOutlet UIPickerView *typePicker;
}

-(IBAction)backButtonAction:(UIButton*)sender;
-(IBAction)timePickerValueChanged:(UIDatePicker*)sender;

@end
