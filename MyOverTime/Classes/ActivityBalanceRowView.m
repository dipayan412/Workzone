//
//  ActivityBalanceRowView.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivityBalanceRowView.h"
#import "Schedule.h"
#import "TimeSheet.h"
#import "Activity.h"
#import "GlobalFunctions.h"

@interface ActivityBalanceRowView (PrivateMethods)
- (NSString*) convertPeriodToString:(int)period;
@end

@implementation ActivityBalanceRowView

@synthesize rowView;

@synthesize activityLabel, allowanceLabel, dateLabel, appliedLabel, balanceLabel;

@synthesize isHeader, isTotal, totalApplied, allowanceHours;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"ActivityBalanceRowView" owner:self options:nil];
		[self addSubview:rowView];
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

- (void)dealloc {
    [rowView release];
	
	[activityLabel release];
	[allowanceLabel release];
	[dateLabel release];
	[appliedLabel release];
	[balanceLabel release];
	
	[super dealloc];
}

-(void) bindDataToView:(TimeSheet*)timeSheet
{
	if (isTotal)
    {
		activityLabel.text = NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"");;
		allowanceLabel.text = [self convertPeriodToString:allowanceHours*60];
		appliedLabel.text = [self convertPeriodToString:totalApplied];
        /*
        if(totalApplied < 0)
        {
            balanceLabel.text = [self convertPeriodToString:(allowanceHours*60 + totalApplied)];
        }
        else
        {
            balanceLabel.text = [self convertPeriodToString:(allowanceHours*60 - totalApplied)];
        }
        
        */
        
        balanceLabel.text = [self convertPeriodToString:(allowanceHours*60 - totalApplied)];
		return;
	}	
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //NSLog(@"region:%@",[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier]);
    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
    if ([string isEqualToString:@"en_GB"]) {
        [dateFormatter setDateFormat:@"dd/MM/YY"];
    }	
    else if ([string isEqualToString:@"sv_SE"]) {
        [dateFormatter setDateFormat:@"YY-MM-dd"];
    }
    else if ([string isEqualToString:@"en_US"]) {
        [dateFormatter setDateFormat:@"MM/dd/YY"];
    }
    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
        [dateFormatter setDateFormat:@"dd.MM.YY"];
    }
    dateLabel.text = [dateFormatter stringFromDate:timeSheet.schedule.scheduleDate];	
	[dateFormatter release];

	if (isHeader)
    {
		activityLabel.text = timeSheet.activity.activityTitle;
	}
    else
    {
		activityLabel.text = @"\"\"";
	}
	
	if ([timeSheet.activity.flatMode boolValue])
    {
        /*
        if(timeSheet.activity.overtimeReduce.boolValue)
        {
            appliedLabel.text = [self convertPeriodToString:(- 1 * [timeSheet.flatTime intValue])];
        }
        else
        {
            appliedLabel.text = [self convertPeriodToString:[timeSheet.flatTime intValue]];
        }
        */
        appliedLabel.text = [self convertPeriodToString:[timeSheet.flatTime intValue]];
	}
    else
    {
		appliedLabel.text = [self convertPeriodToString:([timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue])];
	}	
	
}	

- (NSString*) convertPeriodToString:(int)period
{
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
	if (period < 0)
    {
		period *= (-1);
		
		int hours = floor(period/60.0);
		int minutes = period - hours * 60;
        
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
		
       // minutes = (100 * minutes)/60.0;
        
        if(timeStyle != StyleDecimal)
        {
            if (hours != 0)
            {
                if (minutes < 10)
                {
                    return [NSString stringWithFormat:@"-%d.0%d", hours, minutes];
                }
                else
                {
                    return [NSString stringWithFormat:@"-%d.%d", hours, minutes];
                }
            }
            else
            {
                if (minutes < 10)
                {
                    return [NSString stringWithFormat:@"-.0%d", minutes];
                }
                else
                {
                    return [NSString stringWithFormat:@"-.%d", minutes];
                }			
            }
        }
        else
        {
            return [NSString stringWithFormat:@"-%0.2f", decimalHours];
        }
	}
    else
    {
		int hours = floor(period/60.0);
		int minutes = period - hours * 60;
        
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
        
        if(timeStyle != StyleDecimal)
        {
            if (hours != 0)
            {
                if (minutes < 10)
                {
                    return [NSString stringWithFormat:@"%d.0%d", hours, minutes];
                }
                else
                {
                    return [NSString stringWithFormat:@"%d.%d", hours, minutes];
                }
            }
            else
            {
                if (minutes < 10)
                {
                    return [NSString stringWithFormat:@".0%d", minutes];
                }
                else
                {
                    return [NSString stringWithFormat:@".%d", minutes];
                }
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%0.2f", decimalHours];
        }
	}
}


@end
