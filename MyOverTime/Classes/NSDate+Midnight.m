//
//  NSDate+Midnight.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 8/20/12.
//
//

#import "NSDate+Midnight.h"

@implementation NSDate (Midnight)
- (NSDate *)midnightUTC {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                   fromDate:self];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    [calendar release];
    
    return midnightUTC;
}
+(NSDate *)firstOfMonth:(NSDate *)today
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    
    return firstDayOfMonthDate;
}
+(NSDate *)lastOfMonth:(NSDate *)today
{
    // get a gregorian calendar
    NSCalendar *calendar=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    // get current month and year
    NSDateComponents *components=[calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:today];
    NSInteger month=[components month];
    NSInteger year=[components year];
    
    // set components to first day of next month
    if (month==12) {
        [components setYear:year+1];
        [components setMonth:1];
    }
    else {
        [components setMonth:month+1];
    }
    [components setDay:1];
    
    // get last day of this month by subtracting 1 day (86400 seconds) from first of next
    return [[calendar dateFromComponents:components] dateByAddingTimeInterval:-86400];
}
@end
