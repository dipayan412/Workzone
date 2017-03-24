//
//  ResetViewController.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 7/15/12.
//  Copyright (c) 2012 pcasso. All rights reserved.
//

#import "ResetViewController.h"
#define DATE_FROM_1     @"DateMyOvertimeFrom"
#define DATE_FROM_2     @"DateActivityReportFrom"
#import <CoreData/CoreData.h>
#import "Schedule.h"
#import "NSDate+Midnight.h"
#import "ResetConstants.h"

#import "MyOvertimeAppDelegate.h"

@interface ResetViewController ()

@end

@implementation ResetViewController
@synthesize datePicker;
@synthesize datePickerView;
@synthesize tableView;
@synthesize resetCell;
@synthesize dateFrom,dateTo;
//@synthesize fromDate,toDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) startUpTasks{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	[self.view insertSubview:myImageView atIndex:0];
	[myImageView release];
    self.tableView.backgroundColor=[UIColor clearColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"RESET_HEADER", nil);
    
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:17];
    CGRect frameTo=dateToButton.frame;
    frameTo.origin.x=150+15;
    dateToButton.frame=frameTo;
    self.dateFrom=[[UILabel alloc]initWithFrame:dateFromButton.frame];
    dateFrom.backgroundColor=[UIColor clearColor];
    dateFrom.font=font;
    dateFrom.textAlignment=UITextAlignmentCenter;
    [self.view insertSubview:dateFrom aboveSubview:dateFromButton];
    
    self.dateTo=[[UILabel alloc]initWithFrame:dateToButton.frame];
    dateTo.backgroundColor=[UIColor clearColor];
    dateTo.textAlignment=UITextAlignmentCenter;
    dateTo.font=font;
    [self.view insertSubview:dateTo aboveSubview:dateToButton];
    
    CGRect frame=dateFrom.frame;
    frame.origin.y+=7;
    frame.origin.x+=10;
    dateFrom.frame=frame;
    frame=dateTo.frame;
    frame.origin.y+=7;
    frame.origin.x+=10;
    dateTo.frame=frame;
    
    
    [self startUpTasks];
    self.tableView.backgroundView=nil;
    [goButton setTitle:NSLocalizedString(@"RESET_GO_BUTTON", @"") forState:UIControlStateNormal];
    labelTitle.text= NSLocalizedString(@"RESET_HEADER", @"");
    textView.text= NSLocalizedString(@"RESET_SUBHEADER", @"");
    //labelFrom.text= NSLocalizedString(@"RESET_FROM", @"");
    //labelTo.text= NSLocalizedString(@"RESET_TO", @"");
    labelSuccess.text= NSLocalizedString(@"RESET_SUCCESS", @"");

    labelSuccess.hidden=YES;
    datePicker.hidden=YES;
    toolBar.hidden=YES;
    [self performFromDateOperation:nil];
    [self performToDateOperation:nil];
   
    fromDate=[[NSDate date] copy];
    toDate=[[NSDate date] copy];;
    //[dateToButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[dateFromButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateFromButton.titleLabel.textAlignment=UITextAlignmentCenter;
    dateToButton.titleLabel.textAlignment=UITextAlignmentCenter;
    dateFromButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    dateToButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    dateFromButton.titleLabel.font=font;
    dateToButton.titleLabel.font=font;

    // Do any additional setup after loading the view from its nib.
}

-(void) performFromDateOperation:(NSDate *) date
{
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//   
//    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//
//    if ([string isEqualToString:@"en_GB"]) {
//        [dateFormatter setDateFormat:@"dd/MM/YY"];
//    }
//    else if ([string isEqualToString:@"en_US"]) {
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//    }
//    else if ([string isEqualToString:@"sv_SE"]) {
//        [dateFormatter setDateFormat:@"YY-MM-dd"];
//    }
//    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
//        [dateFormatter setDateFormat:@"dd.MM.YY"];
//    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate * dateFrom1 = [ [ NSUserDefaults standardUserDefaults ] objectForKey: DATE_FROM_1 ];
    if (date) {
        dateFrom1=date;
    }
    else {
        dateFrom1=[NSDate date];
    }
    
    if ([[dateFormatter stringFromDate:dateFrom1] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
    NSString *dateFromstring=  dateFrom1 ? [dateFormatter stringFromDate: dateFrom1 ] : [dateFormatter stringFromDate:[NSDate date]];
    
    //[dateFromButton setTitle:dateFromstring forState:UIControlStateNormal];
    dateFrom.text=dateFromstring;
    CGRect frameTo=labelTo.frame;
   // CGSize maximumLabelSize = CGSizeMake(120,9999);
    //CGSize expectedLabelSize = [dateFrom sizeWithFont:[UIFont boldSystemFontOfSize:15]   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap];
    frameTo.origin.x=150-5;
    labelTo.frame=frameTo;
    labelTo.text=@"-";
    labelTo.textAlignment=UITextAlignmentLeft;
   
}
-(void) performToDateOperation:(NSDate *) date
{
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    
//    
//    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//    if ([string isEqualToString:@"en_GB"]) {
//        [dateFormatter setDateFormat:@"dd/MM/YY"];
//    }
//    else if ([string isEqualToString:@"en_US"]) {
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//    }
//    else if ([string isEqualToString:@"sv_SE"]) {
//        [dateFormatter setDateFormat:@"YY-MM-dd"];
//    }
//    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
//        [dateFormatter setDateFormat:@"dd.MM.YY"];
//    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSDate * dateFrom2 = [ [ NSUserDefaults standardUserDefaults ] objectForKey: DATE_FROM_2 ];
    if (date) {
        dateFrom2=date;
    }
    else {
        dateFrom2=[NSDate date];
    }
    
    if ([[dateFormatter stringFromDate:dateFrom2] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }

    NSString *dateToString=  dateFrom2 ? [dateFormatter stringFromDate: dateFrom2 ] : [dateFormatter stringFromDate:[NSDate date]];

    //[dateToButton setTitle:dateToString forState:UIControlStateNormal];
    dateTo.text=dateToString;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		//DO nothing
	}
	else {
        
        [self deleteTimeSheets];

	}
	
	
	
}



-(IBAction) resetDate:(id)sender{
    labelSuccess.hidden=YES;
   // NSLog(@"from %@ todate %@",fromDate,toDate);
    if (fromDate==nil||toDate==nil) {
        return;
    }
    if ([fromDate compare:toDate]==NSOrderedDescending) {
        //Do nothing
    }
    else  {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"DELETE", @"")
                              message: NSLocalizedString(@"DELETE_MESSAGE", @"")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"CANCEL", @"")
                              otherButtonTitles:NSLocalizedString(@"OK", @""),nil];
        [alert show];
        [alert release];
    }

    

}
-(void) deleteTimeSheets{
   // int n=1;//Go back 10 days 
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];

    //NSDate * cDate = [ [NSDate new] dateByAddingTimeInterval: -86400 * ( n + 1 ) ];	
    NSFetchRequest * request = [ [ NSFetchRequest alloc ] init ];
    NSEntityDescription * entity = [ NSEntityDescription entityForName: @"Schedule"
                                                inManagedObjectContext: app.managedObjectContext
                                    ];
    [ request setEntity: entity ];
    
    NSDate * fromDateModified = [ fromDate midnightUTC];//dateByAddingTimeInterval: -86400 * ( n + 1 ) ];
    NSDate * toDateModified = [[ toDate midnightUTC] dateByAddingTimeInterval:86400];//dateByAddingTimeInterval: -86400 * ( n + 1 ) ];

    NSPredicate * predicate = [ NSPredicate predicateWithFormat: @"scheduleDate >= %@ && scheduleDate <= %@", fromDateModified,toDateModified ];
    [ request setPredicate: predicate ];
    // Execute the fetch -- create a mutable copy of the result.
    NSError * error = nil;
    NSMutableArray * mutableFetchResults = [ [ app.managedObjectContext executeFetchRequest: request
                                                                                  error: &error ] mutableCopy ];
    if( mutableFetchResults == nil ) 
    {
        // Handle the error. 
    }            
   // NSLog(@"mm %d  %@---%@",[mutableFetchResults count],fromDate,toDate);


    if( [ mutableFetchResults count ] > 0 ) {
        for (int i=0;i<[mutableFetchResults count];i++)
        {
            Schedule * schedule = [ mutableFetchResults objectAtIndex: i ];
            
            if(schedule.settingsDayTemplate || schedule.myTemplate)
            {
                
            }
            else
            {
                for ( id timeSheet in schedule.timeSheets)
                {
                    [app.managedObjectContext deleteObject:timeSheet];
                }
                
                [app.managedObjectContext deleteObject:schedule];
            }

            NSError * error = nil;
            [app.managedObjectContext save:&error];
        }
    }
    labelSuccess.hidden=NO;
}

-(IBAction) selectedDate:(id)sender
{
    datePicker.hidden=YES;
    toolBar.hidden=YES;
    if (fromTo==0)
    {
        fromDate=[datePicker.date copy];
        [self performFromDateOperation:datePicker.date];
    }
    else if (fromTo==1)
    {
        toDate=[datePicker.date copy];
        [self performToDateOperation:datePicker.date];
    }

}
-(IBAction) requestDateSelection:(id)sender
{
    UIButton *button=(id) sender;
    fromTo=button.tag;
    // NSLog(@"from to %d",fromTo);
//    datePicker.hidden=NO;
//    toolBar.hidden=NO;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    
    NSString *dateString;
    
    if (fromTo==0)
    {
        dateString = dateFrom.text ;
    }
    else if (fromTo==1)
    {
        dateString = dateTo.text ;
    }
    
    CalendarViewController *calVC = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil withTabBar:NO];
    calVC.calendarDelegate = self;
    
    calVC.setDate = [dateFormatter dateFromString:dateString];
//    calVC.setDate = [dateFormatter dateFromString:@"13-02-19"];
    
    [self addChildViewController:calVC];                 // 1
    CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
    initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	calVC.view.frame = initialRect;
    
    [self.view addSubview:calVC.view];
    [calVC didMoveToParentViewController:self];          // 3
    
    [UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
                         calVC.view.frame = CGRectMake([[UIScreen mainScreen] applicationFrame].origin.x, [[UIScreen mainScreen] applicationFrame].origin.y - 20, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
					 }
					 completion:^(BOOL finished) {
					 }];
}

-(void)delegateDidSelectDate:(NSDate *)_d fromController:(UIViewController *)controller
{
    CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 controller.view.frame = initialRect;
					 }
					 completion:^(BOOL finished)
     {
         [controller willMoveToParentViewController:nil];
         [controller.view removeFromSuperview];
         [controller removeFromParentViewController];
     }];
    
    if (fromTo==0)
    {
        fromDate = _d;
        [self performFromDateOperation:_d];
    }
    else if (fromTo==1)
    {
        toDate = _d;
        [self performToDateOperation:_d];
    }
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
       
    CGRect frame=textView.frame;
    CGSize maximumLabelSize = CGSizeMake(frame.size.width,9999);
    CGSize expectedLabelSize = [textView.text sizeWithFont:textView.font   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height=expectedLabelSize.height+50;
    textView.frame=frame;

    
    return 70+frame.size.height+RESET_ADJUST_HEIGHT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        
        
	}
    
    
    
    if (indexPath.row == 0){
        resetCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return resetCell;
	}
   
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	//[self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
   	
    
	
}


-(void) dealloc{
    [resetCell release];
    [tableView release];
    [super dealloc];
}
@end
