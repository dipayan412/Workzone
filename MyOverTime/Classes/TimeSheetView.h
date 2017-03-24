//
//  TimeSheetView.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeSheetDelegate;

@class Activity;

@class TimeSheet;
 
@interface TimeSheetView : UIView <UITextFieldDelegate>
{
	UIView *timeSheet;
	
	UILabel *activityLabel;
	UILabel *startTimeLabel;
	UILabel *endTimeLabel;
	UILabel *breakTimeLabel;
	UILabel *flatTimeLabel;
	
	UILabel *titleStartTimeLabel;
	UILabel *titleEndTimeLabel;
	UILabel *titleBreakLabel;
	UILabel *titleFlatLabel;
	
	UIButton *startTimeButton;
	UIButton *endTimeButton;
	UIButton *breakButton;
	UIButton *flatHoursButton;
	
	UIButton *checkInButton;
	UIButton *checkOutButton;
    
    UITextField *amountField;
    UILabel *amountLabel;
	
	BOOL showTimeBtns;
    
    BOOL showAmount;
    
    UIImageView *amountImageView;
    
    UIButton *commentsButton;
	
	@private id<TimeSheetDelegate> delegate;

}

@property (nonatomic, retain) IBOutlet UIView *timeSheet;

@property (nonatomic, retain) IBOutlet UIButton *commentsButton;

@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *breakTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *flatTimeLabel;

@property (nonatomic, retain) IBOutlet UILabel *titleStartTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleEndTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleBreakLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleFlatLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;

@property (nonatomic, retain) IBOutlet UIButton *startTimeButton;
@property (nonatomic, retain) IBOutlet UIButton *endTimeButton;
@property (nonatomic, retain) IBOutlet UIButton *breakButton;
@property (nonatomic, retain) IBOutlet UIButton *flatHoursButton;

@property (nonatomic, retain) IBOutlet UIButton *checkInButton;
@property (nonatomic, retain) IBOutlet UIButton *checkOutButton;

@property (nonatomic, retain) IBOutlet UIImageView *amountImageView;


@property (nonatomic, retain) IBOutlet UITextField *amountField;

@property (nonatomic, assign) id<TimeSheetDelegate> delegate;

- (IBAction) showSelectActivityView:(id)sender;
- (IBAction) showSelectStartTimeView:(id)sender;
- (IBAction) showSelectEndTimeView:(id)sender;
- (IBAction) showSelectBreakTimeView:(id)sender;
- (IBAction) showSelectFlatTimeView:(id)sender;
- (IBAction) checkInAction:(id)sender;
- (IBAction) checkOutAction:(id)sender;
- (IBAction) showCommentsWindow:(id)sender;
- (IBAction) copyLastSheet:(id)sender;

- (void) setTimeSheetData:(TimeSheet*)cTimeSheet;
- (void) changeActivity:(Activity*)activity;
- (void) setShowTimeButtons:(BOOL)cond;
-(void)setShowAmountInfo:(BOOL)_info;

@end

@protocol TimeSheetDelegate <NSObject>
- (void) showSelectActivityDelegate:(id)sender;
- (void) showSelectStartTimeDelegate:(id)sender;
- (void) showSelectEndTimeDelegate:(id)sender;
- (void) showSelectBreakTimeDelegate:(id)sender;
- (void) showSelectFlatTimeDelegate:(id)sender;
- (void) setCheckInTimeDelegate:(id)sender;
- (void) setCheckOutTimeDelegate:(id)sender;
- (void) showCommentsWindowDelegate:(id)sender;
-(void)timeSheetAmountFieldDidBeginEditing;
-(void)timeSheetAmountDidEndEditing:(NSString*)_amount;

@end

