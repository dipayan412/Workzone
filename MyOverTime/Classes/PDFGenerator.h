//
//  PDFGenerator.h
//  MyOvertime
//
//  Created by Kostia on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFGenerator : NSObject

+ ( NSData * ) activityBalanceDataFromString: ( NSString * ) string;
+ ( NSData * ) activityReportDataFromString: ( NSString * ) string;
+ ( NSData * ) balanceReportDataFromString: ( NSString * ) string;

@end
