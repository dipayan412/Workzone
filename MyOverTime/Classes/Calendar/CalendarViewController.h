//
//  CalendarViewController.h
//  A*_Student
//
//  Created by Nazmul on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"
#import "CalendarSelectionDelegate.h"

@interface CalendarViewController : UIViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource>
{
    TKCalendarMonthView *calendar;
    id<CalendarSelectionDelegate>calendarDelegate;
    
    NSDate *selectedDate;
    
    NSDate *setDate;
    
    BOOL isBarvisible;
}

@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (nonatomic, retain) NSDate *setDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, assign)  id<CalendarSelectionDelegate>calendarDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTabBar:(BOOL)_barVisible;

@end
