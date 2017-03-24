//
//  DriverStatusViewController.h
//  ETrackPilot
//
//  Created by World on 7/23/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverStatusViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UILabel *DriverStatusLabel;
    IBOutlet UILabel *latLngLocationLabel;
    
    IBOutlet UIButton *viewHistoryButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *zipCodeField;
    IBOutlet UITextField *odometerField;
    IBOutlet UITextField *statusField;
    
    IBOutlet UIPickerView *statePicker;
    IBOutlet UIPickerView *statusPicker;
}
- (IBAction)viewHistoryButtonAction:(UIButton *)sender;
- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
