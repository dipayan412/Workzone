//
//  CalendarViewController.m
//  A*_Student
//
//  Created by Nazmul on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CalendarViewController()

@end

@implementation CalendarViewController

@synthesize calendar;
@synthesize calendarDelegate;
@synthesize setDate;
@synthesize selectedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTabBar:(BOOL)_barVisible
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        calendar = 	[[TKCalendarMonthView alloc] init];
		calendar.delegate = self;
		calendar.dataSource = self;
        
        selectedDate = nil;
        setDate = nil;
        
        isBarvisible = _barVisible;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
	[super loadView];
    
    // Costruct the view because we aren't using a 
	CGRect applicationFrame = (CGRect)[[UIScreen mainScreen] applicationFrame];
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height)] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor grayColor];
	
	// Add button to toggle calendar
	
	// Add Calendar to just off the top of the screen so it can later slide down
	calendar.frame = CGRectMake(0, 0, calendar.frame.size.width, calendar.frame.size.height);
	// Ensure this is the last "addSubview" because the calendar must be the top most view layer	
	[self.view addSubview:calendar];
	[calendar reload];
    
    UIToolbar *toolbar;
    
    if(isBarvisible)
    {
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 49 - 44, 320, 44)];
    }
    else
    {
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 44, 320, 44)];
    }
    
    toolbar.tintColor = [UIColor blackColor];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"   OK   " style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:Nil];
    UIBarButtonItem *flexibleSpaceRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:Nil];
    
    toolbar.items = [NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, flexibleSpaceRight, nil];
    
    [self.view addSubview:toolbar];
}

-(void)doneButtonPressed:(id)sender
{
    if(calendarDelegate)
    {
        if(self.selectedDate)
        {
            [calendarDelegate delegateDidSelectDate:self.selectedDate fromController:self];
        }
        else if(self.setDate)
        {
            NSLog(@"setDate %@",self.setDate);
            [calendarDelegate delegateDidSelectDate:self.setDate fromController:self];
        }
        else
        {
            NSLog(@"toDate %@",[NSDate date]);
            [calendarDelegate delegateDidSelectDate:[NSDate date] fromController:self];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [calendar reload];
    
    [calendar selectDate:self.setDate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d 
{
    self.selectedDate = d;
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d 
{
//    self.selectedDate = d;
    //    [calendar reload];
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
	return nil;
}

@end
