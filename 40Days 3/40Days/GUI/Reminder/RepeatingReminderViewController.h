//
//  RepeatingReminderViewController.h
//  40Days
//
//  Created by User on 4/25/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatingReminderViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
    NSArray *hoursPickerDateAMMode;
	NSArray *amPMPickerData;
    NSArray *minutesPickerData;
    
    IBOutlet UIView *timeSelectonView;
    IBOutlet UIPickerView *timePicker;
    
    IBOutlet UIView *dateSelectionView;
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIButton *timeSelectButton;
    IBOutlet UIButton *dateSelectButton;
    IBOutlet UIButton *createReminderButton;
    IBOutlet UIButton *cancelReminderButton;
    
    IBOutlet UIButton *mondayCheckbox;
    IBOutlet UIButton *tuesdayCheckbox;
    IBOutlet UIButton *wednesdayCheckbox;
    IBOutlet UIButton *thursdayCheckbox;
    IBOutlet UIButton *fridayCheckbox;
    IBOutlet UIButton *saturdayCheckbox;
    IBOutlet UIButton *sundayCheckbox;
}

- (IBAction)selectDate:(id)sender;
- (IBAction)selectTime:(id)sender;

- (IBAction)dateSelectionDone:(id)sender;
- (IBAction)timeSelectionDone:(id)sender;

- (IBAction)createReminder:(id)sender;
- (IBAction)cancelReminder:(id)sender;

- (IBAction) mondayCheckboxSelected:(id)sender;

@end
