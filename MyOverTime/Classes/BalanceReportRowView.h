//
//  BalanceReportRowView.h
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Schedule;

@interface BalanceReportRowView : UIView 
{
	UIView *rowView;
	
	UILabel *weekdayLabel;
	UILabel *dateLabel;
	UILabel *totalLabel;
	UILabel *offsetLabel;
	UILabel *balanceLabel;
}

@property (nonatomic, retain) IBOutlet UIView *rowView; 

@property (nonatomic, retain) IBOutlet UILabel *weekdayLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *offsetLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;

-(void) bindDataToView:(Schedule*)schedule;

@end
