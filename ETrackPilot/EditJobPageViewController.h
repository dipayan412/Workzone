//
//  EditJobPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditJobPageViewController : UIViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UILabel *customerNameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *contactLabel;
    IBOutlet UILabel *phoneLabel;
    IBOutlet UILabel *dueDateLabel;
    IBOutlet UILabel *detailsLabel;
    
    IBOutlet UITextView *notesTextView;
    
    IBOutlet UITextField *statusField;
    
    IBOutlet UIPickerView *statusPicker;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
}
- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
