 //
//  RootViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "RootViewController.h"
#import "TimeSheetView.h"
#import "Schedule.h"
#import "Activity.h"
#import "TimeSheet.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "Appirater.h"
#import "Localizator.h"
#import "MyOvertimeAppDelegate.h"
#import "StaticConstants.h"
#import "NSDate+Midnight.h"
#import "BackUpViewController.h"
#import "CalendarViewController.h"
#import "Settings.h"
#import "SettingsDayTemplate.h"
#import "MyTemplate.h"
#import "DropboxViewController.h"

@interface RootViewController()

@property (nonatomic, retain) Settings *settings;

@end

@interface RootViewController(PrivateMethods)

- (void) changeDate:(NSDate*)date;
- (NSString*) convertTimeToString:(NSNumber*)time;
- (NSNumber*) convertPickerDataToTimeFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromTime:(NSNumber*)time;

- (NSString*) convertPeriodToString:(NSNumber*)period;
- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period;

- (void) initializeCurrentSchedule:(NSDate*)cDate;
- (void) bindEntityToView;
- ( void ) checkOffsetValue;

- (void) estimateIndicators;
- (void) saveToManagedObjectContext;	//	$TINGTONG CODE

-(void)fetchMyTemplates;
-(void)addTemplateSchedule:(Schedule*)_schedule;

-(BOOL)isScheduleHasTimeSheets:(NSDate*)cDate;

@end

@implementation RootViewController

@synthesize settings;

@synthesize dateIdentificationCell, dateDetailsCell, totalResultsSection, headerView, userIdentificationLabel;
@synthesize currentOffsetLabel;
@synthesize currentDateLabel, currentDateStringLabel;  

@synthesize dateSelectView, dateSelectPicker;
@synthesize offsetSelectView, offsetSelectPicker;
@synthesize activitySelectView, activitySelectPicker, activitiesPickerData; 
@synthesize startTimeSelectView, startTimeSelectPicker;
@synthesize endTimeSelectView, endTimeSelectPicker;
@synthesize breakTimeSelectView, breakTimeSelectPicker;
@synthesize flatTimeSelectView, flatTimeSelectPicker;	

@synthesize scrollDateDetails, pagingText;

@synthesize timeSheetsArray;
@synthesize settingsDictionary;
@synthesize workingDays;

@synthesize myTemplates;

@synthesize managedObjectContext;

@synthesize currentSchedule;
@synthesize currentDate;
@synthesize timeSheetModels;

@synthesize totalIndicatorLabel, balanceIndicatorLabel;

@synthesize removeButton;

@synthesize inAppPurchaseView, waitingView, innerWaitingView;

@synthesize commentsView, commentsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle
- (NSInteger )getDayOWeek
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    cal.firstWeekday = 2;
    NSDate *now = [NSDate date];
    
    // required components for today
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit ) fromDate:now];
    [cal release];
    
    return components.weekday;
}

- (void)reloadFetchedResults:(NSNotification*)note
{
    NSLog(@"Underlying data changed ... refreshing!");
    
    [self initializeCurrentSchedule:self.currentDate];
    
    [self fetchMyTemplates];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousDate:)];
    UISwipeGestureRecognizer *swipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextDate:)];
    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionLeft;
    [dateIdentificationCell addGestureRecognizer:swipeRecognizer1];
    [dateIdentificationCell addGestureRecognizer:swipeRecognizer2];
    
    UISwipeGestureRecognizer *swipeRecognizer3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTimesheet:)];
    UISwipeGestureRecognizer *swipeRecognizer4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTimesheet:)];
    swipeRecognizer4.direction = UISwipeGestureRecognizerDirectionLeft;
    [dateDetailsCell addGestureRecognizer:swipeRecognizer3];
    [dateDetailsCell addGestureRecognizer:swipeRecognizer4];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFetchedResults:)
                                                 name:@"iCloudDataChanged"
                                               object:[[UIApplication sharedApplication] delegate]];

    setTimeForFlatHours = NO;
    
    UIButton *buttonAdd=(UIButton*)[dateDetailsCell.contentView viewWithTag:100];
    
    UIButton *buttonDelete=(UIButton*)[dateDetailsCell.contentView viewWithTag:101];
    CGRect framebutton= buttonAdd.frame;
    framebutton.size.width=30;
    framebutton.size.height=30;
    framebutton.origin.x-=10;
    framebutton.origin.y-=0;

    buttonAdd.frame=framebutton;
    
    framebutton=buttonDelete.frame;
    framebutton.size.width=28;
    framebutton.size.height=28;
    framebutton.origin.y-=0;
    buttonDelete.frame=framebutton;
    [buttonDelete setImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
    [buttonDelete setBackgroundImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
    
    [dayTemplateButton setHidden: YES];
    [myTemplareButton setHidden: YES];
    [copyLastSheet setHidden: YES ];
    [firstCheckin setHidden:YES ];
	
	activitySelectPicker.delegate = self;
	activitySelectPicker.dataSource = self;
    	
	scrollDateDetails.backgroundColor = [UIColor clearColor];
	scrollDateDetails.scrollEnabled = NO;
	scrollDateDetails.showsHorizontalScrollIndicator = NO;
	scrollDateDetails.contentSize = CGSizeMake(283, 137);
	scrollDateDetails.pagingEnabled = YES;

		
	// reminder mechanism
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *cDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter dateFromString:cDate]];
	[comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
    self.currentDate = [[NSCalendar currentCalendar] dateFromComponents:comps];


	if ([[self.settingsDictionary objectForKey:@"reminderMode"] boolValue])
    {
		self.workingDays = [self.settingsDictionary objectForKey:@"workingDays"];
		
		NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
        
        //NSLog(@"Timezone : %@",[NSDate date]);
		[comps setTimeZone:[NSTimeZone  timeZoneWithName:@"GMT-1000"]];
        NSDate *reminderDate = [[NSCalendar currentCalendar] dateFromComponents:comps];	
		
		comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:reminderDate];
//		NSInteger todayDay = [comps weekday];
        
		reminderDate = [reminderDate dateByAddingTimeInterval:-86400] ;
        
		comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:reminderDate];
        //NSLog(@"ReminderDate : %@, weekday %d",reminderDate, [comps weekday] );
		
		NSMutableArray *checkedDatesArray = [[NSMutableArray alloc] init];
        
		NSDate *toDate = [reminderDate dateByAddingTimeInterval:0];
		NSDate *fromDate = [reminderDate dateByAddingTimeInterval:0];

        int n = 7;
        
        while (YES) 
        {
			if ([workingDays containsObject:[NSNumber numberWithInteger:[comps weekday]]]) 
            {
				[checkedDatesArray addObject:reminderDate];
				fromDate = [reminderDate dateByAddingTimeInterval:0];

                n--;
			}	
			
			reminderDate = [reminderDate dateByAddingTimeInterval:-86400];
			comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:reminderDate];
            
            if( n == 0 )
                break;
		}	
		
		if ([checkedDatesArray count]>0)
        {
			NSFetchRequest *request = [[NSFetchRequest alloc] init];
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
			[request setEntity:entity];
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(scheduleDate >= %@) AND (scheduleDate <= %@)", fromDate, toDate];
			[request setPredicate:predicate];

			// Execute the fetch -- create a mutable copy of the result.
			
			NSError *error = nil;
			NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
			
			NSMutableArray *reminderArray = [[NSMutableArray alloc] init];
			
			if ([fetchResults count]>0)
            {
				for (NSDate *curDate in checkedDatesArray)
                {
					BOOL scheduleFilled = NO;
					for (Schedule *curSchedule in fetchResults)
                    {
						if ([curSchedule.scheduleDate isEqualToDate:curDate])
                        {
							NSArray *timeSheets = [curSchedule.timeSheets allObjects];
							for (TimeSheet *curTimeSheet in timeSheets)
                            {
								if (([curTimeSheet.activity.flatMode boolValue])&&([curTimeSheet.flatTime intValue]>=0))
                                {
									scheduleFilled = YES;
									break;
								}
                                else
                                {
									if (([curTimeSheet.startTime intValue]>=0)&&([curTimeSheet.endTime intValue]>=0))
                                    {
										scheduleFilled = YES;
										break;
									}	
								}
								
							}
						}	
					}
					if (!scheduleFilled)
                    {
						[reminderArray addObject:curDate];
					}
				}
			}
            else
            {
				[reminderArray addObjectsFromArray:checkedDatesArray];
			}
			
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			//[dateFormatter setLocale:[NSLocale currentLocale]];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
			
			NSString *reminderMessage = NSLocalizedString(@"REMINDER_MESSAGE_CONTENT", @"");
			reminderMessage = [reminderMessage stringByAppendingString:@"\n"];
			for (NSDate *curDate in reminderArray)
            {
				reminderMessage = [reminderMessage stringByAppendingString:[dateFormatter stringFromDate:curDate]];
				reminderMessage = [reminderMessage stringByAppendingString:@"\n"];
			}
			
            // rykosoft: March fix, bug 1 - message shouldn't appear if reminderArray is empty
            if( [ reminderArray count ] > 0 )
            {
                MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                NSMutableString *systemMessage;
                BOOL inapp=NO;

#ifdef INAPP_VERSION	
                inapp=NO;
#endif	
                if (!app.isProduct1Purchased && inapp)
                {
                    systemMessage=[NSString stringWithFormat:@"%@\n\n%@",kAlertMessageProduct2,reminderMessage];

                }
                else if (!app.isProduct1Purchased && !inapp)
                {
                    
                    systemMessage=[NSString stringWithFormat:@"%@",reminderMessage];
                    
                }
                else
                    systemMessage=[NSString stringWithFormat:@"%@",reminderMessage];


                UIAlertView *reminderAlertView = [[UIAlertView alloc] initWithTitle:@"" message:systemMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [reminderAlertView show];
                [reminderAlertView release];                
            }
//            else
//                //NSLog( @"reminder array empty" );
                        
			[request release];
			[reminderArray release];
		}
	}
    
    
#ifdef INAPP_VERSION
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isProduct1Purchased)
    {
        //If purchased then return, no action   
    }
    else
    {
        if([self checkIf12DaysLimit])
        {
            inAppLimitationAlertShown = YES;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
        }
        else
        {
            
        }
    }
    
#endif
}

-(void)previousDate:(UIGestureRecognizer*)recognizer
{
    [self moveToPreviousDay];
}

-(void)nextDate:(UIGestureRecognizer*)recognizer
{
    [self moveToNextDay];
}

-(void)previousTimesheet:(UIGestureRecognizer*)recognizer
{
    if (currentPage > 0)
    {
        [self moveToPreviousTimesheet];
    }
    else
    {
        [self moveToPreviousDay];
    }
}

-(void)nextTimesheet:(UIGestureRecognizer*)recognizer
{
    if ((currentPage + 1) < amountPage)
    {
        [self moveToNextTimesheet];
    }
    else
    {
        [self moveToNextDay];
    }
}

-(void)showAlert
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showDaysLimitAlert];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchSettings];
    
    dayTemplateButton.hidden = ![GlobalFunctions getShowButtonsOptions1];
    myTemplareButton.hidden = ![GlobalFunctions getShowButtonsOptions2];
    copyLastSheet.hidden = ![GlobalFunctions getShowButtonsOptions3];
    firstCheckin.hidden = ![GlobalFunctions getShowButtonsOptions4];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
		
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];

	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
		
	self.workingDays = [self.settingsDictionary objectForKey:@"workingDays"];
	is24hoursMode = [[self.settingsDictionary objectForKey:@"is24hoursMode"] boolValue];
    timeStyle = [GlobalFunctions getTimeStyle];
	
	NSString *userName = [self.settingsDictionary objectForKey:@"userName"];
	NSString *companyName = [self.settingsDictionary objectForKey:@"companyName"];
	
	NSString *userIdentification = [NSString stringWithFormat:@"%@ %@", userName, companyName];
	
	if (([[userIdentification stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0))
    {
        UILabel *defaultTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
		defaultTitle.backgroundColor = [UIColor clearColor];
		defaultTitle.textAlignment = UITextAlignmentCenter;
		defaultTitle.textColor = [UIColor whiteColor];
		defaultTitle.font = [UIFont boldSystemFontOfSize:20];
		defaultTitle.text =userIdentification;
		self.navigationItem.titleView = defaultTitle;
		[defaultTitle release];
	}
    else
    {
		UILabel *defaultTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
		defaultTitle.backgroundColor = [UIColor clearColor];
		defaultTitle.textAlignment = UITextAlignmentCenter;
		defaultTitle.textColor = [UIColor whiteColor];
		defaultTitle.font = [UIFont boldSystemFontOfSize:20];
		defaultTitle.text = NSLocalizedString(@"TIME_SHEET_PAGE_TITLE", @"");
		self.navigationItem.titleView = defaultTitle;
		[defaultTitle release];
	}
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkIfDataExist];
	
	[self initializeCurrentSchedule:self.currentDate];
    
    NSLog(@"currentday %@", self.currentDate);
    
    [self fetchMyTemplates];
    
#ifdef INAPP_VERSION	
    [self inAppLimitationCheck];
#endif	
}

-(void)viewDidAppear:(BOOL)animated
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (checkBackup==NO && app.firstLoad==NO )
    {
        checkBackup=YES;
        BOOL notBackedUp = [GlobalFunctions checkLastDate:[NSDate date]];
        if (!notBackedUp)
        {
            NSInteger valueDay = [self getValueForDay:[self getDayOWeek]];
            if (valueDay==1)
            {
                if([GlobalFunctions isDropboxEnabled])
                {
                    [GlobalFunctions saveLastCheckUpDate];
                    [self openBackUp];
                }
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	for (int i=0; i<[timeSheetModels count]; i++)
    {
		TimeSheet *curTimeSheet = [timeSheetModels objectAtIndex:i];
		if ([curTimeSheet.activity.flatMode boolValue])
        {
			curTimeSheet.startTime = [NSNumber numberWithInt:-1];
			curTimeSheet.endTime = [NSNumber numberWithInt:-1];
			curTimeSheet.breakTime = [NSNumber numberWithInt:-1];
		}
        else
        {
			curTimeSheet.flatTime = [NSNumber numberWithInt:-1];
		}		
		curTimeSheet.subSequence = [NSNumber numberWithInt:i];
	}
	
	self.currentSchedule.timeSheets = [NSSet setWithArray:timeSheetModels];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	self.currentDate = currentSchedule.scheduleDate;
	self.currentSchedule = nil;
    //[self saveAllSettings];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
    {
		return dateIdentificationCell;
	} 	
    
    return dateDetailsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
    {
		return 120;
	}
	return 180;
}	

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 0)
    {
		return totalResultsSection;
	}
	return nil;
}	

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 21;
}	

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark -
#pragma mark Interaction with Modal Views for various time, date selecting

- (IBAction) showSelectDateView:(id)sender
{
	dateSelectPicker.date = currentSchedule.scheduleDate;
	
    CalendarViewController *calVC = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil withTabBar:YES];
    calVC.calendarDelegate = self;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [dateFormatter dateFromString:currentDateLabel.text];
    calVC.setDate = date;
    
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
                         self.navigationController.tabBarController.tabBar.hidden = YES;
					 }
					 completion:^(BOOL finished)
                     {
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
                         self.navigationController.tabBarController.tabBar.hidden = NO;
						 [controller willMoveToParentViewController:nil];
                         [controller.view removeFromSuperview];
                         [controller removeFromParentViewController];
					 }];
    
	[self initializeCurrentSchedule:_d];
}

- (IBAction) completeSelectDate:(id)sender {

	NSDate *choosenDate = [self.dateSelectPicker.date dateByAddingTimeInterval:0];

	
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:choosenDate];
    //[dateComponents setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
	if ([workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]]) {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setLocale:[NSLocale currentLocale]];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		self.currentDateLabel.text = [dateFormatter stringFromDate:choosenDate];	
		
		[dateFormatter setDateFormat:@"EEEE"];
        [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
		self.currentDateStringLabel.text = [[dateFormatter stringFromDate:choosenDate] capitalizedString];
		
	} else {
		[self.dateSelectPicker setDate:[choosenDate dateByAddingTimeInterval:86400] animated:YES];
		[self completeSelectDate:sender];
	}	
}	

- (IBAction) showSelectOffsetView:(id)sender {

    [ offsetSelectPicker reloadAllComponents ];

    NSArray *pickerSettings = [self getInitialPickerValuesFromPeriod:currentSchedule.offset];
	for (NSInteger i = 0; i<[pickerSettings count]; i++)
    {
		[offsetSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
	}

	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	offsetSelectView.frame = initialRect;
	[self.view.window addSubview:offsetSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 offsetSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];
	
}

- (IBAction) hideSelectOffsetView:(id)sender
{
	self.currentSchedule.offset = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
	currentOffsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
	
    //NSLog(@"hhhhh %d",[self.currentSchedule.offset intValue]);
    if ([self.currentSchedule.offset intValue]==0)
    {
        isZeroAdjustment=YES;
    }
    else
    {
        isZeroAdjustment=NO;
    }
	[self estimateIndicators];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 offsetSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [offsetSelectView removeFromSuperview];
					 }];		
}	

- (IBAction) showSelectActivityView:(id)sender
{
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
    
    int count=[activitiesPickerData indexOfObject:timeSheet.activity];
    
    if (timeSheet==nil||timeSheet.activity==nil||count>[activitiesPickerData count])
    {
        [activitySelectPicker selectRow:0 inComponent:0 animated:NO];
        //return;
    }
    else
	[activitySelectPicker selectRow:[activitiesPickerData indexOfObject:timeSheet.activity] inComponent:0 animated:NO];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	activitySelectView.frame = initialRect;
	[self.view.window addSubview:activitySelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 activitySelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];
}

- (IBAction) hideSelectActivityView:(id)sender
{
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
    
    Activity *oldAct = timeSheet.activity;
    Activity *newAct = [activitiesPickerData objectAtIndex:[activitySelectPicker selectedRowInComponent:0]];
    
	if (![oldAct isEqual:newAct])
    {
        if(newAct.flatMode.boolValue)
        {
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            
            if(newAct.useDefault.boolValue)
            {
                timeSheet.flatTime = newAct.offsetValue;
            }
            else
            {
                timeSheet.flatTime = self.currentSchedule.offset;
            }
            
            if(newAct.showAmount.boolValue)
            {
                timeSheet.amount = [NSNumber numberWithFloat:newAct.amount.floatValue];
            }
            else
            {
                timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            }
            
            setTimeForFlatHours = YES;
        }
        else
        {
            if (oldAct.flatMode.boolValue)
            {
                timeSheet.startTime = [NSNumber numberWithInt:-1];
                timeSheet.endTime = [NSNumber numberWithInt:-1];
                timeSheet.breakTime = [NSNumber numberWithInt:-1];
            }

            setTimeForFlatHours = NO;
        }
        
        timeSheet.activity = newAct;
		
		TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
		[timeSheetView changeActivity:[activitiesPickerData objectAtIndex:[activitySelectPicker selectedRowInComponent:0]]];
		timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];
		timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];
		timeSheetView.breakTimeLabel.text = [self convertTimeToString:timeSheet.breakTime];
		timeSheetView.flatTimeLabel.text = [self convertTimeToString:timeSheet.flatTime];
        timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
        if(timeSheet.activity.showAmount.boolValue)
        {
            timeSheetView.amountField.hidden =
            timeSheetView.amountLabel.hidden = NO;
        }
        else
        {
            timeSheetView.amountField.hidden =
            timeSheetView.amountLabel.hidden = YES;
        }
        
		[self estimateIndicators];

		//	$TINGTONG CODE
		[self saveToManagedObjectContext];
	}
    
    if(timeSheet.activity.overtimeReduce.boolValue)
    {
        if(currentPage == 0)
        {
            self.currentSchedule.offset = [NSNumber numberWithInt:0];
            currentOffsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
            
            [self estimateIndicators];
            
            [self saveToManagedObjectContext];
        }
    }
		
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 activitySelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [activitySelectView removeFromSuperview];
					 }];		
	
}

-(void)timeSheetAmountFieldDidBeginEditing
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard
{
    TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
    [timeSheetView.amountField resignFirstResponder];
}

-(void)timeSheetAmountDidEndEditing:(NSString *)_amount
{
    TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
    
    NSString *value = [_amount stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    timeSheet.amount = [NSNumber numberWithFloat:value.floatValue];
    
    [self saveToManagedObjectContext];
}

- (IBAction) showSelectStartTimeView:(id)sender
{
	[startTimeSelectPicker reloadAllComponents];
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	NSArray *pickerSettings = [self getInitialPickerValuesFromTime:timeSheet.startTime];
	
	for (NSInteger i = 0; i<[pickerSettings count]; i++) {
		[startTimeSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
	}	
		
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	startTimeSelectView.frame = initialRect;
	[self.view.window addSubview:startTimeSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 startTimeSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];	
}

- (IBAction) hideSelectStartTimeView:(id)sender
{	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.startTime = [self convertPickerDataToTimeFromView:startTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];	
	
	[self estimateIndicators];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 startTimeSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [startTimeSelectView removeFromSuperview];
					 }];
	
}

- (IBAction) showSelectEndTimeView:(id)sender
{	
	[endTimeSelectPicker reloadAllComponents];
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	NSArray *pickerSettings = [self getInitialPickerValuesFromTime:timeSheet.endTime];

	for (NSInteger i = 0; i<[pickerSettings count]; i++)
    {
		[endTimeSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
	}	
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	endTimeSelectView.frame = initialRect;
	[self.view.window addSubview:endTimeSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 endTimeSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];	
	
}	

- (IBAction) hideSelectEndTimeView:(id)sender
{
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.endTime = [self convertPickerDataToTimeFromView:endTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];
	
	if ([timeSheet.breakTime intValue] == -1)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE"];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale: locale];
        NSString *dayName = [formatter stringFromDate:self.currentSchedule.scheduleDate];
        [formatter release];
        
        NSString *breakName = [NSString stringWithFormat:@"%@break", dayName];
        
        timeSheet.breakTime = [self.settingsDictionary objectForKey:breakName];
		timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
	}	
	
	[self estimateIndicators];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 endTimeSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [endTimeSelectView removeFromSuperview];
					 }];
	
}	

- (IBAction) showSelectBreakTimeView:(id)sender
{
	[ breakTimeSelectPicker reloadAllComponents ];
    
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	NSArray *pickerSettings = [self getInitialPickerValuesFromPeriod:timeSheet.breakTime];
	
	for (NSInteger i = 0; i<[pickerSettings count]; i++) {
		[breakTimeSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
	}		
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	breakTimeSelectView.frame = initialRect;
	[self.view.window addSubview:breakTimeSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 breakTimeSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];		
}	

- (IBAction) hideSelectBreakTimeView:(id)sender
{	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.breakTime = [self convertPickerDataToPeriodFromView:breakTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
	
	[self estimateIndicators];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 breakTimeSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [breakTimeSelectView removeFromSuperview];
					 }];				
	
}

- (IBAction) showSelectFlatTimeView:(id)sender
{
	isFlatTimePickerOn = YES;
    
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	NSArray *pickerSettings = [self getInitialPickerValuesFromPeriod:timeSheet.flatTime];
	
	for (NSInteger i = 0; i < [pickerSettings count]; i++)
    {
		[flatTimeSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] 
                            inComponent:i
                               animated:NO];
	}			
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	flatTimeSelectView.frame = initialRect;
	[self.view.window addSubview:flatTimeSelectView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 flatTimeSelectView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];		
	
}	

- (IBAction) hideSelectFlatTimeView:(id)sender
{
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.flatTime = [self convertPickerDataToPeriodFromView:flatTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.flatTimeLabel.text = [self convertPeriodToString:timeSheet.flatTime];
	
	[self estimateIndicators];
	
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 flatTimeSelectView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [flatTimeSelectView removeFromSuperview];
					 }];
    
    isFlatTimePickerOn = NO;
}	

- (IBAction) showCommentsWindow:(id)sender {
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	commentsTextView.text = timeSheet.comments;
	
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	commentsView.frame = initialRect;
	[self.view.window addSubview:commentsView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 commentsView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];			
}	

- (IBAction) hideCommentsWindow:(id)sender {
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.comments = commentsTextView.text;
				
	//	$TINGTONG CODE
	[self saveToManagedObjectContext];

	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 commentsView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [commentsView removeFromSuperview];
					 }];					
}	

#pragma mark -
#pragma mark TimeSheetViewDelegate

- (void) showSelectActivityDelegate:(id)sender {
	[self showSelectActivityView:sender];
}	

- (void) showSelectStartTimeDelegate:(id)sender
{
	[self showSelectStartTimeView:sender];
}

- (void) showSelectEndTimeDelegate:(id)sender
{
	[self showSelectEndTimeView:sender];
}	

- (void) showSelectBreakTimeDelegate:(id)sender
{
    [self showSelectBreakTimeView:sender];
}	

- (void) showSelectFlatTimeDelegate:(id)sender
{
	[self showSelectFlatTimeView:sender];
}	

- (void) setCheckInTimeDelegate:(id)sender
{
    TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
    TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
    
    if(!timeSheet.activity)
    {
        timeSheet.activity = settings.checkinActivity;
        [self saveToManagedObjectContext];
        [timeSheetView changeActivity:settings.checkinActivity];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *cDate = [dateFormatter stringFromDate:self.currentDate];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                              fromDate:[dateFormatter dateFromString:cDate]];
    
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    int interval = [self safeTimeInterval];
    CGFloat currentMinutes = -[beginningOfDay timeIntervalSinceNow] / 60.0f;
    int roundedMinutes = interval * (int)(currentMinutes / interval + 0.5f);
    
    timeSheet.startTime = [NSNumber numberWithDouble:roundedMinutes];
    
    timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];

	[self estimateIndicators];	
}	

- (void) setCheckOutTimeDelegate:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterLongStyle];    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *cDate = [dateFormatter stringFromDate:[[NSDate alloc] init]];
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter dateFromString:cDate]];
	//[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];	
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.endTime = [NSNumber numberWithDouble:((-1.0/60.0)*[beginningOfDay timeIntervalSinceNow])];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];	
	
	if ([timeSheet.breakTime intValue] == -1)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE"];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale: locale];
        NSString *dayName = [formatter stringFromDate:self.currentSchedule.scheduleDate];
        [formatter release];
        
        NSString *breakName = [NSString stringWithFormat:@"%@break", dayName];
        
//        timeSheet.breakTime = [self.settingsDictionary objectForKey:@"break"];
        timeSheet.breakTime = [self.settingsDictionary objectForKey:breakName];
		timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
	}		
	
	[self estimateIndicators];
}	

- (void) showCommentsWindowDelegate:(id)sender
{
	[self showCommentsWindow:sender];
}	

#pragma mark -
#pragma mark PickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == offsetSelectPicker)
    {
		self.currentSchedule.offset = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
		currentOffsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
        //Pcasso change
        //[settingsDictionary setObject:self.currentSchedule.offset forKey:@"offset"];

	}
    else if (pickerView == activitySelectPicker)
    {
		TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
		[timeSheetView changeActivity:[activitiesPickerData objectAtIndex:row]];
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (pickerView == offsetSelectPicker)
    {
		if (component == 0)
        {
			return [NSString stringWithFormat:@"%d", row];
		}
        else
        {
			return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
		}	
	}
    else if (pickerView == activitySelectPicker)
    {
		Activity *activity = [activitiesPickerData objectAtIndex:row];
		return activity.activityTitle;
	}
    else if (pickerView == startTimeSelectPicker)
    {
        if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
                int lastRow = [startTimeSelectPicker selectedRowInComponent:0];
                if (lastRow < 12 && row >= 14)
                {
                    [startTimeSelectPicker selectRow:1 inComponent:2 animated:YES];
                }
                else if (lastRow >= 12 && row < 10)
                {
                    [startTimeSelectPicker selectRow:0 inComponent:2 animated:YES];
                }
                
                if (row % 12 == 0)
                {
                    return @"12";
                }
				return [NSString stringWithFormat:@"%d", (row % 12)];
			}
            else if (component == 1)
            {
				return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
			}
            else
            {
                if (row == 0)
                {
                    return NSLocalizedString(@"LOCAL_AM", nil);
                }
                return NSLocalizedString(@"LOCAL_PM", nil);
			}
		}
        else
        {
            if (component == 0)
            {
				return [NSString stringWithFormat:@"%d", row];
			}
            else
            {
				return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
			}
		}
	}
    else if (pickerView == endTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
                int lastRow = [startTimeSelectPicker selectedRowInComponent:0];
                if (lastRow < 12 && row >= 14)
                {
                    [startTimeSelectPicker selectRow:1 inComponent:2 animated:YES];
                }
                else if (lastRow >= 12 && row < 10)
                {
                    [startTimeSelectPicker selectRow:0 inComponent:2 animated:YES];
                }
                
                if (row % 12 == 0)
                {
                    return @"12";
                }
				return [NSString stringWithFormat:@"%d", (row % 12)];
			}
            else if (component == 1)
            {
				return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
			}
            else
            {
				if (row == 0)
                {
                    return NSLocalizedString(@"LOCAL_AM", nil);
                }
                return NSLocalizedString(@"LOCAL_PM", nil);
			}
		}
        else
        {
			if (component == 0)
            {
				return [NSString stringWithFormat:@"%d", row];
			}
            else
            {
				return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
			}
		}
	}
    else if (pickerView == breakTimeSelectPicker)
    {
		if (component == 0)
        {
			return [NSString stringWithFormat:@"%d", row];
		}
        else
        {
			return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
		}							
	}
    else if (pickerView == flatTimeSelectPicker)
    {
		if (component == 0)
        {
			return [NSString stringWithFormat:@"%d", row];
		}
        else
        {
			return [NSString stringWithFormat:@"%02d", (row * [self safeTimeInterval])];
		}
	}	
	return nil;
}	

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (pickerView == offsetSelectPicker)
    {
		if (component == 0)
        {
			return 24;
		}
        else
        {
			return (60 / [self safeTimeInterval]);
		}	
	}
    else if (pickerView == activitySelectPicker)
    {
		return [activitiesPickerData count];
	}
    else if (pickerView == startTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
				return 24;
			}
            else if (component == 1)
            {
				return (60 / [self safeTimeInterval]);
			}
            else
            {
				return 2;
			}
		}
        else
        {
			if (component == 0)
            {
				return 24;
			}
            else
            {
				return (60 / [self safeTimeInterval]);
			}
		}
	}
    else if (pickerView == endTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
				return 24;
			}
            else if (component == 1)
            {
				return (60 / [self safeTimeInterval]);
			}
            else
            {
				return 2;
			}
		}
        else
        {
			if (component == 0)
            {
				return 24;
			}
            else
            {
				return (60 / [self safeTimeInterval]);
			}
		}
	}
    else if (pickerView == breakTimeSelectPicker)
    {
		if (component == 0)
        {
			return 24;
		}
        else
        {
			return (60 / [self safeTimeInterval]);
		}							
	}
    else if (pickerView == flatTimeSelectPicker)
    {
		if (component == 0)
        {
			return 1000;
		}
        else
        {
			return (60 / [self safeTimeInterval]);
		}
	}		
	return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if (pickerView == activitySelectPicker)
    {
		return 1;
	}
    else if (pickerView == startTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
			return 3;
		}
        else
        {
            return 2;
		}
	}
    else if (pickerView == endTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
			return 3;
		}
        else
        {
            return 2;
		}
	}		
	return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (pickerView == activitySelectPicker)
    {
		return 300;
	}
	return 50;
}	

#pragma mark -
#pragma mark Date Selection Functionality

- (IBAction) nextDay:(id)sender
{
    [self moveToNextDay];
}

- (IBAction) previousDay:(id)sender
{
    [self moveToPreviousDay];
}

-(void)moveToNextDay
{
    countForward=0;
    countBackward=0;
	NSDate *cDate = [currentSchedule.scheduleDate dateByAddingTimeInterval:86400];
    
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
    BOOL validDay = [self isScheduleHasTimeSheets:cDate];
    if([workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
    {
        validDay = YES;
    }
    
    while (!validDay)
    {
		cDate = [cDate dateByAddingTimeInterval:86400];
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
        validDay = [self isScheduleHasTimeSheets:cDate];
        if([workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
        {
            validDay = YES;
        }
        
	}
    
	[self initializeCurrentSchedule:cDate];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];
}

-(void)moveToPreviousDay
{
    countBackward=0;
    countForward=0;
    
	NSDate *cDate = [currentSchedule.scheduleDate dateByAddingTimeInterval:-86400];
    
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
    BOOL validDay = [self isScheduleHasTimeSheets:cDate];
    if([workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
    {
        validDay = YES;
    }
    
    while (!validDay)
    {
		cDate = [cDate dateByAddingTimeInterval:-86400];
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
        validDay = [self isScheduleHasTimeSheets:cDate];
        if([workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
        {
            validDay = YES;
        }
	}
    
	[self initializeCurrentSchedule:cDate];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	
	[UIView commitAnimations];
}

- (IBAction) firstDay:(id)sender
{   
    NSDate *cDate = [NSDate  firstOfMonth:currentSchedule.scheduleDate];
    if (countBackward>0)
    {
        NSDate* first = [cDate dateByAddingTimeInterval:-86400*30] ;
        cDate=[NSDate firstOfMonth:first];
    }
    countBackward++;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
	while (![workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
    {
		cDate = [cDate dateByAddingTimeInterval:86400];
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
        // [dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
	}

    [self initializeCurrentSchedule:cDate];
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[UIView commitAnimations];
}

- (IBAction) lastDay:(id)sender
{
    NSDate *cDate = [NSDate  lastOfMonth:currentSchedule.scheduleDate];

    if (countForward>0)
    {
        NSDate* first = [cDate dateByAddingTimeInterval:86400*10] ;
        cDate=[NSDate lastOfMonth:first];
    }
    countForward++;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
	while (![workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
    {
		cDate = [cDate dateByAddingTimeInterval:-86400];
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:cDate];
        // [dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
	}

	[self initializeCurrentSchedule:cDate];
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];
}

- (void)changeDate:(NSDate*)date
{
	
}

#pragma mark -
#pragma mark Core Data Manipulation

-(BOOL)isScheduleHasTimeSheets:(NSDate*)cDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *cDateString = [dateFormatter stringFromDate:cDate];
    NSDate *ccDate = [dateFormatter dateFromString:cDateString];
    
    
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:ccDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:ccDate];
	[comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate == %@", beginningOfDay];
	[request setPredicate:predicate];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	if (mutableFetchResults == nil || mutableFetchResults.count < 1)
    {
		// Handle the error.
        return NO;
	}
	
	// Set self's events array to the mutable array, then clean up.
	// [self setSchedules:mutableFetchResults];
    Schedule *scd;
	if ([mutableFetchResults count]>0)
    {
		 scd = [mutableFetchResults objectAtIndex:0];
        
        //NSLog(@"Current Schedule : %@",self.currentSchedule.scheduleDate);
	}
    
	[mutableFetchResults release];
	[request release];
    
    if(scd.timeSheets.count > 0)
    {
        return YES;
    }
    
    return NO;
}

- (void) initializeCurrentSchedule:(NSDate*)cDate
{
	if (currentSchedule)
    {
        int count=[timeSheetModels count];

		for (int i=0; i<count; i++)
        {
			TimeSheet *curTimeSheet = [timeSheetModels objectAtIndex:i];
			if ([curTimeSheet.activity.flatMode boolValue])
            {
				curTimeSheet.startTime = [NSNumber numberWithInt:-1];
				curTimeSheet.endTime = [NSNumber numberWithInt:-1];
				curTimeSheet.breakTime = [NSNumber numberWithInt:-1];
			} else
            {
				curTimeSheet.flatTime = [NSNumber numberWithInt:-1];
			}

			curTimeSheet.subSequence = [NSNumber numberWithInt:i];
		}
		
		self.currentSchedule.timeSheets = [NSSet setWithArray:timeSheetModels];
		
		NSError *error;
		if (![managedObjectContext save:&error])
        {
			//NSLog(@"here is error");
		}
		
		self.currentSchedule = nil;		
	}
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *cDateString = [dateFormatter stringFromDate:cDate];
    NSDate *ccDate = [dateFormatter dateFromString:cDateString];
    
    
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:ccDate];
	[dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
    /*
	while (![workingDays containsObject:[NSNumber numberWithInteger:[dateComponents weekday]]])
    {
		ccDate = [ccDate dateByAddingTimeInterval:86400];
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:ccDate];
        
	}
	*/
		
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:ccDate];
	[comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate == %@", beginningOfDay];
	[request setPredicate:predicate];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	if ([mutableFetchResults count]>0)
    {
		self.currentSchedule = [mutableFetchResults objectAtIndex:0];
	}
    
	[mutableFetchResults release];
	[request release];
	
	NSFetchRequest *requestForActivities = [[NSFetchRequest alloc] init];
	NSEntityDescription *activityEntity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
	[requestForActivities setEntity:activityEntity];
	
	NSPredicate *activityPredicate = [NSPredicate predicateWithFormat:@"isEnabled == %@", [NSNumber numberWithBool:YES]];
	[requestForActivities setPredicate:activityPredicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[requestForActivities setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
    [sortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *activitiesError = nil;
	NSArray *activitiesResults = [managedObjectContext executeFetchRequest:requestForActivities error:&activitiesError];
	
    if (activitiesResults == nil) 
    {
		// Handle the error.
	}	
	
    [requestForActivities release];
	
    self.activitiesPickerData = activitiesResults;	
    
	if (!currentSchedule) 
    {
		self.currentSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
		self.currentSchedule.scheduleDate = beginningOfDay;
	}
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
	sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	
	self.timeSheetModels = [NSMutableArray arrayWithArray:[[currentSchedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];

    [ self checkOffsetValue ];
	
	[self bindEntityToView];
    
    [sortDescriptor release];
    [sortDescriptors release];
	
}	

- ( void ) checkOffsetValue
{
    if([currentSchedule.timeSheets count ] == 0)
    {
        if (isZeroAdjustment)
        {
                //Do nothing 
//            self.currentSchedule.offset=0;
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEE"];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [formatter setLocale: locale];
            NSString *dayName = [formatter stringFromDate:self.currentSchedule.scheduleDate];
            [formatter release];
            
            NSString *offsetName = [NSString stringWithFormat:@"%@Offset", dayName];
            
             self.currentSchedule.offset = [ self.settingsDictionary objectForKey: offsetName ];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale: locale];
        NSString *dayName = [formatter stringFromDate:self.currentSchedule.scheduleDate];
        [formatter release];
        
        NSString *offsetName = [NSString stringWithFormat:@"%@Offset", dayName];
        
        self.currentSchedule.offset = [ self.settingsDictionary objectForKey: offsetName ];

    }
    if( [ self.currentSchedule.offset intValue ] == 0)
    {
       // self.currentSchedule.offset = [ self.settingsDictionary objectForKey: @"offset" ];
       // NSLog(@"3333-");
        
    }
}

- (void) bindEntityToView
{ 
    NSLog(@"scheduleId  %@",currentSchedule.identifier);
    
	[activitySelectPicker reloadAllComponents];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//	self.currentDateLabel.text = [dateFormatter stringFromDate:self.currentSchedule.scheduleDate];
    
    if ([[dateFormatter stringFromDate:self.currentSchedule.scheduleDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
    self.currentDateLabel.text = [dateFormatter stringFromDate:self.currentSchedule.scheduleDate];
    
//    NSLog(@"current Date %@", self.currentDateLabel.text);
	
	[dateFormatter setDateFormat:@"EEEE"];
    [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
	self.currentDateStringLabel.text = [[dateFormatter stringFromDate:self.currentSchedule.scheduleDate] capitalizedString];
	currentOffsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
	NSArray *pickerSettings = [self getInitialPickerValuesFromPeriod:currentSchedule.offset];
	
	for (NSInteger i = 0; i<[pickerSettings count]; i++)
    {
		[offsetSelectPicker selectRow:[[pickerSettings objectAtIndex:i] intValue] inComponent:i animated:NO];
	}
	
	scrollDateDetails.contentSize = CGSizeMake(283, 137);
	amountPage = 0;
	currentPage = 0;
	
	pagingText.text = @"0/0";
	
	for (TimeSheetView *timeSheetView in timeSheetsArray)
    {
		[timeSheetView removeFromSuperview];			
	}
	
	self.timeSheetsArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	if ([timeSheetModels count]>0)
    {
		removeButton.hidden = NO;
	}
    else
    {
		removeButton.hidden = YES;
	}
	
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
//	[dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter1 setDateStyle:NSDateFormatterShortStyle];
    NSString *cDate = [dateFormatter1 stringFromDate:self.currentDate];
    
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter1 dateFromString:cDate]];
	//[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
//    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];	
	
	for (TimeSheet *timeSheet in timeSheetModels)
    {
		amountPage ++;
		currentPage = amountPage - 1;
		
		TimeSheetView *timeSheetView = [[TimeSheetView alloc] initWithFrame:CGRectMake(currentPage*283, 0, 283, 137)];
		timeSheetView.activityLabel.text = timeSheet.activity.activityTitle;
		timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];
		timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];
		timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
		timeSheetView.flatTimeLabel.text = [self convertPeriodToString:timeSheet.flatTime];
        timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
        
//		[timeSheetView setShowTimeButtons:[beginningOfDay isEqual:self.currentSchedule.scheduleDate]];
        
        if(timeSheet.activity.showAmount.boolValue)
        {
            [timeSheetView setShowAmountInfo:YES];
        }
        else
        {
            [timeSheetView setShowAmountInfo:NO];
        }
        
        [dateFormatter1 setDateStyle:NSDateFormatterShortStyle];
//        NSString *begDay = [dateFormatter1 stringFromDate:self.currentDate];
        NSString *begDay = [dateFormatter1 stringFromDate:[NSDate date]];
        NSString *currentDay = [dateFormatter1 stringFromDate:self.currentSchedule.scheduleDate];
        
        [timeSheetView setShowTimeButtons:[begDay isEqualToString:currentDay]];
        
        
		[timeSheetView changeActivity:timeSheet.activity];
		[timeSheetView setDelegate:self];
		[scrollDateDetails addSubview:timeSheetView];
		[timeSheetsArray addObject:timeSheetView];
		[timeSheetView release];
		
		scrollDateDetails.contentSize = CGSizeMake((currentPage+1)*283, 137);
	}
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    //		[dateFormatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier: [Localizator localeIdentifierForActiveLanguage]]];
    NSString *templateName = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:self.currentSchedule.scheduleDate], NSLocalizedString(@"TEMPLATE", nil)];
    NSString *titleStr = [templateName capitalizedString];
    
    [dayTemplateButton setTitle:titleStr forState:UIControlStateNormal];
    
    if([GlobalFunctions getShowButtonsOptions1])
    {
        [ dayTemplateButton setHidden: [ timeSheetsArray count ] != 0 ];
    }
    else
    {
        [ dayTemplateButton setHidden: YES];
    }
    if([GlobalFunctions getShowButtonsOptions2])
    {
        [ myTemplareButton setHidden: [ timeSheetsArray count ] != 0 ];
    }
    else
    {
        [ myTemplareButton setHidden: YES];
    }
    
    if([GlobalFunctions getShowButtonsOptions3])
    {
        [ copyLastSheet setHidden: [ timeSheetsArray count ] != 0 ];
    }
    else
    {
        [ copyLastSheet setHidden: YES];
    }
    
    if([GlobalFunctions getShowButtonsOptions4])
    {
        [ firstCheckin setHidden: [ timeSheetsArray count ] != 0 ];
    }
    else
    {
        [ firstCheckin setHidden: YES];
    }
    
	currentPage = 0;
	[scrollDateDetails scrollRectToVisible:CGRectMake(0, 0, 283, 137) animated:NO];
	if (amountPage > 0)
    {
		pagingText.text = [NSString stringWithFormat:@"%d/%d", 1, amountPage];
	}
    else
    {
		pagingText.text = @"0/0";
	}

	[self estimateIndicators];
	
}	

#pragma mark -
#pragma mark Time Sheets Manipulation Functionality

- (IBAction) forwardAction:(id)sender
{
	[self moveToNextTimesheet];
}

-(void)moveToNextTimesheet
{
    if ((currentPage + 1) < amountPage)
    {
		currentPage ++;
		[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage * 283, 0, 283, 137) animated:YES];
		pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage + 1), amountPage];
	}
}

- (IBAction) backAction:(id)sender
{
	[self moveToPreviousTimesheet];
}

-(void)moveToPreviousTimesheet
{
    if (currentPage > 0)
    {
		currentPage --;
		[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
		pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
	}
}

- ( IBAction ) copyLastSheetAction: ( id ) sender
{
    // iterate 30 days back and search for closest sheet with entries
    
    BOOL bFound = NO;
    
    for( NSInteger n = 0; n < 30; n++ )
    {
        NSDate * cDate = [ currentSchedule.scheduleDate dateByAddingTimeInterval: -86400 * ( n + 1 ) ];	
        NSFetchRequest * request = [ [ NSFetchRequest alloc ] init ];
        NSEntityDescription * entity = [ NSEntityDescription entityForName: @"Schedule"
                                                    inManagedObjectContext: managedObjectContext
                                        ];
        [ request setEntity: entity ];
        
        NSDateComponents * comps = [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                                                      fromDate: cDate
                                    ];
        [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
        NSDate * beginningOfDay = [ [ NSCalendar currentCalendar ] dateFromComponents: comps ];	
        
        NSPredicate * predicate = [ NSPredicate predicateWithFormat: @"scheduleDate == %@", beginningOfDay ];
        [ request setPredicate: predicate ];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError * error = nil;
        NSMutableArray * mutableFetchResults = [ [ managedObjectContext executeFetchRequest: request
                                                                                      error: &error ] mutableCopy ];
        if( mutableFetchResults == nil ) 
        {
            // Handle the error. 
        }
        
        // Set self's events array to the mutable array, then clean up.
        // [self setSchedules:mutableFetchResults];
        if( [ mutableFetchResults count ] > 0 ) 
        {
            Schedule * schedule = [ mutableFetchResults objectAtIndex: 0 ];

            //NSLog( @"Current Schedule : %u", [ schedule.timeSheets count ] );
            
            if( [ schedule.timeSheets count ] > 0 )
            {
                bFound = YES;
                
                NSSortDescriptor * sortDescriptor = [ [ NSSortDescriptor alloc ] initWithKey: @"subSequence"
                                                                                   ascending: YES
                                                     ];
                NSArray * sortDescriptors = [ [ NSArray alloc ] initWithObjects: sortDescriptor, nil ]; 
                
                NSMutableArray * models = [ NSMutableArray arrayWithArray: [ [ schedule.timeSheets allObjects ] 
                                                                          sortedArrayUsingDescriptors: sortDescriptors
                                                                            ]
                                           ];

                NSDateFormatter * dateFormatter1 = [ [ NSDateFormatter alloc ] init ];
                [ dateFormatter1 setTimeZone: [ NSTimeZone systemTimeZone ] ];
                [ dateFormatter1 setTimeStyle: NSDateFormatterNoStyle ];
                [ dateFormatter1 setDateStyle: NSDateFormatterShortStyle ];

                NSString * cDate = [ dateFormatter1 stringFromDate: self.currentDate ];
                NSDateComponents * comps = 
                    [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                                       fromDate: [ dateFormatter1 dateFromString: cDate ]
                     ];
                [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
//                NSDate * beginningOfDay = [ [ NSCalendar currentCalendar ] dateFromComponents: comps ];	
                
                removeButton.hidden = NO;
                dayTemplateButton.hidden = YES;
                myTemplareButton.hidden = YES;
                copyLastSheet.hidden = YES;
                firstCheckin.hidden = YES;
                
                amountPage = [ models count ];
                currentPage = amountPage - 1;
                
                self.currentSchedule.offset = schedule.offset;
                
                if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==NO )
                { 
                    self.currentSchedule.offset = [ self.settingsDictionary objectForKey: @"offset" ];
                    NSLog(@"3333");
                }
                else if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==YES )
                { 
                    //CHANGE HERE
                    //self.currentSchedule.offset = [ self.settingsDictionary objectForKey: @"offset" ];
                    NSLog(@"444444");
                }

                
                for( int n = 0; n < [ models count ]; n++ )
                {
                    TimeSheet * sheetOld = [ models objectAtIndex: n ];
                    
                    TimeSheet * timeSheet = ( TimeSheet * ) [ NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
                    timeSheet.startTime = sheetOld.startTime;
                    timeSheet.endTime = sheetOld.endTime;
                    timeSheet.breakTime = sheetOld.breakTime;
                    timeSheet.flatTime = sheetOld.flatTime;
                    timeSheet.subSequence = sheetOld.subSequence;
                    timeSheet.comments = sheetOld.comments;
                    timeSheet.activity = sheetOld.activity;
                    timeSheet.schedule = sheetOld.schedule;
                    timeSheet.amount = sheetOld.amount;
//                    NSLog(@"copylast sheet id %@", timeSheet.scheduleId);

                    [timeSheetModels addObject: timeSheet ];
                    
                    TimeSheetView * timeSheetView = 
                        [[TimeSheetView alloc] initWithFrame: CGRectMake(currentPage * 283, 0, 283, 137)];
                    [timeSheetView setDelegate: self ];
                    
                    [timeSheetView setShowTimeButtons:YES];
                    
                    [timeSheetView changeActivity: timeSheet.activity];
                    timeSheetView.startTimeLabel.text = [ self convertTimeToString: timeSheet.startTime ];
                    timeSheetView.endTimeLabel.text = [ self convertTimeToString: timeSheet.endTime];
                    timeSheetView.breakTimeLabel.text = [ self convertTimeToString: timeSheet.breakTime];
                    timeSheetView.flatTimeLabel.text = [ self convertTimeToString: timeSheet.flatTime];
                    timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
                    
                    [scrollDateDetails addSubview:timeSheetView];
                    [timeSheetsArray addObject: timeSheetView];
                    [timeSheetView release];
                }

                self.currentSchedule.timeSheets = [NSSet setWithArray: timeSheetModels];

                scrollDateDetails.contentSize = CGSizeMake( ( currentPage + 1 ) * 283, 137 );
                [scrollDateDetails scrollRectToVisible: CGRectMake( currentPage * 283, 0, 283, 137 )
                                               animated: YES];
                
                //	$TINGTONG CODE
                [self saveToManagedObjectContext];
                [self initializeCurrentSchedule: self.currentSchedule.scheduleDate];
                
                currentPage = amountPage - 1;
                pagingText.text = [NSString stringWithFormat: @"%d/%d", ( currentPage + 1 ), amountPage];

                break;                
            }
        }
        
        [mutableFetchResults release];
        [request release];
    }

    if(!bFound)
    {
        [self addSheetAction: nil];
    }
    else
    {
        [Appirater appLaunched];
    }
}

- (IBAction) firstCheckinAction:(id)sender
{
    //TODO: add first checkin logic here
}

- (IBAction) insertDayTemplateAction:(id)sender
{
    BOOL bFound = NO;
    
    Settings *setting = nil;
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSError *err = nil;
    NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults == nil || mutableFetchResults.count < 1)
    {
        
    }
    else
    {
        setting = [mutableFetchResults objectAtIndex:0];
    }
    
    NSEnumerator *enumerator = [setting.settingsDayTemplates objectEnumerator];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    SettingsDayTemplate *item;
    while (item = [enumerator nextObject])
    {
        [items addObject:item];
    }
    
    NSDate *today = self.currentSchedule.scheduleDate;
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    [myFormatter setDateFormat:@"c"]; // day number, like 7 for saturday
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [myFormatter setLocale:locale];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@", [NSNumber numberWithInt:dayOfWeek.intValue - 1]];
    NSArray* filteredTemplate = [items filteredArrayUsingPredicate:predicate];
    
    SettingsDayTemplate *template = [filteredTemplate objectAtIndex:0];
    Schedule * schedule = template.schedule;
    
    //NSLog( @"Current Schedule : %u", [ schedule.timeSheets count ] );
    
    if( [ schedule.timeSheets count ] > 0 )
    {
        bFound = YES;
        
        NSSortDescriptor * sortDescriptor = [ [ NSSortDescriptor alloc ] initWithKey: @"subSequence"
                                                                           ascending: YES
                                             ];
        NSArray * sortDescriptors = [ [ NSArray alloc ] initWithObjects: sortDescriptor, nil ];
        
        NSMutableArray * models = [ NSMutableArray arrayWithArray: [ [ schedule.timeSheets allObjects ]
                                                                    sortedArrayUsingDescriptors: sortDescriptors
                                                                    ]
                                   ];
        
        NSDateFormatter * dateFormatter1 = [ [ NSDateFormatter alloc ] init ];
        [ dateFormatter1 setTimeZone: [ NSTimeZone systemTimeZone ] ];
        [ dateFormatter1 setTimeStyle: NSDateFormatterNoStyle ];
        [ dateFormatter1 setDateStyle: NSDateFormatterShortStyle ];
        
        NSString * cDate = [ dateFormatter1 stringFromDate: self.currentDate ];
        NSDateComponents * comps =
        [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                           fromDate: [ dateFormatter1 dateFromString: cDate ]
         ];
        [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
        //                NSDate * beginningOfDay = [ [ NSCalendar currentCalendar ] dateFromComponents: comps ];
        
        removeButton.hidden = NO;
        dayTemplateButton.hidden = YES;
        myTemplareButton.hidden = YES;
        copyLastSheet.hidden = YES;
        firstCheckin.hidden = YES;
        
        amountPage = [ models count ];
        currentPage = amountPage - 1;
        
//        self.currentSchedule.offset = [ self.settingsDictionary objectForKey: offsetName ];
//        self.currentSchedule.offset = schedule.offset;
        
        if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==NO )
        {
//            self.currentSchedule.offset = [ self.settingsDictionary objectForKey: @"offset" ];
        }
        else if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==YES )
        {
        }
        
        for( int n = 0; n < [ models count ]; n++ )
        {
            TimeSheet * sheetOld = [ models objectAtIndex: n ];
            
            TimeSheet * timeSheet = ( TimeSheet * ) [ NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
            timeSheet.startTime = sheetOld.startTime;
            timeSheet.endTime = sheetOld.endTime;
            timeSheet.breakTime = sheetOld.breakTime;
            timeSheet.flatTime = sheetOld.flatTime;
            timeSheet.subSequence = sheetOld.subSequence;
            timeSheet.comments = sheetOld.comments;
            timeSheet.activity = sheetOld.activity;
            timeSheet.schedule = sheetOld.schedule;
            timeSheet.amount = sheetOld.amount;
//            NSLog(@"insert id %@",timeSheet.scheduleId);
            
            [timeSheetModels addObject: timeSheet];
            
            TimeSheetView * timeSheetView =
            [[TimeSheetView alloc] initWithFrame: CGRectMake(currentPage * 283, 0, 283, 137)];
            [timeSheetView setDelegate: self ];
            
            [timeSheetView setShowTimeButtons:YES];
            
            [timeSheetView changeActivity: timeSheet.activity];
            timeSheetView.startTimeLabel.text = [ self convertTimeToString: timeSheet.startTime ];
            timeSheetView.endTimeLabel.text = [ self convertTimeToString: timeSheet.endTime];
            timeSheetView.breakTimeLabel.text = [ self convertTimeToString: timeSheet.breakTime];
            timeSheetView.flatTimeLabel.text = [ self convertTimeToString: timeSheet.flatTime];
            timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
            
            [scrollDateDetails addSubview:timeSheetView];
            [timeSheetsArray addObject: timeSheetView];
            [timeSheetView release];
        }
        
        self.currentSchedule.timeSheets = [NSSet setWithArray: timeSheetModels];
        
        scrollDateDetails.contentSize = CGSizeMake( ( currentPage + 1 ) * 283, 137 );
        [scrollDateDetails scrollRectToVisible: CGRectMake( currentPage * 283, 0, 283, 137 )
                                      animated: YES];
        
        //	$TINGTONG CODE
        [self saveToManagedObjectContext];
        [self initializeCurrentSchedule: self.currentSchedule.scheduleDate];
        
        currentPage = amountPage - 1;
        pagingText.text = [NSString stringWithFormat: @"%d/%d", ( currentPage + 1 ), amountPage];
    }
    
    if(!bFound)
    {
        [self addSheetAction: nil];
    }
    else
    {
        [Appirater appLaunched];
    }
}

- (IBAction) insertMyTemplateAction:(id)sender
{
    [templateSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if(buttonIndex == 1)
        {
            MyOvertimeAppDelegate *app = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
            app.fromAlert = YES;
            [app.tabBarController setSelectedIndex:3];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    
    if(actionSheet == templateSheet)
    {
        if (buttonIndex < 7)
        {
            MyTemplate *template = [self.myTemplates objectAtIndex:buttonIndex];
            [self addTemplateSchedule:template.schedule];
        }
    }
}

-(void)addTemplateSchedule:(Schedule*)_schedule
{
    BOOL bFound = NO;
    
    
    Schedule * schedule = _schedule;
    
    //NSLog( @"Current Schedule : %u", [ schedule.timeSheets count ] );
    
    if( [ schedule.timeSheets count ] > 0 )
    {
        bFound = YES;
        
        NSSortDescriptor * sortDescriptor = [ [ NSSortDescriptor alloc ] initWithKey: @"subSequence"
                                                                           ascending: YES
                                             ];
        NSArray * sortDescriptors = [ [ NSArray alloc ] initWithObjects: sortDescriptor, nil ];
        
        NSMutableArray * models = [ NSMutableArray arrayWithArray: [ [ schedule.timeSheets allObjects ]
                                                                    sortedArrayUsingDescriptors: sortDescriptors
                                                                    ]
                                   ];
        
        NSDateFormatter * dateFormatter1 = [ [ NSDateFormatter alloc ] init ];
        [ dateFormatter1 setTimeZone: [ NSTimeZone systemTimeZone ] ];
        [ dateFormatter1 setTimeStyle: NSDateFormatterNoStyle ];
        [ dateFormatter1 setDateStyle: NSDateFormatterShortStyle ];
        
        NSString * cDate = [ dateFormatter1 stringFromDate: self.currentDate ];
        NSDateComponents * comps =
        [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                           fromDate: [ dateFormatter1 dateFromString: cDate ]
         ];
        [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
        
        removeButton.hidden = NO;
        dayTemplateButton.hidden = YES;
        myTemplareButton.hidden = YES;
        copyLastSheet.hidden = YES;
        firstCheckin.hidden = YES;
        
        amountPage = [ models count ];
        currentPage = amountPage - 1;
        
        self.currentSchedule.offset = schedule.offset;
        
        if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==NO )
        {
//            self.currentSchedule.offset = [ self.settingsDictionary objectForKey: @"offset" ];
        }
        else if( [ self.currentSchedule.offset intValue ] == 0 && isZeroAdjustment==YES )
        {
        }
        
        for( int n = 0; n < [ models count ]; n++ )
        {
            TimeSheet * sheetOld = [ models objectAtIndex: n ];
            
            TimeSheet * timeSheet = ( TimeSheet * ) [ NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
            timeSheet.startTime = sheetOld.startTime;
            timeSheet.endTime = sheetOld.endTime;
            timeSheet.breakTime = sheetOld.breakTime;
            timeSheet.flatTime = sheetOld.flatTime;
            timeSheet.subSequence = sheetOld.subSequence;
            timeSheet.comments = sheetOld.comments;
            timeSheet.activity = sheetOld.activity;
            timeSheet.schedule = sheetOld.schedule;
            timeSheet.amount = sheetOld.amount;
            
            [timeSheetModels addObject: timeSheet];
            
            TimeSheetView * timeSheetView =
            [[TimeSheetView alloc] initWithFrame: CGRectMake(currentPage * 283, 0, 283, 137)];
            [timeSheetView setDelegate: self ];
            
            [timeSheetView setShowTimeButtons:YES];
            
            [timeSheetView changeActivity: timeSheet.activity];
            timeSheetView.startTimeLabel.text = [ self convertTimeToString: timeSheet.startTime ];
            timeSheetView.endTimeLabel.text = [ self convertTimeToString: timeSheet.endTime];
            timeSheetView.breakTimeLabel.text = [ self convertTimeToString: timeSheet.breakTime];
            timeSheetView.flatTimeLabel.text = [ self convertTimeToString: timeSheet.flatTime];
            timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
            
            [scrollDateDetails addSubview:timeSheetView];
            [timeSheetsArray addObject: timeSheetView];
            [timeSheetView release];
        }
        
        self.currentSchedule.timeSheets = [NSSet setWithArray: timeSheetModels];
        
        scrollDateDetails.contentSize = CGSizeMake( ( currentPage + 1 ) * 283, 137 );
        [scrollDateDetails scrollRectToVisible: CGRectMake( currentPage * 283, 0, 283, 137 )
                                      animated: YES];
        
        //	$TINGTONG CODE
        [self saveToManagedObjectContext];
        [self initializeCurrentSchedule: self.currentSchedule.scheduleDate];
        
        currentPage = amountPage - 1;
        pagingText.text = [NSString stringWithFormat: @"%d/%d", ( currentPage + 1 ), amountPage];
    }
    
    if(!bFound)
    {
        [self addSheetAction: nil];
    }
    else
    {
        [Appirater appLaunched];
    }
}

- (IBAction) addSheetAction:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *beginningOfDay = [formatter stringFromDate:[NSDate date]];
    NSString *compareDate = [formatter stringFromDate:self.currentSchedule.scheduleDate];
	
	removeButton.hidden = NO;
    myTemplareButton.hidden =
    dayTemplateButton.hidden =
	copyLastSheet.hidden =
    firstCheckin.hidden = YES;
	
	amountPage ++;
	currentPage = amountPage - 1;
	
	TimeSheet *timeSheet = (TimeSheet *)[NSEntityDescription insertNewObjectForEntityForName:@"TimeSheet" inManagedObjectContext:managedObjectContext];
	timeSheet.startTime = [NSNumber numberWithInt:-1];
	timeSheet.endTime = [NSNumber numberWithInt:-1];
	timeSheet.breakTime = [NSNumber numberWithInt:-1];
	timeSheet.flatTime = [NSNumber numberWithInt:-1];
    
	[timeSheetModels addObject:timeSheet];
	
	TimeSheetView *timeSheetView = [[TimeSheetView alloc] initWithFrame:CGRectMake(currentPage*283, 0, 283, 137)];
	[timeSheetView setDelegate:self];
    [timeSheetView setShowTimeButtons:[beginningOfDay isEqual:compareDate]];
    
    
	[scrollDateDetails addSubview:timeSheetView];
	[timeSheetsArray addObject:timeSheetView];
	[timeSheetView release];

	scrollDateDetails.contentSize = CGSizeMake((currentPage+1)*283, 137);
	[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
    
	pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];	
	
    [ Appirater appLaunched ];
	[ self saveToManagedObjectContext ];
}	

- (IBAction) removeSheetAction:(id)sender
{
	if (amountPage>0)
    {
		amountPage --;
		currentPage --;
		
		scrollDateDetails.contentSize = CGSizeMake(scrollDateDetails.contentSize.width - 283, 137);
		[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
	
		TimeSheet *timeSheet = [timeSheetModels objectAtIndex:(currentPage+1)];
		[managedObjectContext deleteObject:timeSheet];
		[timeSheetModels removeObject:timeSheet];
		
		TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:(currentPage+1)];
		[timeSheetsArray removeObject:timeSheetView];
		[timeSheetView removeFromSuperview];
		
        NSInteger count = [ timeSheetsArray count ];
        
        if([GlobalFunctions getShowButtonsOptions1])
        {
            [ dayTemplateButton setHidden: [ timeSheetsArray count ] != 0 ];
        }
        else
        {
            [ dayTemplateButton setHidden: YES];
        }
        if([GlobalFunctions getShowButtonsOptions2])
        {
            [ myTemplareButton setHidden: [ timeSheetsArray count ] != 0 ];
        }
        else
        {
            [ myTemplareButton setHidden: YES];
        }
        
        if([GlobalFunctions getShowButtonsOptions3])
        {
            [ copyLastSheet setHidden: [ timeSheetsArray count ] != 0 ];
        }
        else
        {
            [ copyLastSheet setHidden: YES];
        }
        
        if([GlobalFunctions getShowButtonsOptions4])
        {
            [ firstCheckin setHidden: [ timeSheetsArray count ] != 0 ];
        }
        else
        {
            [ firstCheckin setHidden: YES];
        }

		for (int i=(currentPage+1); i<count; i++)
        {
			timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:i];
			timeSheetView.frame = CGRectMake(i*283, 0, 283, 137);
		}
		
		if (currentPage<0)
        {
			currentPage = 0;
		}
		
		if (amountPage == 1)
        {
			pagingText.text = @"1/1";
		}
        else if (amountPage == 0)
        {
			pagingText.text = @"0/0";
			removeButton.hidden = YES;
		}
        else
        {
			pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
		}
				
		[self estimateIndicators];

		//	$TINGTONG CODE
		[self saveToManagedObjectContext];
        [ self checkOffsetValue ];
        [ self bindEntityToView ];
	}
}	

#pragma mark -
#pragma mark Indicators Estimation

- (void) estimateIndicators
{
	int offset = [currentSchedule.offset intValue];
	int total = 0;
	BOOL isAnyEstimation = NO;
    
	for (TimeSheet *timeSheet in timeSheetModels)
    {
		if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
        {
			continue;
		}
		
		if ([timeSheet.activity.flatMode boolValue])
        {
			if ([timeSheet.flatTime intValue]<0)
            {
//				continue;
			}
		}
        else
        {
			if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
            {
				continue;
			}
		}
	
		isAnyEstimation = YES;
		
		if ([timeSheet.activity.estimateMode boolValue])
        {
			if ([timeSheet.activity.flatMode boolValue])
            {
                if(timeSheet.activity.overtimeReduce.boolValue)
                {
                    total -= [timeSheet.flatTime intValue];
                }
                else
                {
                    total += [timeSheet.flatTime intValue];
                }
			}
            else
            {
				if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                {
					total += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
				}
                else
                {
					total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
				}					
				if ([timeSheet.breakTime intValue]>0)
                {
					total -= [timeSheet.breakTime intValue];
				}	
			}
		}	
	}
	
	if (isAnyEstimation)
    {
        
        if(timeStyle == StyleDecimal)
        {
            totalIndicatorLabel.text = [self convertPeriodToStringDecimal:[NSNumber numberWithInt:total]];
            balanceIndicatorLabel.text = [self convertPeriodToStringDecimal:[NSNumber numberWithInt:(total - offset)]];
        }
        else
        {
            totalIndicatorLabel.text = [self convertPeriodToString:[NSNumber numberWithInt:total]];
            balanceIndicatorLabel.text = [self convertPeriodToString:[NSNumber numberWithInt:(total - offset)]];
        }
	}
    else
    {
        if(timeStyle == StyleDecimal)
        {
            totalIndicatorLabel.text = @"0.00";
            balanceIndicatorLabel.text = [self convertPeriodToStringDecimal:[NSNumber numberWithInt:(0 - offset)]];
        }
        else
        {
            totalIndicatorLabel.text = @"0:00";
            balanceIndicatorLabel.text = [self convertPeriodToString:[NSNumber numberWithInt:(0 - offset)]];
        }
	}
	
//    NSLog(@"totla %d balance %@ and offSet %d", total, balanceIndicatorLabel.text, offset);
}

#pragma mark -
#pragma mark Time Converting functionality

- (NSString*) convertTimeToString:(NSNumber*)time
{
	if ([time intValue]==-1)
    {
		return @"";
	}	
	
	int hours = ([time intValue]/60.0);
	int minutes = [time intValue] - hours * 60;
	
	NSString *amPM = @"";
    
    if (timeStyle == StyleAmPm && !setTimeForFlatHours)
    {
		if (hours == 0)
        {
            amPM = NSLocalizedString(@"LOCAL_AM", nil);
			hours = 12;
		}
        else if (hours == 12)
        {
            amPM = NSLocalizedString(@"LOCAL_PM", nil);
        }
        
        else  if (hours < 12)
        {
            amPM = NSLocalizedString(@"LOCAL_AM", nil);
		}
        else
        {
            amPM = NSLocalizedString(@"LOCAL_PM", nil);
			hours -= 12;
		}
	}
	
	if ((minutes < 10)&&(hours < 10))
    {
		return [NSString stringWithFormat:@"%d:0%d %@", hours, minutes, amPM];
	}
    else if (minutes < 10)
    {
		return [NSString stringWithFormat:@"%d:0%d %@", hours, minutes, amPM];
	}
    else if (hours < 10)
    {
		return [NSString stringWithFormat:@"%d:%d %@", hours, minutes, amPM];
	}
    else
    {
		return [NSString stringWithFormat:@"%d:%d %@", hours, minutes, amPM];
	}
}

-(NSString*) convertPeriodToStringDecimal:(NSNumber*)period
{
    if ([period intValue]==-1)
    {
		return @"";
	}
	if ([period intValue]< 0)
    {
		int hours = ([period intValue]*(-1)/60.0);
		int minutes = [period intValue]*(-1) - hours * 60;
        
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
        
        return [NSString stringWithFormat:@"-%0.2f", decimalHours];
	}
    else
    {
		int hours = floor([period intValue]/60.0);
		int minutes = [period intValue] - hours * 60;
        
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
		
		return [NSString stringWithFormat:@"%0.2f", decimalHours];
	}
}

- (NSString*) convertPeriodToString:(NSNumber*)period
{
	if ([period intValue]==-1)
    {
		return @"";
	}
	if ([period intValue]< 0)
    {
		int hours = ([period intValue]*(-1)/60.0);
		int minutes = [period intValue]*(-1) - hours * 60;
				
		if (minutes < 10)
        {
			return [NSString stringWithFormat:@"-%d:0%d", hours, minutes];
		}
        else
        {
			return [NSString stringWithFormat:@"-%d:%d", hours, minutes];
		}
	}
    else
    {
		int hours = floor([period intValue]/60.0);
		int minutes = [period intValue] - hours * 60;
		
		if (minutes < 10)
        {
            if (hours<10)
            {
                return [NSString stringWithFormat:@"0%d:0%d", hours, minutes];
            }
            else
            {
                return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
            }
			
		}
        else
        {
            if (hours < 10)
            {
                return [NSString stringWithFormat:@"0%d:%d", hours, minutes];
            }
            else
            {
                return [NSString stringWithFormat:@"%d:%d", hours, minutes];
            }
		}
	}
}	

- (NSNumber*) convertPickerDataToTimeFromView:(UIPickerView*)pickerView
{
	int hoursValue = 0;

    if (timeStyle == StyleAmPm)
    {
		hoursValue = [pickerView selectedRowInComponent:0] % 12;
        
		if ([pickerView selectedRowInComponent:2] == 1)
        {
            hoursValue += 12;
 		}
	}
    else
    {
		hoursValue = [pickerView selectedRowInComponent:0];
	}
	
	int minutesValue = [pickerView selectedRowInComponent:1] * [self safeTimeInterval];

	return [NSNumber numberWithInt:(hoursValue * 60 + minutesValue)];
}	

- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView
{
    int hoursValue = 0;
    int minutesValue = 0;
    
    NSNumber *number;
    
    if(pickerView == flatTimeSelectPicker)
    {
        hoursValue = [pickerView selectedRowInComponent:0];
        minutesValue = [pickerView selectedRowInComponent:1] * [self safeTimeInterval];
        
        number = [NSNumber numberWithInt:(hoursValue * 60 + minutesValue)];
    }
    else
    {
        hoursValue = [pickerView selectedRowInComponent:0];
        minutesValue = [pickerView selectedRowInComponent:1] * [self safeTimeInterval];
        
        number = [NSNumber numberWithInt:(hoursValue*60 + minutesValue)];
    }
    
    return number;
}	

- (NSArray*) getInitialPickerValuesFromTime:(NSNumber*)time
{
	if ([time intValue]==-1)
    {
		NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
																  fromDate:[NSDate date]];
		[comps setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];	
        
		time = [NSNumber numberWithDouble:((-1.0 / 60.0) * [beginningOfDay timeIntervalSinceNow])];
	}			
	
	int hours = floor([time intValue] / 60.0);
	int minutes = ([time intValue] - hours * 60) / [self safeTimeInterval];

    if (timeStyle == StyleAmPm)
    {
        if (hours==24)
        {
			return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
		}
        else if (hours == 12)
        {
			return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
		}
        else if (hours < 12)
        {
			return [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
		}
        else
        {
			return [NSArray arrayWithObjects:[NSNumber numberWithInt:(hours-12)], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
		}
	}
    else
    {
		return [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
	}
}	

- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period
{
    NSArray * array;
    
    if(isFlatTimePickerOn)
    {
        if ([period intValue]<0)
        {
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
        }
        
        int hours = floor([period intValue] / 60.0);
        int minutes = ([period intValue] - hours * 60) / [self safeTimeInterval];
        
        array = [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
    }
    else
    {
        if ([period intValue] < 0)
        {
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
        }
        
        int hours = floor([period intValue] / 60.0);
        int minutes = ([period intValue] - hours * 60) / [self safeTimeInterval];
        
        array = [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
    }
    
    return array;
}	

- ( NSInteger ) safeTimeInterval
{
    NSInteger timeInterval = [ [ self.settingsDictionary objectForKey: @"timeDialInterval" ] intValue ];
    
    if( (timeInterval != 1) && (timeInterval != 5) && (timeInterval != 15) && ( timeInterval != 3 ))
        timeInterval = 1;

    return timeInterval;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	//NSLog(@"Unload");
}

- (void)dealloc {
	
	[timeSheetsArray release];
	
	[pagingText release];
	
	[scrollDateDetails release];
	
	[currentOffsetLabel release];
	[currentDateStringLabel release];
	[currentDateLabel release];
	
	[dateIdentificationCell release];
	[dateDetailsCell release];
	[totalResultsSection release];
	[headerView release];
	[userIdentificationLabel release];
	
	[dateSelectView release];
	[dateSelectPicker release];
	
	[offsetSelectView release];
	[offsetSelectPicker release];
	
	[activitySelectView release];
	[activitySelectPicker release];
	[activitiesPickerData release];
	
	[startTimeSelectView release];
	[startTimeSelectPicker release];
	
	[endTimeSelectView release];
	[endTimeSelectPicker release];
	
	[breakTimeSelectView release];
	[breakTimeSelectPicker release];
	
	[flatTimeSelectView release];
	[flatTimeSelectPicker release];
		
	[timeSheetsArray release];
	[settingsDictionary release];
	
	[workingDays release];
	[managedObjectContext release];
	
	[currentSchedule release];
	[currentDate release];
	
	[timeSheetModels release];
	
	[totalIndicatorLabel release];
	[balanceIndicatorLabel release];
	
	[removeButton release];
	
	[inAppPurchaseView release];
	[waitingView release];
	[innerWaitingView release];
	
	[commentsView release];
	[commentsTextView release];
    
    [templateSheet release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark In App purchase functionality

- (IBAction) showInAppPurchaseView:(id)sender
{
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	inAppPurchaseView.frame = initialRect;
	[self.view.window addSubview:inAppPurchaseView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 inAppPurchaseView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];	
}	

- (IBAction) hideInAppPurchaseView:(id)sender
{
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3 
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 inAppPurchaseView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [inAppPurchaseView removeFromSuperview];
					 }];	
}	

- (IBAction) purchaseCalendar:(id)sender
{
	/*SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.danielg.appLite.fullCalendar"];
	[[SKPaymentQueue defaultQueue] addPayment:payment];*/
	
}	

#pragma mark -
#pragma mark Comments text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
    {
		[textView resignFirstResponder];
		[self hideCommentsWindow:nil];
		return NO;
	}
	return YES;
}

//	$TINGTONG METHOD FOR SAVE COREDATA
- (void)saveToManagedObjectContext
{
	NSError *error;
	if (![managedObjectContext save:&error])
    {
		// Handle the error.
	}
}


//Checks if not a purchased item then goes back and deletes all data- P.C.
-(BOOL) checkIf12DaysLimit
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isProduct1Purchased)
    {
        //If purchased then return, no action
        return NO;
    }
    
    //Else proceed to delete
    
    int n=12;//Go back 10 days
    
    NSDate * cDate = [ [NSDate new] dateByAddingTimeInterval: -86400 * ( n + 1 ) ];
    NSFetchRequest * request = [ [ NSFetchRequest alloc ] init ];
    NSEntityDescription * entity = [ NSEntityDescription entityForName: @"Schedule"
                                                inManagedObjectContext: managedObjectContext
                                    ];
    [ request setEntity: entity ];
    
    NSDateComponents * comps = [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                                                  fromDate: cDate
                                ];
    [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
    NSDate * beginningOfDay = [ [ NSCalendar currentCalendar ] dateFromComponents: comps ];
    
    NSPredicate * predicate = [ NSPredicate predicateWithFormat: @"scheduleDate <= %@", beginningOfDay ];
    [ request setPredicate: predicate ];
    
    // Execute the fetch -- create a mutable copy of the result.
    NSError * error = nil;
    NSMutableArray * mutableFetchResults = [ [ managedObjectContext executeFetchRequest: request
                                                                                  error: &error ] mutableCopy];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if( mutableFetchResults == nil )
    {
        // Handle the error.
    }
    
    for(int i=0; i< mutableFetchResults.count; i++)
    {
        Schedule *schedule = [mutableFetchResults objectAtIndex:i];
        
        if(schedule.settingsDayTemplate == nil && schedule.myTemplate == nil)
        {
            [tempArray addObject:schedule];
        }
    }    
    if( [ tempArray count ] > 0 )
    {
        BOOL status=[self getProductStatus];
        if (!status)
        {
            return YES;
        }
        else return NO;
    }
    return NO;
}

-(void) inAppLimitationCheck
{
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isProduct1Purchased)
    {
        //If purchased then return, no action
        return;
    }
   
    //Else proceed to delete
   
    int n=14;//Go back 10 days 

    NSDate * cDate = [ [NSDate new] dateByAddingTimeInterval: -86400 * ( n + 1 ) ];
    NSFetchRequest * request = [ [ NSFetchRequest alloc ] init ];
    NSEntityDescription * entity = [ NSEntityDescription entityForName: @"Schedule"
                                                inManagedObjectContext: managedObjectContext
                                    ];
    [ request setEntity: entity ];
    
    NSDateComponents * comps = [ [ NSCalendar currentCalendar ] components: ( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit )
                                                                  fromDate: cDate
                                ];
    [ comps setTimeZone: [ NSTimeZone timeZoneWithName: @"GMT-1000" ] ];
    NSDate * beginningOfDay = [ [ NSCalendar currentCalendar ] dateFromComponents: comps ];
    
    NSPredicate * predicate = [ NSPredicate predicateWithFormat: @"scheduleDate <= %@", beginningOfDay ];
    [ request setPredicate: predicate ];
    
    // Execute the fetch -- create a mutable copy of the result.
    NSError * error = nil;
    NSMutableArray * mutableFetchResults = [ [ managedObjectContext executeFetchRequest: request
                                                                                  error: &error ] mutableCopy];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if( mutableFetchResults == nil ) 
    {
        // Handle the error. 
    }
    
    for(int i=0; i< mutableFetchResults.count; i++)
    {
        Schedule *schedule = [mutableFetchResults objectAtIndex:i];
        
        if(schedule.settingsDayTemplate == nil && schedule.myTemplate == nil)
        {
            [tempArray addObject:schedule];
        }
    }
    
    if( [ tempArray count ] > 0 )
    {
        BOOL status=[self getProductStatus];
        if (!status)
        {
            if(!inAppLimitationAlertShown)
            {
                UIAlertView *reminderAlertView = [[UIAlertView alloc] initWithTitle:kAlertHeaderProduct2 message:kAlertMessageProduct2 delegate:self cancelButtonTitle:NSLocalizedString(@"LATER", nil)  otherButtonTitles:NSLocalizedString(@"TAKE_ME_THERE", nil), nil];
                reminderAlertView.tag = 101;
                [reminderAlertView show];
                [reminderAlertView release];
                
                inAppLimitationAlertShown = YES;
            }
            
            [self updateAlertStatus ];
        }
        // NSLog(@"count %d",[mutableFetchResults count]);
        
        
        for (int i=0;i<[tempArray count];i++)
        {
            Schedule * schedule = [ tempArray objectAtIndex: i ];
            if(schedule.settingsDayTemplate)
            {
                
            }
            else if (schedule.myTemplate)
            {
                
            }
            else
            {
                [managedObjectContext deleteObject:schedule];
            }
        }
    }
}

-(void) updateAlertStatus
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // int firstSelected= [prefs integerForKey:@"UpgradeProduct"];
    NSString *archiveKey=[NSString stringWithFormat:@"Product1ALert"];
    [prefs setInteger:1 forKey:archiveKey];
    [prefs synchronize];
}

-(BOOL )getProductStatus
{
    BOOL flag=NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *archiveKey=[NSString stringWithFormat:@"Product1ALert"];
    NSInteger buyFlag= [prefs integerForKey:archiveKey];
    if (buyFlag==1)
    {
//        flag= YES;
    }
    return  flag;
}

- ( void ) saveAllSettings
{
    //[self bindDataToProperties];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	[self.settingsDictionary writeToFile:path atomically:YES];
}

-(void)openBackUp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    if(timeStyle == StyleAmPm)
    {
        NSString *dmyFormate = [NSString stringWithFormat:@"%@ hh.mm.ss a", [Localizator dateFormatForActiveLanguage]];
        [formatter setDateFormat:dmyFormate];
    }
    else
    {
        NSString *dmyFormate = [NSString stringWithFormat:@"%@ HH.mm.ss", [Localizator dateFormatForActiveLanguage]];
        [formatter setDateFormat:dmyFormate];
    }
    
    NSString *cDate = [formatter stringFromDate:[NSDate date]];
    cDate = [cDate stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *attachmentName = [NSString stringWithFormat:@"MyOvertime_%@_%@",NSLocalizedString(@"BACKUP_FILENAME", nil),cDate];
    
    ScaryBugDoc *bugDoc = [[ScaryBugDoc alloc]initWithTitle:@"MyOvertimeBackup"];
    bugDoc.data.title = NSLocalizedString(@"BACKUP_FILENAME", nil);
    
    if(timeStyle == StyleAmPm)
    {
        attachmentName = [GlobalFunctions getChangedFileName:attachmentName];
    }
    
    NSData *bugData = [bugDoc testEmail];
    
    NSString *fileName;
    if (bugData != nil)
    {
        fileName=[NSString stringWithFormat:@"%@.motd",attachmentName];
    }
    
    DBPath *folderPath = [[DBPath root] childPath:kDropboxFolderName];
    
    DBPath *dataFilePath = [folderPath childPath:fileName];
    
    DBFile *dataFile = [[DBFilesystem sharedFilesystem] createFile:dataFilePath error:nil];
    
    if (dataFile)
    {
        [dataFile writeData:bugData error:nil];
        [GlobalFunctions setLastBackUpDate:[NSDate date]];
    }
    else
    {
        NSLog(@"error");
        if([[DBFilesystem sharedFilesystem] deletePath:dataFilePath error:nil])
        {
            dataFile = [[DBFilesystem sharedFilesystem] createFile:dataFilePath error:nil];
            [dataFile writeData:bugData error:nil];
            [GlobalFunctions setLastBackUpDate:[NSDate date]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:@"Error occured while backing up data. Please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

-(void)closeView:(id) sender
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(NSInteger)getValueForDay:(NSInteger)day
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key=[NSString stringWithFormat:@"DAY_VAL_%d",day];
    NSInteger dayValue= [[userDefaults valueForKey:key] intValue];
    return dayValue;
}

-(void)fetchMyTemplates
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"MyTemplate" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [req setSortDescriptors:sortDescriptors];
    
    NSError *err = nil;
    NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
    {
        
    }
    else
    {
        self.myTemplates = [mutableFetchResults1 mutableCopy];
        
        MyTemplate *temp1 = [self.myTemplates objectAtIndex:0];
        MyTemplate *temp2 = [self.myTemplates objectAtIndex:1];
        MyTemplate *temp3 = [self.myTemplates objectAtIndex:2];
        MyTemplate *temp4 = [self.myTemplates objectAtIndex:3];
        MyTemplate *temp5 = [self.myTemplates objectAtIndex:4];
        MyTemplate *temp6 = [self.myTemplates objectAtIndex:5];
        MyTemplate *temp7 = [self.myTemplates objectAtIndex:6];
        
        templateSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"TEMPLATE_ACTION_MESSAGE", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"BACKGROUND_ACTION_SHEET_CANCEL_BUTTON", nil)
                                      destructiveButtonTitle:nil otherButtonTitles:temp1.templateName, temp2.templateName, temp3.templateName, temp4.templateName, temp5.templateName, temp6.templateName, temp7.templateName, nil];
    }
}

-(void)fetchSettings
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings"
                                              inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
    NSError *error = nil;
	NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (mutableFetchResults != nil && mutableFetchResults.count > 0)
    {
        self.settings = [mutableFetchResults objectAtIndex:0];
	}
    else
    {
        self.settings = nil;
    }
}

@end

