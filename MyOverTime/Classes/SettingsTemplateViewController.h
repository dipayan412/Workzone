//
//  SettingsTemplateViewController.h
//  MyOvertime
//
//  Created by Ashif on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "TimeSheetView.h"
#import "GlobalFunctions.h"
#import "Schedule.h"
#import "SettingsDayTemplate.h"
#import "GlobalFunctions.h"

@interface SettingsTemplateViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, TimeSheetDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
{
    UITableViewCell *dateDetailsCell;
    UITableViewCell *offsetDetailsCell;
    
    UIScrollView *scrollDateDetails;
	
	IBOutlet UILabel *pagingText;
    IBOutlet UILabel *offsetLabel;
	
	UIView *offsetSelectView;
	UIPickerView *offsetSelectPicker;
	
	NSArray *hoursPickerData;
	NSArray *minutesPickerData;
	NSArray *hoursPickerDateAMMode;
	NSArray *amPMPickerData;
	
	UIView *activitySelectView;
	UIPickerView *activitySelectPicker;
	NSArray *activitiesPickerData;
	
	UIView *startTimeSelectView;
	UIPickerView *startTimeSelectPicker;
	
	UIView *endTimeSelectView;
	UIPickerView *endTimeSelectPicker;
	
	UIView *breakTimeSelectView;
	UIPickerView *breakTimeSelectPicker;
	
	UIView *flatTimeSelectView;
	UIPickerView *flatTimeSelectPicker;
	
	NSInteger currentPage;
	NSInteger amountPage;
	NSMutableArray *timeSheetsArray;
	
	NSMutableDictionary *settingsDictionary;
	
	BOOL is24hoursMode;
	
	NSManagedObjectContext *managedObjectContext;
	
	Schedule *currentSchedule;
	
	NSMutableArray *timeSheetModels;
	
	IBOutlet UIButton *removeButton;
    NSInteger countForward,countBackward;
    
    // rykosoft: March fix, new feature 4
    TimeSheet * lastTimeSheet;
	
	UIView *commentsView;
	UITextView *commentsTextView;
    BOOL isZeroAdjustment;
    
    //Ashif
    
    BOOL isFlatTimePickerOn;
    BOOL setTimeForFlatHours;
    
    SettingsDayTemplate *dayTemplate;
    
    TimeStyle timeStyle;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *dateDetailsCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *offsetDetailsCell;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDateDetails;

@property (nonatomic, retain) SettingsDayTemplate *dayTemplate;

@property (nonatomic, retain) NSArray *hoursPickerData;
@property (nonatomic, retain) NSArray *minutesPickerData;
@property (nonatomic, retain) NSArray *hoursPickerDateAMMode;
@property (nonatomic, retain) NSArray *amPMPickerData;

@property (nonatomic, retain) IBOutlet UIView *activitySelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *activitySelectPicker;
@property (nonatomic, retain) NSArray *activitiesPickerData;

@property (nonatomic, retain) IBOutlet UIView *startTimeSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *startTimeSelectPicker;

@property (nonatomic, retain) IBOutlet UIView *endTimeSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *endTimeSelectPicker;

@property (nonatomic, retain) IBOutlet UIView *breakTimeSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *breakTimeSelectPicker;

@property (nonatomic, retain) IBOutlet UIView *flatTimeSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *flatTimeSelectPicker;

@property (nonatomic, retain) IBOutlet UIView *offsetSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *offsetSelectPicker;

@property (nonatomic, retain) NSMutableArray *timeSheetsArray;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) Schedule *currentSchedule;

@property (nonatomic, retain) NSMutableArray *timeSheetModels;

@property (nonatomic, retain) IBOutlet UIView *commentsView;
@property (nonatomic, retain) IBOutlet UITextView *commentsTextView;

- (IBAction) showSelectOffsetView:(id)sender;
- (IBAction) hideSelectOffsetView:(id)sender;

- (IBAction) showSelectActivityView:(id)sender;
- (IBAction) hideSelectActivityView:(id)sender;

- (IBAction) showSelectStartTimeView:(id)sender;
- (IBAction) hideSelectStartTimeView:(id)sender;

- (IBAction) showSelectEndTimeView:(id)sender;
- (IBAction) hideSelectEndTimeView:(id)sender;

- (IBAction) showSelectBreakTimeView:(id)sender;
- (IBAction) hideSelectBreakTimeView:(id)sender;

- (IBAction) showSelectFlatTimeView:(id)sender;
- (IBAction) hideSelectFlatTimeView:(id)sender;

- (IBAction) showCommentsWindow:(id)sender;
- (IBAction) hideCommentsWindow:(id)sender;

- (IBAction) forwardAction:(id)sender;
- (IBAction) backAction:(id)sender;

- (IBAction) addSheetAction:(id)sender;
- (IBAction) removeSheetAction:(id)sender;

@end
