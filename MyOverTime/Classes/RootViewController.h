//
//  RootViewController.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <StoreKit/StoreKit.h>
#import "TimeSheetView.h"
#import "CalendarSelectionDelegate.h"
#import "GlobalFunctions.h"

@class Schedule;

@interface RootViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource, TimeSheetDelegate, UITextViewDelegate, UIGestureRecognizerDelegate,
    CalendarSelectionDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
	UITableViewCell *dateIdentificationCell;
	UITableViewCell *dateDetailsCell;
	UIScrollView *scrollDateDetails;
	
	UIView *headerView;
	UILabel *userIdentificationLabel;
	
	UILabel *pagingText;
	
	UIView *totalResultsSection;
	UILabel *totalIndicatorLabel;
	UILabel *balanceIndicatorLabel;
	
	UILabel *currentDateLabel;
	UILabel *currentDateStringLabel;
	UILabel *currentOffsetLabel;
	
	UIView *dateSelectView;
	UIDatePicker *dateSelectPicker;
	
	UIView *offsetSelectView;
	UIPickerView *offsetSelectPicker;
	
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
	NSArray *workingDays;
	
	NSManagedObjectContext *managedObjectContext;
	
	Schedule *currentSchedule;
	NSDate *currentDate;
	
	NSMutableArray *timeSheetModels;
	
	UIButton *removeButton;
    NSInteger countForward,countBackward;
    
    // rykosoft: March fix, new feature 4
    IBOutlet UIButton *firstCheckin;
    IBOutlet UIButton *copyLastSheet;
    IBOutlet UIButton *myTemplareButton;
    IBOutlet UIButton *dayTemplateButton;
    TimeSheet * lastTimeSheet;
	
	UIView *inAppPurchaseView;
	UIView *waitingView;
	UIView *innerWaitingView;
	
	UIView *commentsView;
	UITextView *commentsTextView;
    BOOL isZeroAdjustment,checkBackup;
    
    //Ashif
    
    BOOL isFlatTimePickerOn;
    BOOL setTimeForFlatHours;
    
    NSArray *myTemplates;
    
    UIActionSheet *templateSheet;
    
    BOOL inAppLimitationAlertShown;
    
    TimeStyle timeStyle;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *dateIdentificationCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *dateDetailsCell;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDateDetails;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *userIdentificationLabel;

@property (nonatomic, retain) IBOutlet UILabel *pagingText;

@property (nonatomic, retain) IBOutlet UIView *totalResultsSection;
@property (nonatomic, retain) IBOutlet UILabel *totalIndicatorLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceIndicatorLabel;

@property (nonatomic, retain) IBOutlet UILabel *currentDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentDateStringLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentOffsetLabel;

@property (nonatomic, retain) IBOutlet UIView *dateSelectView;
@property (nonatomic, retain) IBOutlet UIDatePicker *dateSelectPicker;

@property (nonatomic, retain) IBOutlet UIView *offsetSelectView;
@property (nonatomic, retain) IBOutlet UIPickerView *offsetSelectPicker;

@property (nonatomic, retain) NSArray *myTemplates;

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

@property (nonatomic, retain) NSMutableArray *timeSheetsArray;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;
@property (nonatomic, retain) NSArray *workingDays;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) Schedule *currentSchedule;
@property (nonatomic, retain) NSDate *currentDate;

@property (nonatomic, retain) NSMutableArray *timeSheetModels;
@property (nonatomic, retain) IBOutlet UIButton *removeButton;

@property (nonatomic, retain) IBOutlet UIView *inAppPurchaseView;
@property (nonatomic, retain) IBOutlet UIView *waitingView;
@property (nonatomic, retain) IBOutlet UIView *innerWaitingView;

@property (nonatomic, retain) IBOutlet UIView *commentsView;
@property (nonatomic, retain) IBOutlet UITextView *commentsTextView;

- (IBAction) showSelectDateView:(id)sender;
- (IBAction) completeSelectDate:(id)sender;

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

- (IBAction) nextDay:(id)sender;
- (IBAction) previousDay:(id)sender;

- (IBAction) forwardAction:(id)sender;
- (IBAction) backAction:(id)sender;

- (IBAction) copyLastSheetAction:(id)sender;
- (IBAction) firstCheckinAction:(id)sender;
- (IBAction) insertDayTemplateAction:(id)sender;
- (IBAction) insertMyTemplateAction:(id)sender;
- (IBAction) addSheetAction:(id)sender;
- (IBAction) removeSheetAction:(id)sender;

- (IBAction) showInAppPurchaseView:(id)sender;
- (IBAction) hideInAppPurchaseView:(id)sender;
- (IBAction) purchaseCalendar:(id)sender;
-(void) updateAlertStatus;
- ( NSInteger ) safeTimeInterval;
-(BOOL )getProductStatus;
-(void) inAppLimitationCheck;
@end
