//
//  ReportItem.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 6/16/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "ReportItem.h"

@implementation ReportItem
@synthesize ingoing,inrange,outgoing;
@synthesize schedule;
@synthesize reportingType;
@synthesize reportingCategory;
@synthesize reportingLabel;
@synthesize weekDay;
@synthesize ingoingConverted,inrangeConverted,outgoingConverted;
@synthesize period;

-(void) dealloc{
    [schedule release];
    [reportingCategory release];
    [reportingLabel release];
    [weekDay release];
    [ingoingConverted release];
    [inrangeConverted release];
    [outgoingConverted release];

    [super dealloc];
}
@end
