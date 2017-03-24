//
//  Schedule.m
//  MyOvertime
//
//  Created by Ashif on 6/8/13.
//
//

#import "Schedule.h"
#import "MyTemplate.h"
#import "SettingsDayTemplate.h"
#import "TimeSheet.h"


@implementation Schedule

@dynamic offset;
@dynamic scheduleDate;
@dynamic identifier;
@dynamic myTemplate;
@dynamic timeSheets;
@dynamic settingsDayTemplate;

@synthesize weekNumber;
@synthesize monthNumber,yearNumber;
@synthesize weekNumberSince2010,monthNumberSince2010;

-(void)makeDateComponents
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    gregorian.firstWeekday = 2; // Sunday = 1, Saturday = 7
    
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.scheduleDate];
    self.weekNumber = [components weekOfYear];
    self.monthNumber = [components month];
    self.yearNumber = [components year];
    int baseYr=kBaseYear;
    self.weekNumberSince2010=self.weekNumber+52*(self.yearNumber-baseYr);
    self.monthNumberSince2010=self.monthNumber+12*(self.yearNumber-baseYr);
    
    //NSLog(@"xear %d",weekNumberSince2010);
}


@end
