//
//  NSDate+Extension.m
//  MyPosition
//
//  Created by World on 11/17/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


-(int)hour
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"hh";
    
    return [[df stringFromDate:self] intValue];
}

-(int)minute
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"mm";
    
    return [[df stringFromDate:self] intValue];
}

-(int)year
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    return [[df stringFromDate:self] intValue];
}

-(int)timeIntervalSinceMidnight
{
    return ((int)[self timeIntervalSince1970]) % (24 * 3600);
}

+(NSDate*)firstDateOfYear:(int)year
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy";
    return [df dateFromString:[NSString stringWithFormat:@"%d", year]];
}

@end
