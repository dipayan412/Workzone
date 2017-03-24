//
//  NSDate+Midnight.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 8/20/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Midnight)
- (NSDate *)midnightUTC ;
+(NSDate *) firstOfMonth :(NSDate *)today;
+(NSDate *) lastOfMonth  :(NSDate *)today;
@end
