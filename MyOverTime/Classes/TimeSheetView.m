//
//  TimeSheetView.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "TimeSheetView.h"
#import "Activity.h"
#import "TimeSheet.h"

@implementation TimeSheetView

@synthesize commentsButton;

@synthesize timeSheet, delegate;
@synthesize activityLabel;

@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize breakTimeLabel;
@synthesize flatTimeLabel;
@synthesize amountLabel;

@synthesize titleStartTimeLabel, titleEndTimeLabel, titleBreakLabel, titleFlatLabel;
@synthesize startTimeButton, endTimeButton, breakButton, flatHoursButton;
@synthesize checkInButton, checkOutButton;

@synthesize amountField;
@synthesize amountImageView;

- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TimeSheetView" owner:self options:nil];
		[self addSubview:timeSheet];
        
        amountField.frame = CGRectMake(amountField.frame.origin.x, amountField.frame.origin.y, 100, amountField.frame.size.height);
        amountField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        amountField.font = [UIFont systemFontOfSize:17];
        amountField.returnKeyType = UIReturnKeyDone;
        amountField.textAlignment = UITextAlignmentCenter;
        amountField.enablesReturnKeyAutomatically = YES;
        
        startTimeButton.enabled =
        endTimeButton.enabled =
        breakButton.enabled =
        flatHoursButton.enabled =
        amountField.enabled = NO;
        
        /*
        CGRect frame = commentsButton.frame;
        frame.size.width = 30;
        frame.size.height = 30;
        commentsButton.frame = frame;
        */
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (IBAction) showSelectActivityView:(id)sender{
	[self.delegate showSelectActivityDelegate:sender];
}	

- (IBAction) showSelectStartTimeView:(id)sender {
	[self.delegate showSelectStartTimeDelegate:sender];
}	

- (IBAction) showSelectEndTimeView:(id)sender {
	[self.delegate showSelectEndTimeDelegate:sender];
}	

- (IBAction) showSelectBreakTimeView:(id)sender {
	[self.delegate showSelectBreakTimeDelegate:sender];
}	

- (IBAction) showSelectFlatTimeView:(id)sender {
	[self.delegate showSelectFlatTimeDelegate:sender];
}	

- (IBAction) checkInAction:(id)sender {
	[self.delegate setCheckInTimeDelegate:sender];
}	

- (IBAction) checkOutAction:(id)sender {
	[self.delegate setCheckOutTimeDelegate:sender];
}	

- (IBAction) showCommentsWindow:(id)sender {
	[self.delegate showCommentsWindowDelegate:sender];
}

- (IBAction) copyLastSheet:(id)sender {
	[self.delegate showCommentsWindowDelegate:sender];    
}

- (void) setTimeSheetData:(TimeSheet*)cTimeSheet {
	activityLabel.text = cTimeSheet.activity.activityTitle;
	
	startTimeLabel.text = [cTimeSheet.startTime stringValue];
	endTimeLabel.text = [cTimeSheet.endTime stringValue];
	breakTimeLabel.text = [cTimeSheet.breakTime stringValue];
	
	flatTimeLabel.text = [cTimeSheet.flatTime stringValue];
}	

- (void) changeActivity:(Activity*)activity
{
	activityLabel.text = activity.activityTitle;
	if ([activity.flatMode boolValue])
    {
		startTimeLabel.hidden =
		endTimeLabel.hidden =
		breakTimeLabel.hidden = YES;
		
		titleStartTimeLabel.hidden =
		titleEndTimeLabel.hidden =
		titleBreakLabel.hidden = YES;
		
		startTimeButton.hidden =
		endTimeButton.hidden =
		breakButton.hidden = YES;
		
		checkInButton.hidden =
		checkOutButton.hidden = YES;
		
		titleFlatLabel.hidden =
		flatHoursButton.hidden =
		flatTimeLabel.hidden = NO;
        
        amountField.hidden =
        amountLabel.hidden =
        amountImageView.hidden = NO;
        
        amountField.enabled =
        flatHoursButton.enabled = YES;
	}
    else
    {
		startTimeLabel.hidden = NO;
		endTimeLabel.hidden = NO;
		breakTimeLabel.hidden = NO;
		
		titleStartTimeLabel.hidden = NO;
		titleEndTimeLabel.hidden = NO;
		titleBreakLabel.hidden = NO;
		
		startTimeButton.hidden = NO;
		endTimeButton.hidden = NO;
		breakButton.hidden = NO;

		checkInButton.hidden = NO;
		checkOutButton.hidden = NO;
		
		titleFlatLabel.hidden = YES;
		flatHoursButton.hidden = YES;
		flatTimeLabel.hidden = YES;
        
        amountField.hidden = YES;
        amountLabel.hidden = YES;
        amountImageView.hidden = YES;
        
        startTimeButton.enabled =
        endTimeButton.enabled =
        breakButton.enabled = YES;
	}
	
	if (!showTimeBtns)
    {
		checkInButton.hidden = YES;
		checkOutButton.hidden = YES;		
	}
    
    if(!activity.showAmount.boolValue)
    {
        amountLabel.hidden = YES;
        amountField.hidden = YES;
        amountImageView.hidden = YES;
    }
}

- (void) setShowTimeButtons:(BOOL)cond
{
	showTimeBtns = cond;
	
	checkInButton.hidden = !cond;
	checkOutButton.hidden = !cond;
}

-(void)setShowAmountInfo:(BOOL)_info
{
    showAmount = _info;
    
    amountLabel.hidden = showAmount;
    amountField.hidden = showAmount;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate timeSheetAmountFieldDidBeginEditing];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate timeSheetAmountDidEndEditing:textField.text];
    [textField resignFirstResponder];
}

- (void)dealloc
{
	[activityLabel release];
	[startTimeLabel release];	
	[endTimeLabel release];
	[breakTimeLabel release];
	[flatTimeLabel release];
	
	[titleStartTimeLabel release];
	[titleEndTimeLabel release];
	[titleBreakLabel release];
	[titleFlatLabel release];
	
	[startTimeButton release];
	[endTimeButton release];
	[breakButton release];
	[flatHoursButton release];	
	
	[checkInButton release];
	[checkOutButton release];
	
	[timeSheet release];
    
    [amountField release];
    [amountLabel release];
    
    [super dealloc];
}


@end
