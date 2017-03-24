//
//  ActivityDetailViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Activity;

@interface ActivityDetailViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
{
	UITextField *activityTitle;
	UISwitch *flatModeSwitch;
	UITextField *allowanceHours;
    UIView *activityDetailCell;
	
	Activity *currentActivity;
	NSManagedObjectContext *managedObjectContext;
	
	UIButton *estimateModePlus;
	UIButton *estimateModeMinus;
	
	BOOL isNew;
    
    // Ashif
    
    UIButton *selectOffsetButton;
    
    IBOutlet UITextField *amountField;
    IBOutlet UISwitch *showAmountSwitch;
    
    UIButton *defaultButton;
	UIButton *offsetButton;
    
    UILabel *offsetLabel;
    BOOL flatTimeSetToDefault;
    
    IBOutlet UISwitch *overTimeReducer;
    
    UIView *offsetSelectView;
	UIPickerView *offsetSelectPicker;
    
    CGFloat amount;
    
    NSNumber *offset;
}

@property (nonatomic, retain) NSDictionary *settingsDictionary;

@property (nonatomic, retain) IBOutlet UITextField *activityTitle;
@property (nonatomic, retain) IBOutlet UITextField *allowanceHours;
@property (nonatomic, retain) IBOutlet UISwitch *flatModeSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *overTimeReducer;

@property (nonatomic, retain) IBOutlet UIView *activityDetailCell;
@property (nonatomic, retain) Activity *currentActivity;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UIButton *estimateModePlus;
@property (nonatomic, retain) IBOutlet UIButton *estimateModeMinus;

@property (nonatomic, retain) IBOutlet UIButton *defaultButton;
@property (nonatomic, retain) IBOutlet UIButton *offsetButton;

@property (nonatomic, retain) IBOutlet UIButton *selectOffsetButton;

@property (nonatomic, retain) IBOutlet UILabel *offsetLabel;

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic, retain) NSNumber *offset;

@property (nonatomic, retain) IBOutlet UIView *offsetSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *offsetSelectPicker;

-(IBAction)changeDefaultSelectedCheckbox:(id)sender;
- (IBAction) showSelectOffsetView:(id)sender;
- (IBAction) hideSelectOffsetView:(id)sender;

- (IBAction) changeSelectedCheckbox:(id)sender;
- (IBAction)flatModeSwitchValueChanged:(id)sender;
- (IBAction)showAmountStateChanged:(id)sender;

-(IBAction)overTimeReducerValueChanged:(id)sender;

-(IBAction)testTapped:(id)sender;

@end
