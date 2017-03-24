//
//  BalanceReportRowView.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "BalanceReportRowView.h"
#import "Schedule.h"
#import "TimeSheet.h"
#import "Activity.h"
#import "Localizator.h"
#import "MyOvertimeAppDelegate.h"
#import "GlobalFunctions.h"


@interface BalanceReportRowView(PrivateMethods)
- (NSString*) convertPeriodToString:(int)period;	
@end

@implementation BalanceReportRowView

@synthesize rowView;

@synthesize weekdayLabel, dateLabel, totalLabel, offsetLabel, balanceLabel;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"BalanceReportRowView" owner:self options:nil];
		[self addSubview:rowView];
        
        CGRect frame = weekdayLabel.frame;
        frame = CGRectMake(weekdayLabel.frame.origin.x, weekdayLabel.frame.origin.y, 75, weekdayLabel.frame.size.height);
        weekdayLabel.frame = frame;
        
        weekdayLabel.font = [UIFont systemFontOfSize:15];
        frame = dateLabel.frame;
        frame = CGRectMake(dateLabel.frame.origin.x - 8, dateLabel.frame.origin.y, dateLabel.frame.size.width, dateLabel.frame.size.height);
        dateLabel.frame = frame;
        dateLabel.adjustsFontSizeToFitWidth = YES;
        
        /*
        dateLabel.backgroundColor =
        offsetLabel.backgroundColor =
        balanceLabel.backgroundColor =
        totalLabel.backgroundColor = [UIColor lightGrayColor];
        */
        
        dateLabel.textAlignment =
        offsetLabel.textAlignment =
        balanceLabel.textAlignment =
        totalLabel.textAlignment = UITextAlignmentRight;
    }
    return self;
}

-(void) bindDataToView:(Schedule*)schedule
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
    [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
	weekdayLabel.text = [[dateFormatter stringFromDate:schedule.scheduleDate] capitalizedString];
	[dateFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
//    [dateFormatter setLocale:locale];
    
   // NSLog(@"region:%@",[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier]);
//    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//    if ([string isEqualToString:@"en_GB"]) {
//        [dateFormatter setDateFormat:@"dd/MM/YY"];
//    }
//    else if ([string isEqualToString:@"en_US"]) {
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//    }
//    else if ([string isEqualToString:@"sv_SE"]) {
//        [dateFormatter setDateFormat:@"YY-MM-dd"];
//    }
//    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
//        [dateFormatter setDateFormat:@"dd.MM.YY"];
//    }
    
    if ([[dateFormatter stringFromDate:schedule.scheduleDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
	dateLabel.text = [dateFormatter stringFromDate:schedule.scheduleDate];
    
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.minimumFontSize = 8.0;
    
	[dateFormatter release];

	int offset = [schedule.offset intValue];
	int total = 0;
	for (TimeSheet *timeSheet in schedule.timeSheets)
    {
		if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
        {
			continue;
		}
		
		if ([timeSheet.activity.flatMode boolValue])
        {
			if ([timeSheet.flatTime intValue]<0){
				continue;
			}			
		} else {
			if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0)){
				continue;
			}
		}			
				
		if ([timeSheet.activity.estimateMode boolValue])
        {
			if ([timeSheet.activity.flatMode boolValue])
            {
                if(timeSheet.activity.overtimeReduce.boolValue)
                {
                    total -= [timeSheet.flatTime intValue];
                }
                else
                {
                    total += [timeSheet.flatTime intValue];
                }
			}
            else
            {
				if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                {
					total += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
				}
                else
                {
					total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
				}					
				if ([timeSheet.breakTime intValue]>0)
                {
					total -= [timeSheet.breakTime intValue];
				}	
			}
		}
	}
	offsetLabel.text = [self convertPeriodToString:offset];
	totalLabel.text = [self convertPeriodToString:total];
	balanceLabel.text = [self convertPeriodToString:(total - offset)];
}	

- (NSString*) convertPeriodToString:(int)period
{
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
    if(timeStyle != StyleDecimal)
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = floor(period/60.0);
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
    else
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = floor(period/60.0);
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
            
            return [NSString stringWithFormat:@"%0.2f", decimalHours];
        }
    }
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
	
	[weekdayLabel release];
	[dateLabel release];
	[totalLabel release];
	[offsetLabel release];
	[balanceLabel release];
	
    [super dealloc];
}


@end
