//
//  VerificationViewController.h
//  WakeUp
//
//  Created by World on 6/27/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *selectCountryField;
    IBOutlet UITextField *phoneNumberField;
    
    IBOutlet UILabel *countryCodeLabel;
    
    IBOutlet UIPickerView *countryPicker;
}
-(IBAction)veriFyButtonAction:(UIButton*)sender;

@end
