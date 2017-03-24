//
//  NSDate+Extension.h
//  MyPosition
//
//  Created by World on 11/17/13.
//  Copyright (c) 2013 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

-(int)hour;
-(int)minute;
-(int)year;

-(int)timeIntervalSinceMidnight;
+(NSDate*)firstDateOfYear:(int)year;

@end
