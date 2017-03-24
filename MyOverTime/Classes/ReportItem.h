//
//  ReportItem.h
//  MyOvertime
//
//  Created by Prashant Choudhary on 6/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"

typedef enum kReportingType
{
    kWeekly = 0,
    kMonthly,kYearly
} ReportingType;


@interface ReportItem : NSObject
@property (nonatomic, retain) Schedule * schedule;
@property (nonatomic) CGFloat ingoing,inrange,outgoing;
@property (nonatomic) NSInteger period;

@property (nonatomic,retain) NSString * ingoingConverted,*inrangeConverted,*outgoingConverted;

@property (nonatomic) ReportingType reportingType;
@property (nonatomic,retain) NSString *reportingCategory;
@property (nonatomic,retain) NSString *reportingLabel,*weekDay;


@end
