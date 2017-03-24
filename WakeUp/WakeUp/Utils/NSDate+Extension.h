//
//  NSDate+Extension.h
//  WakeUp
//
//  Created by World on 7/18/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

-(BOOL) matchesDateWith:(NSDate*)otherDate;
-(int) hour12;
-(int) minute;
-(NSString*)mm;
-(NSString*) am_pm;

@end
