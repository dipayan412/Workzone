//
//  TemplateDetailViewController.m
//  MyOvertime
//
//  Created by Ashif on 2/19/13.
//
//

#import "TemplateDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Schedule.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "StaticConstants.h"
#import "MyOvertimeAppDelegate.h"

@interface TemplateDetailViewController ()

- (NSString*) convertTimeToString:(NSNumber*)time;
- (NSNumber*) convertPickerDataToTimeFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromTime:(NSNumber*)time;

- (NSString*) convertPeriodToString:(NSNumber*)period;
- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period;

- (void) initializeCurrentSchedule:(Schedule*)_schedule;
- (void) bindEntityToView;

- (void) saveToManagedObjectContext;	//	$TINGTONG CODE

@end

@implementation TemplateDetailViewController

@synthesize dateDetailsCell;
@synthesize nameDetailCell;
@synthesize offsetDetailsCell;
@synthesize scrollDateDetails;

@synthesize offsetSelectPicker, offsetSelectView;

@synthesize myTemplate;

@synthesize hoursPickerData, minutesPickerData, hoursPickerDateAMMode, amPMPickerData;
@synthesize activitySelectView, activitySelectPicker, activitiesPickerData;
@synthesize startTimeSelectView, startTimeSelectPicker;
@synthesize endTimeSelectView, endTimeSelectPicker;
@synthesize breakTimeSelectView, breakTimeSelectPicker;
@synthesize flatTimeSelectView, flatTimeSelectPicker;

@synthesize timeSheetsArray;
@synthesize settingsDictionary;

@synthesize managedObjectContext;

@synthesize currentSchedule;
@synthesize timeSheetModels;

@synthesize commentsView, commentsTextView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    managedObjectContext = app.managedObjectContext;
    
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
    
    
    activitySelectPicker.delegate = self;
	activitySelectPicker.dataSource = self;
    
	NSMutableArray *hoursAMModeArray = [[NSMutableArray alloc] initWithCapacity:1];
	for (int i=1; i<=12; i++)
    {
		[hoursAMModeArray addObject:[NSString stringWithFormat:@"%d", i]];
	}
    
	self.hoursPickerDateAMMode = hoursAMModeArray;
	[hoursAMModeArray release];
    
	NSMutableArray *amPMModesArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [amPMModesArray addObject:NSLocalizedString(@"LOCAL_AM", nil)];
    [amPMModesArray addObject:NSLocalizedString(@"LOCAL_PM", nil)];
    
	self.amPMPickerData = amPMModesArray;
	[amPMModesArray release];
	
	scrollDateDetails.backgroundColor = [UIColor clearColor];
	scrollDateDetails.scrollEnabled = NO;
	scrollDateDetails.showsHorizontalScrollIndicator = NO;
	scrollDateDetails.contentSize = CGSizeMake(283, 137);
	scrollDateDetails.pagingEnabled = YES;
    
    CGRect frame = scrollDateDetails.frame;
    frame.size.width = 283;
    scrollDateDetails.frame = frame;
    
	// reminder mechanism
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSMutableArray *hoursArray = [[NSMutableArray alloc] initWithCapacity:1];
	for (int i=0; i<=23; i++)
    {
		[hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
	}
	self.hoursPickerData = hoursArray;
	[hoursArray release];
    
    timeSheetModels = [[NSMutableArray alloc] init];
    timeSheetsArray = [[NSMutableArray alloc] init];
    
    nameDetailCell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    nameDetailCell.backgroundView = nil;
    nameDetailCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    self.title = self.myTemplate.templateName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    templateNameField.text = self.myTemplate.templateName;
    
    self.currentSchedule = self.myTemplate.schedule;
    offsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
    
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
    NSMutableArray *minutesArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSInteger timeInterval = [ self safeTimeInterval ];
    
	//	Changed by $TINGTONG
	for (int i=0; i<60; i+=timeInterval)
    {
		if (i<10)
        {
			[minutesArray addObject:[NSString stringWithFormat:@"0%d", i]];
		}
        else
        {
			[minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
		}
	}
	
	self.minutesPickerData = minutesArray;
	[minutesArray release];
    
    
	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
    
	is24hoursMode = [[self.settingsDictionary objectForKey:@"is24hoursMode"] boolValue];
    
    timeStyle = [GlobalFunctions getTimeStyle];
	
	[self initializeCurrentSchedule:self.currentSchedule];
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
	
	self.currentSchedule = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return nameDetailCell;
    }
    else if (indexPath.row == 1)
    {
        return offsetDetailsCell;
    }
    return dateDetailsCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 64;
    }
    else if (indexPath.row ==1)
    {
        return 67;
    }
	return 180;
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

- (IBAction) hideSelectOffsetView:(id)sender {
	
	self.currentSchedule.offset = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
	offsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
	
    //NSLog(@"hhhhh %d",[self.currentSchedule.offset intValue]);
    if ([self.currentSchedule.offset intValue]==0)
    {
        isZeroAdjustment=YES;
    }
    else
    {
        isZeroAdjustment=NO;
    }
	
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
    
	if (![timeSheet.activity isEqual:[activitiesPickerData objectAtIndex:[activitySelectPicker selectedRowInComponent:0]]])
    {
		timeSheet.activity = [activitiesPickerData objectAtIndex:[activitySelectPicker selectedRowInComponent:0]];
		
		timeSheet.startTime = [NSNumber numberWithInt:-1];
		timeSheet.endTime = [NSNumber numberWithInt:-1];
		timeSheet.breakTime = [NSNumber numberWithInt:-1];
        
        if( [ timeSheet.activity.flatMode boolValue ])
        {
            if(timeSheet.activity.useDefault.boolValue)
            {
                timeSheet.flatTime = timeSheet.activity.offsetValue;
            }
            else
            {
                timeSheet.flatTime = self.currentSchedule.offset;
            }
            
            if(timeSheet.activity.showAmount.boolValue)
            {
                timeSheet.amount = [NSNumber numberWithFloat:timeSheet.activity.amount.floatValue];
            }
            else
            {
                timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            }
        }
        
        if(timeSheet.activity.flatMode.boolValue)
        {
            setTimeForFlatHours = YES;
        }
        else
        {
            setTimeForFlatHours = NO;
        }
		
		TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
		[timeSheetView changeActivity:[activitiesPickerData objectAtIndex:[activitySelectPicker selectedRowInComponent:0]]];
		timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];
		timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];
		timeSheetView.breakTimeLabel.text = [self convertTimeToString:timeSheet.breakTime];
		timeSheetView.flatTimeLabel.text = [self convertTimeToString:timeSheet.flatTime];
        timeSheetView.amountField.text = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
        if(timeSheet.activity.showAmount.boolValue)
        {
            timeSheetView.amountField.hidden = NO;
            timeSheetView.amountLabel.hidden = NO;
        }
        else
        {
            timeSheetView.amountField.hidden = YES;
            timeSheetView.amountLabel.hidden = YES;
        }
        
		//	$TINGTONG CODE
		[self saveToManagedObjectContext];
	}
    
    if(timeSheet.activity.overtimeReduce.boolValue)
    {
        if(currentPage == 0)
        {
            self.currentSchedule.offset = [NSNumber numberWithInt:0];
            
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
					 completion:^(BOOL finished)
                     {
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
    NSLog(@"value %@", value);
    
    timeSheet.amount = [NSNumber numberWithFloat:value.floatValue];
    
    [self saveToManagedObjectContext];
}

- (IBAction) showSelectStartTimeView:(id)sender {
	
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

- (IBAction) hideSelectStartTimeView:(id)sender {
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.startTime = [self convertPickerDataToTimeFromView:startTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.startTimeLabel.text = [self convertTimeToString:timeSheet.startTime];
	
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

- (IBAction) showSelectEndTimeView:(id)sender {
	
	[endTimeSelectPicker reloadAllComponents];
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	NSArray *pickerSettings = [self getInitialPickerValuesFromTime:timeSheet.endTime];
    
	for (NSInteger i = 0; i<[pickerSettings count]; i++) {
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

- (IBAction) hideSelectEndTimeView:(id)sender {
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.endTime = [self convertPickerDataToTimeFromView:endTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.endTimeLabel.text = [self convertTimeToString:timeSheet.endTime];
	
	if ([timeSheet.breakTime intValue] == -1)
    {
        timeSheet.breakTime = [NSNumber numberWithInt:60];
		timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
	}
	
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

- (IBAction) showSelectBreakTimeView:(id)sender {
    
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

- (IBAction) hideSelectBreakTimeView:(id)sender {
	
	TimeSheet *timeSheet = [timeSheetModels objectAtIndex:currentPage];
	timeSheet.breakTime = [self convertPickerDataToPeriodFromView:breakTimeSelectPicker];
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.breakTimeLabel.text = [self convertPeriodToString:timeSheet.breakTime];
	
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
    //    NSLog(@"flat time %@", timeSheet.flatTime);
	
	TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
	timeSheetView.flatTimeLabel.text = [self convertPeriodToString:timeSheet.flatTime];
    //    NSLog(@"timeSheetView.flatTimeLabel %@", timeSheetView.flatTimeLabel.text);
	
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

- (void) showSelectStartTimeDelegate:(id)sender {
	[self showSelectStartTimeView:sender];
}

- (void) showSelectEndTimeDelegate:(id)sender {
	[self showSelectEndTimeView:sender];
}

- (void) showSelectBreakTimeDelegate:(id)sender {
	[self showSelectBreakTimeView:sender];
}

- (void) showSelectFlatTimeDelegate:(id)sender {
	[self showSelectFlatTimeView:sender];
}

- (void) showCommentsWindowDelegate:(id)sender
{
	[self showCommentsWindow:sender];
}

#pragma mark -
#pragma mark PickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == activitySelectPicker)
    {
		TimeSheetView *timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:currentPage];
		[timeSheetView changeActivity:[activitiesPickerData objectAtIndex:row]];
	}
    else if (pickerView == offsetSelectPicker)
    {
        self.currentSchedule.offset = [self convertPickerDataToPeriodFromView:offsetSelectPicker];
        offsetLabel.text = [self convertPeriodToString:currentSchedule.offset];
        //Pcasso change
        //[settingsDictionary setObject:self.currentSchedule.offset forKey:@"offset"];
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == offsetSelectPicker)
    {
		if (component == 0)
        {
			return [hoursPickerData objectAtIndex:row];
		}
        else
        {
			return [minutesPickerData objectAtIndex:row];
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
				return [hoursPickerDateAMMode objectAtIndex:row];
			}
            else if (component == 1)
            {
				return [minutesPickerData objectAtIndex:row];
			}
            else
            {
				return [amPMPickerData objectAtIndex:row];
			}
		}
        else
        {
            if (component == 0)
            {
				return [hoursPickerData objectAtIndex:row];
			}
            else
            {
				return [minutesPickerData objectAtIndex:row];
			}
		}
	}
    else if (pickerView == endTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
				return [hoursPickerDateAMMode objectAtIndex:row];
			}
            else if (component == 1)
            {
				return [minutesPickerData objectAtIndex:row];
			}
            else
            {
				return [amPMPickerData objectAtIndex:row];
			}
		}
        else
        {
			if (component == 0)
            {
				return [hoursPickerData objectAtIndex:row];
			}
            else
            {
				return [minutesPickerData objectAtIndex:row];
			}
		}
	}
    else if (pickerView == breakTimeSelectPicker)
    {
		if (component == 0)
        {
			return [hoursPickerData objectAtIndex:row];
		}
        else
        {
			return [minutesPickerData objectAtIndex:row];
		}
	}
    else if (pickerView == flatTimeSelectPicker)
    {
		if (component == 0)
        {
            return [hoursPickerData objectAtIndex:row];
		}
        else
        {
			return [minutesPickerData objectAtIndex:row];
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
			return [hoursPickerData count];
		}
        else
        {
			return [minutesPickerData count];
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
				return [hoursPickerDateAMMode count];
			}
            else if (component == 1)
            {
				return [minutesPickerData count];
			}
            else
            {
				return [amPMPickerData count];
			}
		}
        else
        {
			if (component == 0)
            {
				return [hoursPickerData count];
			}
            else
            {
				return [minutesPickerData count];
			}
		}
	}
    else if (pickerView == endTimeSelectPicker)
    {
		if (timeStyle == StyleAmPm)
        {
            if (component == 0)
            {
				return [hoursPickerDateAMMode count];
			}
            else if (component == 1)
            {
				return [minutesPickerData count];
			}
            else
            {
				return [amPMPickerData count];
			}
		}
        else
        {
			if (component == 0)
            {
				return [hoursPickerData count];
			}
            else
            {
				return [minutesPickerData count];
			}
		}
	}
    else if (pickerView == breakTimeSelectPicker)
    {
		if (component == 0)
        {
			return [hoursPickerData count];
		}
        else
        {
			return [minutesPickerData count];
		}
	}
    else if (pickerView == flatTimeSelectPicker)
    {
		if (component == 0)
        {
            return [hoursPickerData count];
		}
        else
        {
			return [minutesPickerData count];
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
#pragma mark Core Data Manipulation

- (void) initializeCurrentSchedule:(Schedule*)_schedule
{
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
		self.currentSchedule = (Schedule *)[NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	}
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
	sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	self.timeSheetModels = [NSMutableArray arrayWithArray:[[currentSchedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
	
    //    NSComparisonResult result = [ currentSchedule.scheduleDate compare: [ NSDate date ] ];
    
	[sortDescriptor release];
	
	[self bindEntityToView];
}


- (void) bindEntityToView
{
	[activitySelectPicker reloadAllComponents];
	
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
        
        [timeSheetView setShowTimeButtons:NO];
        
        
		[timeSheetView changeActivity:timeSheet.activity];
		[timeSheetView setDelegate:self];
		[scrollDateDetails addSubview:timeSheetView];
		[timeSheetsArray addObject:timeSheetView];
		[timeSheetView release];
		
		scrollDateDetails.contentSize = CGSizeMake((currentPage+1)*283, 137);
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
}

#pragma mark -
#pragma mark Time Sheets Manipulation Functionality

- (IBAction) forwardAction:(id)sender {
	if ((currentPage+1) < amountPage) {
		currentPage ++;
		[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
		pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
	}
}

- (IBAction) backAction:(id)sender {
	if (currentPage > 0) {
		currentPage --;
		[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
		pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
	}
}

- (IBAction) addSheetAction:(id)sender
{
	removeButton.hidden = NO;
	
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
	[timeSheetView setShowTimeButtons:NO];
    
    
	[scrollDateDetails addSubview:timeSheetView];
	[timeSheetsArray addObject:timeSheetView];
	[timeSheetView release];
    
	scrollDateDetails.contentSize = CGSizeMake((currentPage+1)*283, 137);
	[scrollDateDetails scrollRectToVisible:CGRectMake(currentPage*283, 0, 283, 137) animated:YES];
    
	pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
    
	//	$TINGTONG CODE
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
        
		for (int i=(currentPage+1); i<count; i++) {
			timeSheetView = (TimeSheetView*)[timeSheetsArray objectAtIndex:i];
			timeSheetView.frame = CGRectMake(i*283, 0, 283, 137);
		}
		
		if (currentPage<0) {
			currentPage = 0;
		}
		
		if (amountPage == 1) {
			pagingText.text = @"1/1";
		} else if (amountPage == 0){
			pagingText.text = @"0/0";
			removeButton.hidden = YES;
		} else {
			pagingText.text = [NSString stringWithFormat:@"%d/%d", (currentPage+1), amountPage];
		}
        
		//	$TINGTONG CODE
		[self saveToManagedObjectContext];
        [ self bindEntityToView ];
	}
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
		if (hours == 0 || hours == 24)
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
    
    //	if (!is24hoursMode)
    if (timeStyle == StyleAmPm)
    {
		hoursValue = [[self.hoursPickerDateAMMode objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
		if ([pickerView selectedRowInComponent:2] == 1)
        {
            //Meghan
            hoursValue += 12;
			if (hoursValue == 24)
            {
                // hoursValue = 0;
				hoursValue = 12;
			}
 		}//Added by meghan
        else if([pickerView selectedRowInComponent:2] == 0)
        {
            if (hoursValue==12)
            {
                hoursValue = 24;
            }
        }
	}
    else
    {
		hoursValue = [[self.hoursPickerData objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
	}
	
	int minutesValue = [[self.minutesPickerData objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
	//NSLog(@"Hours : %d:%d", hoursValue,minutesValue);
	return [NSNumber numberWithInt:(hoursValue*60 + minutesValue)];
}

- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView
{
    int hoursValue = 0;
    int minutesValue = 0;
    
    NSNumber *number;
    
    if(pickerView == flatTimeSelectPicker)
    {
        hoursValue = [[self.hoursPickerData objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
        minutesValue = [[self.minutesPickerData objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
        
        number = [NSNumber numberWithInt:(hoursValue*60 + minutesValue)];
    }
    else
    {
        hoursValue = [[self.hoursPickerData objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
        minutesValue = [[self.minutesPickerData objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
        
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
        
		time = [NSNumber numberWithDouble:((-1.0/60.0)*[beginningOfDay timeIntervalSinceNow])];
	}
	
	int hours = floor([time intValue]/60.0);
    
    NSInteger timeInterval = [ self safeTimeInterval ];
	int minutes = ([time intValue] - hours * 60)/timeInterval;
    
    //	if (!is24hoursMode)
    if (timeStyle == StyleAmPm)
    {
        //Meghan
        if (hours==24)
        {
			return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
		}
        else
            if (hours == 12)
            { //(hours == 0)
                return [NSArray arrayWithObjects:[NSNumber numberWithInt:11], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
            }
            else if (hours < 12)
            {
                //(hours <=12)
                return [NSArray arrayWithObjects:[NSNumber numberWithInt:(hours-1)], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:0], nil];
            }
            else
            {
                return [NSArray arrayWithObjects:[NSNumber numberWithInt:(hours-13)], [NSNumber numberWithInt:minutes], [NSNumber numberWithInt:1], nil];
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
        
        int hours = floor([period intValue]/60.0);
        
        NSInteger timeInterval = [ self safeTimeInterval ];
        int minutes = ([period intValue] - hours * 60)/timeInterval;
        
        array = [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
    }
    else
    {
        if ([period intValue]<0)
        {
            return [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
        }
        
        int hours = floor([period intValue]/60.0);
        
        NSInteger timeInterval = [ self safeTimeInterval ];
        int minutes = ([period intValue] - hours * 60)/timeInterval;
        
        array = [NSArray arrayWithObjects:[NSNumber numberWithInt:hours], [NSNumber numberWithInt:minutes], nil];
        
    }
    
    //    NSLog(@"arrayPickerSettings %@", array);
    
    return array;
}

- ( NSInteger ) safeTimeInterval
{
    NSInteger timeInterval = [ [ self.settingsDictionary objectForKey: @"timeDialInterval" ] intValue ];
    // NSLog( @"timeInterval = %d", timeInterval );
    
    if( (timeInterval != 1) && (timeInterval != 5) && (timeInterval != 15) && ( timeInterval != 3 ))
        timeInterval = 1;
    
    return timeInterval;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTextInput)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.myTemplate.templateName = textField.text;
}

- (void) hideTextInput
{
    [templateNameField resignFirstResponder];
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

- ( void ) saveAllSettings
{
    //[self bindDataToProperties];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	[self.settingsDictionary writeToFile:path atomically:YES];
}

-(void)setCheckInTimeDelegate:(id)sender
{
    
}

-(void)setCheckOutTimeDelegate:(id)sender
{
    
}


@end
