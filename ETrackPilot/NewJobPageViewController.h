//
//  NewJobPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewJobPageViewController : UIViewController
<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
    
    IBOutlet UITextField *customerNameField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *contactField;
    IBOutlet UITextField *phoneNumberField;
    IBOutlet UITextField *dueDateField;
    IBOutlet UITextField *statusField;
    
    IBOutlet UITextView *detailsEditView;
    IBOutlet UITextView *notesTextView;
    
    IBOutlet UIPickerView *statusPicker;
    IBOutlet UIDatePicker *datePicker;
    
}

- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;

-(IBAction)backgroundTap:(id)sender;

@end
