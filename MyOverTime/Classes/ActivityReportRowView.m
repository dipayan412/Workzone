//
//  ActivityReportRowView.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivityReportRowView.h"
#import "Schedule.h"
#import "TimeSheet.h"
#import "Activity.h"
#import "Localizator.h"
#import "GlobalFunctions.h"

@interface ActivityReportRowView(PrivateMethods)
- (NSString*) convertPeriodToString:(int)period;	
@end


@implementation ActivityReportRowView
@synthesize isFiltered=_isFiltered;

@synthesize rowView;
@synthesize dateLabel, activityLabel, startLabel, endLabel, totalLabel, offsetLabel, balanceLabel, amountLabel, commentsLabel;
@synthesize currentOffset;

@synthesize isHeader;
@synthesize totalValue;
@synthesize totalValue2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[[NSBundle mainBundle] loadNibNamed:@"ActivityReportRowView" owner:self options:nil];
		[self addSubview:rowView];
        CGRect frame = activityLabel.frame;
        frame.origin.x = 80.0;
        frame.size.width = 92.0f;
        activityLabel.frame = frame;
        setTimeForFlatHours = NO;
        
        frame = amountLabel.frame;
        frame.origin.x += 5;
        frame.size.width = frame.size.width - 15;
        amountLabel.frame = frame;
        
        startLabel .textAlignment =
        endLabel.textAlignment =
        totalLabel.textAlignment =
        offsetLabel.textAlignment =
        balanceLabel.textAlignment =
        amountLabel.textAlignment = UITextAlignmentRight;
        commentsLabel.textAlignment = UITextAlignmentLeft;
//        activityLabel .textAlignment = UITextAlignmentCenter;
        activityLabel .textAlignment = UITextAlignmentLeft;
//        activityLabel.backgroundColor = [UIColor lightGrayColor];
        
        startLabel.minimumFontSize = 8.0f;
        startLabel.adjustsFontSizeToFitWidth = YES;
        
        endLabel.minimumFontSize = 8.0f;
        endLabel.adjustsFontSizeToFitWidth = YES;
        
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.minimumFontSize = 8.0;
        
        /*
        dateLabel.backgroundColor =
        activityLabel .backgroundColor =
        startLabel .backgroundColor =
        endLabel.backgroundColor =
        totalLabel.backgroundColor =
        offsetLabel.backgroundColor =
        balanceLabel.backgroundColor =
        amountLabel.backgroundColor =
        commentsLabel.backgroundColor = [UIColor lightGrayColor];
        */
        
    }
    return self;
}

-(void) bindDataToView:(Schedule*)schedule withTimeSheet:(TimeSheet*)timeSheet
{	
	self.currentOffset = schedule.offset;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
//    [dateFormatter setLocale:locale];

//    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//    if ([string isEqualToString:@"en_GB"])
//    {
//        [dateFormatter setDateFormat:@"dd/MM/YY"];
//    }
//    else if ([string isEqualToString:@"sv_SE"])
//    {
//        [dateFormatter setDateFormat:@"YY-MM-dd"];
//    }
//    else if ([string isEqualToString:@"en_US"])
//    {
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//    }
//    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"])
//    {
//        [dateFormatter setDateFormat:@"dd.MM.YY"];
//    }
    
    if ([[dateFormatter stringFromDate:schedule.scheduleDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
	dateLabel.text = [dateFormatter stringFromDate:schedule.scheduleDate];
	[dateFormatter release];
    
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.minimumFontSize = 8.0;
	
	activityLabel.text = timeSheet.activity.activityTitle;
    activityLabel.adjustsFontSizeToFitWidth = YES;
    activityLabel.minimumFontSize = 8.0;
	commentsLabel.text = timeSheet.comments;
    
    if(timeSheet.activity.flatMode.boolValue)
    {
        setTimeForFlatHours = YES;
        startLabel.text = NSLocalizedString(@"FLAT_STRING", nil);
        
        if(timeSheet.activity.overtimeReduce.boolValue)
        {
            endLabel.text =  [self convertPeriodToString:( -1 * timeSheet.flatTime.intValue)];
        }
        else
        {
            endLabel.text =  [self convertPeriodToString:timeSheet.flatTime.intValue];
        }
    }
    else
    {
        TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
        
        NSString * str = [NSString stringWithFormat:@"%@", [self convertTimeToString:timeSheet.startTime]];
        if(timeStyle != StyleDecimal) str = [str stringByReplacingOccurrencesOfString:@"." withString:@":"];
        startLabel.text =  str;
        str = [self convertTimeToString:timeSheet.endTime];
        if(timeStyle != StyleDecimal) str = [str stringByReplacingOccurrencesOfString:@"." withString:@":"];
        endLabel.text = str;
    }
    
    if(timeSheet.activity.flatMode.boolValue)
    {
        if(timeSheet.activity.showAmount.boolValue)
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
            
            amountLabel.text = [numberFormatter stringFromNumber:tmp];
        }
    }
	
	int total = 0;
	if ([timeSheet.activity.flatMode boolValue])
    {
		if ([timeSheet.flatTime intValue]<0)
        {
            /*
			totalLabel.text = [self convertPeriodToString:total];
			return;
             */
		}			
	}
    else
    {
		if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
        {
			totalLabel.text = [self convertPeriodToString:total];
			return;
		}
	}			
	
	if ([timeSheet.activity.estimateMode boolValue])
    {
		if ([timeSheet.activity.flatMode boolValue])
        {
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                total = - 1 * [timeSheet.flatTime intValue];
            }
            else
            {
                total = [timeSheet.flatTime intValue];
            }
		}
        else
        {
			if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
            {				total = 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
			}

            else
            {
				total = [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
			}					
			if ([timeSheet.breakTime intValue]>0)
            {
				total -= [timeSheet.breakTime intValue];
			}	
		}
	}
	totalValue=total;
	totalLabel.text = [self convertPeriodToString:totalValue2+totalValue];
	if (isHeader)
    {
		offsetLabel.text = [self convertPeriodToString:[currentOffset intValue]];
		balanceLabel.text = [self convertPeriodToString:(total - [currentOffset intValue])];
	}
}	

-(void) bindTimeSheetToView:(TimeSheet*)timeSheet
{	
	dateLabel.text = @"\"\"";	
	
	activityLabel.text = timeSheet.activity.activityTitle;
    activityLabel.adjustsFontSizeToFitWidth = YES;
    activityLabel.minimumFontSize = 8.0;
	commentsLabel.text = timeSheet.comments;

    if(timeSheet.activity.flatMode.boolValue)
    {
        setTimeForFlatHours = YES;
        
        if(timeSheet.activity.showAmount.boolValue)
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
            
            amountLabel.text = [numberFormatter stringFromNumber:tmp];
        }
    }
	
	int total = 0;
    
    if(timeSheet.activity.flatMode.boolValue)
    {
        startLabel.text = NSLocalizedString(@"FLAT_STRING", nil);
        
        if(timeSheet.activity.overtimeReduce.boolValue)
        {
            endLabel.text =  [self convertPeriodToString:( -1 * timeSheet.flatTime.intValue)];
        }
        else
        {
            endLabel.text =  [self convertPeriodToString:timeSheet.flatTime.intValue];
        }
    }
    else
    {
        TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
        
        NSString * str = [NSString stringWithFormat:@"%@", [self convertTimeToString:timeSheet.startTime]];
        if(timeStyle != StyleDecimal) str = [str stringByReplacingOccurrencesOfString:@"." withString:@":"];
        startLabel.text =  str;
        str = [self convertTimeToString:timeSheet.endTime];
        if(timeStyle != StyleDecimal)  str = [str stringByReplacingOccurrencesOfString:@"." withString:@":"];
        endLabel.text = str;
    }
    
	if ([timeSheet.activity.flatMode boolValue])
    {
		if ([timeSheet.flatTime intValue]<0)
        {
            /*
			totalLabel.text = [self convertPeriodToString:total];
			return;
            */
		}			
	}
    else
    {
		if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
        {
			totalLabel.text = [self convertPeriodToString:total];
			return;
		}
	}			
		
	if ([timeSheet.activity.estimateMode boolValue])
    {
		if ([timeSheet.activity.flatMode boolValue])
        {
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                total = - 1 * [timeSheet.flatTime intValue];
            }
            else
            {
                total = [timeSheet.flatTime intValue];
            }
		}
        else
        {
			if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
            {
				total = 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
			}
            else
            {
				total = [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
			}					
			if ([timeSheet.breakTime intValue]>0)
            {
				total -= [timeSheet.breakTime intValue];
			}	
		}
	}
    totalValue2=total;

	totalLabel.text = [self convertPeriodToString:totalValue2+totalValue];
}	

-(void) bindTotalToView:(Schedule*)schedule withTotal:(int)cTotal andAmount:(CGFloat)_amount
{
	dateLabel.text = NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @"");
	dateLabel.textAlignment = UITextAlignmentLeft;
		
	totalLabel.text = [self convertPeriodToString:cTotal];
	offsetLabel.text = [self convertPeriodToString:[schedule.offset intValue]];
	balanceLabel.text = [self convertPeriodToString:(cTotal - [schedule.offset intValue])];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    NSNumber *tmp = [[NSNumber alloc] initWithFloat:_amount];
    
    
//    amountLabel.text = [NSString stringWithFormat:@"%0.2f", _amount];
    amountLabel.text = [numberFormatter stringFromNumber:tmp];
}

-(void)bindFooterToViewwithHours:(int)totalHours withOffset:(int)totalOffset withBalance:(NSString*)totalBalance withAmount:(CGFloat)totalAmomount
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    NSNumber *tmp = [[NSNumber alloc] initWithFloat:totalAmomount];
    
    amountLabel.text = [numberFormatter stringFromNumber:tmp];
    
    NSString *amStr = [numberFormatter stringFromNumber:tmp];
    NSString *str = [NSString stringWithFormat:@"%@", amStr];
    
    dateLabel.text = NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", nil);
//    totalLabel.text = [self convertPeriodToString:totalHours];
    totalLabel.text = [self convertPeriodToString:totalHours];
    amountLabel.text = str;
    
    amountLabel.font =
    totalLabel.font =
    dateLabel.font =
    offsetLabel.font =
    balanceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    if(!_isFiltered)
    {
        offsetLabel.text = [self convertPeriodToString:totalOffset];
        balanceLabel.text = totalBalance;
    }
}

- (NSString*) convertTimeToString:(NSNumber*)time
{
	if ([time intValue]==-1)
    {
		return @"";
	}
	
	int hours = ([time intValue]/60.0);
	int minutes = [time intValue] - hours * 60;
	
	NSString *amPM = @"";
    
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
    //	if (!is24HourMode && !setTimeForFlatHours)
    if (timeStyle == StyleAmPm && !setTimeForFlatHours)
    {
		if (hours == 0 || hours == 24)
        {
            amPM = NSLocalizedString(@"LOCAL_AM", nil);
			hours = 12;
		}
        else if (hours == 12)
        {
            amPM = NSLocalizedString(@"LOCAL_PM", nil);
        }
        
        else  if (hours < 12)
        {
            amPM = NSLocalizedString(@"LOCAL_AM", nil);
		}
        else
        {
            amPM = NSLocalizedString(@"LOCAL_PM", nil);
			hours -= 12;
		}
	}
	
    if(timeStyle != StyleDecimal)
    {
        if ((minutes < 10)&&(hours < 10))
        {
            return [NSString stringWithFormat:@"%d:0%d %@", hours, minutes, amPM];
        }
        else if (minutes < 10)
        {
            return [NSString stringWithFormat:@"%d:0%d %@", hours, minutes, amPM];
        }
        else if (hours < 10)
        {
            return [NSString stringWithFormat:@"%d:%d %@", hours, minutes, amPM];
        }
        else
        {
            return [NSString stringWithFormat:@"%d:%d %@", hours, minutes, amPM];
        }
    }
    else
    {
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
        
        return [NSString stringWithFormat:@"%0.2f", decimalHours];
    }
}


- (NSString*) convertPeriodToString:(int)period
{
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
    if(timeStyle == StyleDecimal)
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            return [NSString stringWithFormat:@"-%0.2f", decimalHours];
        }
        else
        {
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            if (hours != 0)
            {
                return [NSString stringWithFormat:@"%0.2f",decimalHours];
            }
            else
            {
                return [NSString stringWithFormat:@"%0.2f",decimalHours];
            }
        }
    }
    else
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = (period/60.0);
            int minutes = period - hours * 60;
            
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
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
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
    }
}

-(void)setis24HourMode:(BOOL)_is24HourMode
{
    is24HourMode = _is24HourMode;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[rowView dealloc];
	
	[dateLabel release];
	[activityLabel release];
	[totalLabel release];
	[offsetLabel release];
	[balanceLabel release];
	[commentsLabel release];
	
	[super dealloc];
}

-(void)setIsFiltered:(BOOL)isFiltered
{
    _isFiltered=isFiltered;
    if (isFiltered)
    {
        offsetLabel.hidden=YES;
        balanceLabel.hidden=YES;
        CGRect frame= commentsLabel.frame;
        frame.origin.x=balanceLabel.frame.origin.x + 30;
        commentsLabel.frame=frame;
        
        frame= amountLabel.frame;
        frame.origin.x=offsetLabel.frame.origin.x + 10;
        amountLabel.frame=frame;
        
        balanceLabel.text=@"";
        offsetLabel.text=@"";
    }
}

@end
