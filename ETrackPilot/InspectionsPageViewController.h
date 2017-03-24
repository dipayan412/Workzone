//
//  InspectionsPageViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionsPageViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDataSource>
{
    IBOutlet UITextField *deviceField;
    IBOutlet UITextField *odometerField;
    IBOutlet UITextField *inspectionField;
    
    IBOutlet UITableView *inspectionItemTableView;
    
    IBOutlet UIPickerView *devicePicker;
    IBOutlet UIPickerView *inspectionPicker;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
}

@property (nonatomic, retain) NSArray *inspectionItems;

- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
