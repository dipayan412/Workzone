//
//  ActivityReportRowView.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Schedule;
@class TimeSheet;

@interface ActivityReportRowView : UIView {
	UIView *rowView;
	
	UILabel *dateLabel;
	UILabel *activityLabel;
	UILabel *totalLabel;
    UILabel *startLabel;
    UILabel *endLabel;
	UILabel *offsetLabel;
	UILabel *balanceLabel;
	UILabel *commentsLabel;
    UILabel *amountLabel;
	
	NSNumber *currentOffset;
	
	BOOL isHeader;
    
    BOOL is24HourMode;
    BOOL setTimeForFlatHours;
}

@property (nonatomic, retain) IBOutlet UIView *rowView;
@property (nonatomic) NSInteger totalValue,totalValue2;

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *offsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentsLabel;

@property (nonatomic, retain) NSNumber *currentOffset;
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) BOOL isFiltered;

-(void) bindDataToView:(Schedule*)schedule withTimeSheet:(TimeSheet*)timeSheet;
-(void) bindTimeSheetToView:(TimeSheet*)timeSheet;
-(void) bindTotalToView:(Schedule*)schedule withTotal:(int)cTotal andAmount:(CGFloat)_amount;
-(void)bindFooterToViewwithHours:(int)totalHours withOffset:(int)totalOffset withBalance:(NSString*)totalBalance withAmount:(CGFloat)totalAmomount;
-(void)setis24HourMode:(BOOL)_is24HourMode;

@end
