//
//  ActivityBalanceRowView.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSheet.h"

@interface ActivityBalanceRowView : UIView {
	UIView *rowView;
	
	UILabel *activityLabel;
	UILabel *allowanceLabel;
	UILabel *dateLabel;
	UILabel *appliedLabel;
	UILabel *balanceLabel;
	
	BOOL isHeader;
	BOOL isTotal;
	
	int totalApplied;
	float allowanceHours;
}

@property (nonatomic, retain) IBOutlet UIView *rowView;

@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) IBOutlet UILabel *allowanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *appliedLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;

@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) BOOL isTotal;
@property (nonatomic, assign) int totalApplied;
@property (nonatomic, assign) float allowanceHours;

-(void) bindDataToView:(TimeSheet*)timeSheet;

@end
