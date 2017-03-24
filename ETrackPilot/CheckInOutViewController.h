//
//  CheckInOutViewController.h
//  ETrackPilot
//
//  Created by World on 7/8/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CheckInOutViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,CLLocationManagerDelegate>
{
    IBOutlet UILabel *checkInOutLabel;
    IBOutlet UILabel *dayTimeLabel;
    
    IBOutlet UITextField *odometerField;
    IBOutlet UIPickerView *devicePicker;
    
    IBOutlet UITextField *deviceField;
    
    IBOutlet UIButton *checkInButton;
    IBOutlet UIButton *checkOutButton;
    
    CLLocationManager *userLocationManager;
}
-(IBAction)checkInButtonAction:(UIButton *)sender;
-(IBAction)checkOutButtonAction:(UIButton *)sender;
-(IBAction)backgroundTap:(id)sender;

@end
