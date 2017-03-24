//
//  FuelPurchasePageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuelPurchasePageViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *postalCodeField;
    IBOutlet UITextField *odometerField;
    IBOutlet UITextField *gallonsField;
    IBOutlet UITextField *TotalSpentField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *deviceField;
        
    IBOutlet UIPickerView *devicePicker;
    IBOutlet UIPickerView *statePicker;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    
    NSArray *textFields;
}
- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
