//
//  NSDate+Extension.m
//  WakeUp
//
//  Created by World on 7/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

-(BOOL) matchesDateWith:(NSDate*)otherDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *firstDate = [df stringFromDate:self];
    NSString *secondDate = [df stringFromDate:otherDate];
    
    return ([firstDate isEqualToString:secondDate]);
}

-(int) hour12
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"hh";
    
    return [df stringFromDate:self].intValue;
}

-(int) minute
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"mm";
    
    return [df stringFromDate:self].intValue;
}

-(NSString*)mm
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"mm";
    
    return [df stringFromDate:self];
}

-(NSString*) am_pm
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"a";
    
    return [df stringFromDate:self];
}

@end
