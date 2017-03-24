//
//  ActivityReportViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivityReportViewController.h"
#import "ActivityReportRowView.h"
#import "Schedule.h"
#import "TimeSheet.h"
#import "Activity.h"
#import "Localizator.h"
#import "PDFGenerator.h"
#import "PDFRenderer.h"
#import "MyOvertimeAppDelegate.h"
#import "StaticConstants.h"
#import "SVProgressHUD.h"
#import "NSDate+Midnight.h"
#import "ActivitySelectionViewController.h"
#import "GlobalFunctions.h"


@interface ActivityReportViewController(PrivateMethods)
- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate;
- (void) displayFetchedData:(NSDate*)startDate to:(NSDate*)finalDate;

- (NSString*) convertPeriodToString:(int)period;

- (NSString *)applicationDocumentsDirectory;
- (void)launchMailAppOnDevice;
- (NSString*)formCVSContent;


@end

@implementation ActivityReportViewController

@synthesize visiblePopTipViews;
@synthesize currentPopTipViewTarget;

@synthesize multiFiler;
@synthesize selectedActivities;
@synthesize totalAmountString;
@synthesize headerCell;
@synthesize footerCell;
@synthesize labelFrom;
@synthesize labelTo;
@synthesize rangeLabelFrom;
@synthesize rangeLabelTo;
@synthesize rangeLabel;
@synthesize rangeStartLabel;
@synthesize rangeEndLabel;
@synthesize activityReportCell;
@synthesize scrollView, headerScrollView;
@synthesize managedObjectContext;
@synthesize reportData;
@synthesize reportRowViews;
@synthesize beginDate,endDate;
@synthesize userName,companyName;
@synthesize filter;
@synthesize filterActivity;
@synthesize filteredReportData;
@synthesize filterHead;
@synthesize labelTotal;
@synthesize totalString;
@synthesize filterTotalAmount;
@synthesize labelDummy1,labelDummy2,labelDummy3, labelAmount;
@synthesize footerHoursLabel, footerOffsetLabel, footerBalanceLabel;
#pragma mark -
#pragma mark View lifecycle



-(void) makeToolBarButtons
{
    // Add profile button.
    UIImage *buttonImageBig = [UIImage imageNamed:@"ButtonBlack.png"];
    UIImage *buttonImageBig2 = [UIImage imageNamed:@"ButtonBlackHighlighted.png"];
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:buttonImageBig forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageBig2 forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    [button setTitle:NSLocalizedString(@"EMAIL_BUTTON", @"") forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted=YES;
	button.frame = CGRectMake(0.0, 0.0, 50, 30);	
	UIBarButtonItem *systemItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button addTarget:self action:@selector(emailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = systemItem;
    [systemItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filterHead.text=NSLocalizedString(@"TITLE_FILTER",nil);

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.title = NSLocalizedString(@"ACTIVITY_REPORT_TITLE", @"");
	
	self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
	
	scrollView.backgroundColor = [UIColor clearColor];
	headerScrollView.contentSize = CGSizeMake(1020, 27);
    
//    CGRect frame=scrollView.frame;
//    frame.size.height=160;
//    scrollView.frame=frame;
    [self makeToolBarButtons];
    
    footerCell.backgroundColor = [UIColor clearColor];
    footerCell.backgroundView = nil;
    footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    amountTotal = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];		
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
    is24HourMode = [[settingsDictionary objectForKey:@"is24hoursMode"] boolValue];
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	myImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
	self.tableView.backgroundView = myImageView;
	[myImageView release];
    
    //Added by Meghan
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];

    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter dateFromString:beginDate]];
	[comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
    // //NSLog(@"Known Timezones : %@",[NSTimeZone timeZoneWithName:@"GMT-1000"]);
    
	NSDate *sDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                               fromDate:[dateFormatter dateFromString:endDate]];
	[comps1 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
	NSDate *eDate = [[NSCalendar currentCalendar] dateFromComponents:comps1];
    
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if ([[dateFormatter stringFromDate:sDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
    if(!stylePerformed)
    {
        rangeLabelFrom.text = [dateFormatter stringFromDate: sDate];
        rangeLabelTo.text = [dateFormatter stringFromDate: eDate];
        
        rangeLabelTo.minimumFontSize =
        rangeLabelFrom.minimumFontSize = 8.0;
        rangeLabelFrom.adjustsFontSizeToFitWidth = YES;
        rangeLabelTo.adjustsFontSizeToFitWidth = YES;
        
        labelDummy1.minimumFontSize = 8.0;
        labelDummy1.adjustsFontSizeToFitWidth = YES;
        
        CGRect headerFrame = headerScrollView.frame;
        headerFrame.origin.y -= 10.0f;
        headerScrollView.frame = headerFrame;
        
        if([filter isEqualToString:kMultiSelectString])
        {
            filterActivity.text= self.multiFiler;
        }
        else
        {
            filterActivity.text=(filter)?filter:@"";
        }
        
//        filterActivity.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame=filterActivity.frame;
        CGSize maximumLabelSize = CGSizeMake(200,100);
        CGSize expectedLabelSize = [filter sizeWithFont:filterActivity.font   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap];
        frame.size.height=expectedLabelSize.height;
        frame.size.width=50;
        filterActivity.frame=frame;
        filterActivity.numberOfLines=0;
        filterActivity.lineBreakMode = UILineBreakModeTailTruncation;
        
        //[self fetchReportDataFrom:nil to:nil];
        
        labelDummy3.frame = CGRectMake(labelDummy3.frame.origin.x, labelDummy3.frame.origin.y, 80, labelDummy3.frame.size.height);
        
        
        if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)])
        {
            isFilterResult=YES;
            labelDummy1.hidden=YES;
            labelDummy2.hidden=YES;
            frame=labelAmount.frame;
            frame.origin.x=labelDummy1.frame.origin.x;
            labelAmount.frame=frame;
            frame=labelDummy3.frame;
            frame.origin.x=labelDummy2.frame.origin.x + 30;
            labelDummy3.frame=frame;
            
            self.labelTotal=[[UILabel alloc]init];
            labelTotal.backgroundColor=[UIColor clearColor];
            labelTotal.frame=CGRectMake(10,30,300,20);
            labelTotal.text=self.totalString;
            labelTotal.font=[UIFont systemFontOfSize:12];
            filterHead.font=[UIFont systemFontOfSize:12];
            filterActivity.font=[UIFont systemFontOfSize:12];
            filterHead.textColor=filterActivity.textColor;
            filterHead.text= NSLocalizedString(@"FILTER_HEADER", nil);
            labelTotal.textColor=filterActivity.textColor;
            [headerCell.contentView addSubview:labelTotal];
            CGRect frame=  filterHead.frame;
            frame.origin.x=10;
            frame.origin.y=50;
            frame.size.height=16;
            filterHead.frame=frame;
            frame=filterActivity.frame;
            expectedLabelSize= [filterHead.text sizeWithFont:filterHead.font   constrainedToSize:maximumLabelSize   lineBreakMode:UILineBreakModeWordWrap];
            frame.size.height=expectedLabelSize.height;
            frame.origin.y=50;
            frame.origin.x=expectedLabelSize.width+filterHead.frame.origin.x+5;
//            frame.size.width=200;
            frame.size.width=300;
            frame.size.height=16;
            filterActivity.frame=frame;
            
            frame=activityReportCell.frame;
            frame.origin.y-=20;
            frame.size.height+=20;
            activityReportCell.frame=frame;
            
            for (id label in headerCell.contentView.subviews)
            {
                if ([label isKindOfClass:[UILabel class]])
                {
                    UILabel *view=label;
                    if (view.tag==100)
                    {
                        view.hidden=YES;
                    }
                }
            }
        }
        else
        {
            filterHead.hidden=YES;
            filterActivity.hidden=YES;
            filterTotalAmount.hidden = YES;
        }
        
        [self fetchReportDataFrom:[sDate midnightUTC] to:[eDate dateByAddingTimeInterval:0]];
        labelTotal.text=self.totalString;
        
        if(isFilterResult && amountTotal > 0)
        {
            CGRect frame=  self.labelTotal.frame;
            frame.origin.y -= 5;
            self.labelTotal.frame = frame;
            
            frame=  filterTotalAmount.frame;
            frame.origin.x = 10;
            frame.origin.y = self.labelTotal.frame.origin.y + self.labelTotal.frame.size.height;
            frame.size.width = 300;
            frame.size.height = 16;
            filterTotalAmount.frame = frame;
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            NSNumber *tmp = [[NSNumber alloc] initWithFloat:amountTotal];
            
            NSString *amStr = [numberFormatter stringFromNumber:tmp];
            //        NSString *str = [NSString stringWithFormat:@"Total amount is: %0.2f", amountTotal];
            NSString *str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TOTAL_AMOUNT_HEADER", nil), amStr];
            
            filterTotalAmount.text = str;
            filterTotalAmount.backgroundColor = [UIColor clearColor];
            filterTotalAmount.font = [UIFont systemFontOfSize:12];
            filterTotalAmount.textColor = filterActivity.textColor;
            
            frame=filterHead.frame;
            frame.origin.y = filterTotalAmount.frame.origin.y + filterTotalAmount.frame.size.height;
            filterHead.frame = frame;
            
            frame=filterActivity.frame;
            frame.origin.y = filterTotalAmount.frame.origin.y + filterTotalAmount.frame.size.height;
        }
        else
        {
            filterTotalAmount.hidden = YES;
        }
        
        if(USER_INTERFACE_IPHONE5())
        {
            frame = headerScrollView.frame;
            frame.size.width = 425;
            headerScrollView.frame = frame;
            
            frame = scrollView.frame;
            frame.size.width = 425;
            scrollView.frame = frame;
        }
        
        if(!USER_INTERFACE_IPHONE5())
        {
            CGRect labelFrame = filterActivity.frame;
            labelFrame.size.width = filterActivity.frame.size.width - 30;
            filterActivity.frame = labelFrame;
        }
        
        if([filter isEqualToString:kMultiSelectString])
        {
            filterButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            filterButton.frame = CGRectMake(filterActivity.frame.origin.x + filterActivity.frame.size.width + 7, filterActivity.frame.origin.y - 5, 25, 25);
            [headerCell addSubview:filterButton];
        }
        
        stylePerformed = YES;
    }
}

-(void)filterButtonPressed:(id)sender
{
    [self dismissAllPopTipViews];
	
	if (sender == currentPopTipViewTarget)
    {
		// Dismiss the popTipView and that is all
		self.currentPopTipViewTarget = nil;
	}
	else
    {
		
		CMPopTipView *popTipView  = [[[CMPopTipView alloc] initWithMessage:self.multiFiler] autorelease];
		popTipView.delegate = self;
		//popTipView.disableTapToDismiss = YES;
		//popTipView.preferredPointDirection = PointDirectionUp;
        
//        popTipView.backgroundColor = [UIColor clearColor];
        popTipView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        popTipView.textColor = [UIColor blackColor];
        
        popTipView.animation = CMPopTipAnimationSlide;
		popTipView.has3DStyle = (BOOL)(arc4random() % 2);
		
		popTipView.dismissTapAnywhere = YES;
        [popTipView presentPointingAtView:filterActivity inView:self.tableView animated:YES];
		
		[visiblePopTipViews addObject:popTipView];
		self.currentPopTipViewTarget = sender;
	}
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
    if (indexPath.row==0)
    {
        return headerCell;
    }else
    {
        return activityReportCell;
    }
}



#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0 && isFilterResult==NO)
    {
        return 110.0;
    }
    if (indexPath.row==0 && isFilterResult==YES)
    {
        return 80.0;
    }
    if(indexPath.row == 1 && isFilterResult)
    {
        return 215.0;
    }
    return 185.0;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

#pragma mark -
#pragma mark Report Data Managemnent

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)sDate andDate:(NSDate*)eDate
{
    if ([date compare:sDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:eDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}

- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate <= %@ && scheduleDate > %@ ",finalDate,startDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate <= %@",finalDate];

	[request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:NO];
    

	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (mutableFetchResults == nil)
    {
		// Handle the error.
        self.filteredReportData=nil;
        
	}
    else
    {   
        NSArray *temp = [[NSArray alloc] initWithArray:mutableFetchResults];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for(int i=0; i<temp.count; i++)
        {
            Schedule *schedule = [temp objectAtIndex:i];
            
            if(schedule.settingsDayTemplate == nil && schedule.myTemplate == nil)
            {
                NSEnumerator *enumerator = [schedule.timeSheets objectEnumerator];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                TimeSheet *item;
                while (item = [enumerator nextObject])
                {
                    [items addObject:item];
                }
                if(items.count > 0)
                {
                    [array addObject:schedule];
                }
            }
        }
        
        self.reportData = [NSArray arrayWithArray:array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate <= %@ && scheduleDate > %@ ",finalDate,startDate];
        
        self.filteredReportData = [self.reportData filteredArrayUsingPredicate:predicate];
        
        [temp release];
        [array release];
	}
	[request release];
	
	[self displayFetchedData:startDate to:finalDate];
}
/*
-(void) localizedCompare:(id) dummy{
    NSLog(@"localizedCompareaa");
}*/

- (void) displayFetchedData:(NSDate*)startDate to:(NSDate*)finalDate
{
	for (ActivityReportRowView *curRowView in reportRowViews)
    {
		[curRowView removeFromSuperview];
	}
//	scrollView.backgroundColor = [UIColor lightGrayColor];
    
    if(isFilterResult)
    {
        CGRect frame = scrollView.frame;
        frame.size.height += 30;
        scrollView.frame = frame;
    }
	scrollView.contentSize = CGSizeMake(457, 100);
	self.reportRowViews = [[NSMutableArray alloc] initWithCapacity:0];
	
	int rowShift = 0;
	int commentLength = 0;
    int balance = 0;
    int balanceInRange = 0;
    int amountLength = 0;
    CGFloat totalAmount = 0.0f;
    totalFilteredResult=0;
    
    int totalFullHours = 0;
    int totalFullOffset = 0;
    int totalFullBalance = 0;
    
	for (Schedule *schedule in reportData)
    {
        BOOL inRange = NO;
        if ([self date:schedule.scheduleDate isBetweenDate:startDate andDate:finalDate])
        {
            inRange = YES;
        }
        else
        {
            inRange = NO;
        }
        int offSet = 0;
        int offSetInRange = 0;
        BOOL flagOffset = YES;
        
        BOOL newSchedule = YES;
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
		
		NSArray *timeSheets = [NSArray arrayWithArray:[[schedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
		
		[sortDescriptor release];
		[sortDescriptors release];		
		
		BOOL totalRowNeeded = NO;
		int total = 0;
        int totalRange = 0;
        
		for (TimeSheet *timeSheet in timeSheets)
        {   
            NSLog(@"filter %@", filter);
            if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)] && [filter isEqualToString:kMultiSelectString])
            {
                BOOL valid = NO;
                for(ActivityModified *mod in self.selectedActivities)
                {
                    if([timeSheet.activity.activityTitle isEqualToString:mod.activity.activityTitle])
                    {
                        valid = YES;
                    }
                    else
                    {
                        
                    }
                }
                
                if(!valid) continue;
            }
            else if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)]&& ![timeSheet.activity.activityTitle isEqualToString:filter])
            {
                         continue;
            }

			if (!timeSheet.activity)
            {
				continue;
			}
			if (inRange)
            {
                if ([timeSheet.comments length]>commentLength)
                {
                    commentLength = [timeSheet.comments length];
                }
            }
			if ([timeSheet.activity.estimateMode boolValue])
            {
                if (inRange)
                {
                    if ([timeSheet.activity.flatMode boolValue])
                    {
                        if(timeSheet.activity.overtimeReduce.boolValue)
                        {
                            totalRange -= [timeSheet.flatTime intValue];
                            totalFullHours -= [timeSheet.flatTime intValue];
                        }
                        else
                        {
                            totalRange += [timeSheet.flatTime intValue];
                            totalFullHours += [timeSheet.flatTime intValue];
                        }
                        
                        if(timeSheet.activity.showAmount.boolValue)
                        {
                            NSString *amountSize = [NSString stringWithFormat:@"%0.2f", timeSheet.amount.floatValue];
                            
                            if ([amountSize length] > amountLength)
                            {
                                amountLength = [amountSize length];
                            }
                        }
                    }
                    else
                    {
                        if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                        {
                            totalRange += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                            totalFullHours += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                        }
                        else
                        {
                            totalRange += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                            totalFullHours += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }
                        if ([timeSheet.breakTime intValue]>0)
                        {
                            totalRange -= [timeSheet.breakTime intValue];
                            totalFullHours -= [timeSheet.breakTime intValue];
                        }	
                    }
                }
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
                    
                    if(timeSheet.activity.showAmount.boolValue)
                    {
                        totalAmount += timeSheet.amount.floatValue;
                        amountTotal = totalAmount;
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
			if (flagOffset)
            {
                if (inRange)
                {
                    offSetInRange = [schedule.offset intValue];
                    totalFullOffset += [schedule.offset intValue];
                }
                offSet = [schedule.offset intValue];
                flagOffset = NO;
            }
            if (inRange)
            {
                ActivityReportRowView *rowView = [[ActivityReportRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
                
                if(isFilterResult)
                    rowView.isFiltered=YES;
                if (!newSchedule)
                {
                    rowView.currentOffset = schedule.offset;
                    [rowView setis24HourMode:is24HourMode];
                    [rowView bindTimeSheetToView:timeSheet];
                    totalFilteredResult+=rowView.totalValue+rowView.totalValue2;

                    totalRowNeeded = YES;
                }
                else
                {
                    if ([timeSheets count]==1)
                    {
                        rowView.isHeader = YES;
                    }	
                    
                    [rowView setis24HourMode:is24HourMode];
                    [rowView bindDataToView:schedule withTimeSheet:timeSheet];
                    totalFilteredResult+=rowView.totalValue+rowView.totalValue2;
                    newSchedule = NO;
                }
                
                [scrollView addSubview:rowView];
                [reportRowViews addObject:rowView];
                rowShift += 30;
                
                [rowView release];
            }			
		}
        if (inRange)
        {
            if (totalRowNeeded)
            {
                ActivityReportRowView *totalRowView = [[ActivityReportRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
                
                [totalRowView bindTotalToView:schedule withTotal:total andAmount:totalAmount];
                totalRowView.isFiltered=isFilterResult;
                [scrollView addSubview:totalRowView];

                [reportRowViews addObject:totalRowView];
                rowShift += 30;
                
                [totalRowView release];
            }
        }
		
		balance += total-offSet;
        if (inRange)
        {
            balanceInRange += totalRange-offSetInRange;
        }
	}
    
    totalFullBalance = totalFullHours - totalFullOffset;
    
	rangeLabel.text = [self convertPeriodToString:balanceInRange];
    rangeStartLabel.text = [self convertPeriodToString:balance-balanceInRange];
    rangeEndLabel.text = [self convertPeriodToString:balance];
    NSString *stringTotal=[self convertPeriodToString:totalFilteredResult];
    self.totalString=[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"TOTAL_ACTIVITY_RESULT", nil),stringTotal];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    NSNumber *tmp = [[NSNumber alloc] initWithFloat:amountTotal];
    
    self.totalAmountString = [numberFormatter stringFromNumber:tmp];
    
    ActivityReportRowView *footerRowView = [[ActivityReportRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
    
    footerRowView.isFiltered=isFilterResult;
    
    [footerRowView bindFooterToViewwithHours:totalFullHours withOffset:totalFullOffset withBalance:rangeLabel.text withAmount:amountTotal];
    [scrollView addSubview:footerRowView];
    
    [reportRowViews addObject:footerRowView];
    rowShift += 30;
    
    [footerRowView release];
    
    if (commentLength > 10 || amountLength > 10)
    {
        scrollView.contentSize = CGSizeMake(535 +(amountLength * 5.5 + commentLength * 6.5), rowShift);
    }
    else
    {
        scrollView.contentSize = CGSizeMake(585, rowShift);
    }
    
    footerHoursLabel.text = [self convertPeriodToString:totalFullHours];
    footerOffsetLabel.text = [self convertPeriodToString:totalFullOffset];
    footerBalanceLabel.text = rangeLabel.text;
}

- (NSString*) convertTimeToString:(NSNumber*)time
{
	if ([time intValue]==-1)
    {
		return @"";
	}
	
	int hours = ([time intValue]/60.0);
	int minutes = [time intValue] - hours * 60;
	
	NSString *amPM = @"";
    
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
//	if (!is24HourMode && !setTimeForFlatHours)
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
	
    if(timeStyle != StyleDecimal)
    {
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
    else
    {
        CGFloat floatHours = hours;
        CGFloat floatMinutes = minutes;
        
        CGFloat decimalHours = floatHours + (floatMinutes/60);
        
//        NSLog(@"decimal hours %0.2f", decimalHours);
        
        return [NSString stringWithFormat:@"%0.2f", decimalHours];
/*
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
 */
    }
}

- (NSString*) convertPeriodToString:(int)period
{
    BOOL addMinus = period < 0;
    int absPeriod = abs(period);
    
	int hours = (absPeriod/60.0);
	int minutes = absPeriod - hours * 60;
    
    CGFloat floatHours = hours;
    CGFloat floatMinutes = minutes;
    
    CGFloat decimalHours = floatHours + (floatMinutes/60);
    
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
    if(timeStyle != StyleDecimal)
    {
        if (minutes < 10)
        {
            return [NSString stringWithFormat:@"%@%d:0%d", ( addMinus ? @"-" : @"" ), hours, minutes];
        }
        else
        {
            return [NSString stringWithFormat:@"%@%d:%d", ( addMinus ? @"-" : @"" ), hours, minutes];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@%0.2f", ( addMinus ? @"-" : @"" ), decimalHours];
    }
}	

#pragma mark -
#pragma mark Export to xls

- (IBAction) emailAction:(id)sender
{	
#ifdef INAPP_VERSION	
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (!app.isProduct2Purchased)
    {
        [app showEmailAlert];
        return;
    }
#endif

	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if (![mailClass canSendMail])
        {
			[self launchMailAppOnDevice];
		}
	}
    else
    {
		[self launchMailAppOnDevice];
	}	
	
    [self showWithStatus:NSLocalizedString(@"PREPARING_MAIL", @"")];

	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_SUBJECT", @"")];
	
    NSArray *toRecipients = [NSArray arrayWithObjects:[GlobalFunctions getDefaultEmail], nil];
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
    // rykosoft: March fix, bug 2: changed allowLossyConversion: from YES to NO
	NSString *csvContent = [self formCVSContent];

    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;
    
    NSData * myData = nil;
    NSString * htmlContent = [self formHTMLContent ];
    NSString * pdfHeader = [self formPDFContentHeader];
    NSArray * pdfData = [self formPDFContent];
    NSString* fileName = [self getPDFFileName];  

    [self deleteTemporaryPdf];
    [PDFRenderer drawPDF:fileName forArray:pdfData andHeaderText:pdfHeader andAdjust:NO orientation:PageOrientation_Landscape];
    
    //PDF
    myData = [NSData dataWithContentsOfFile:[self getPDFFileName]];
    
    if( myData )
        [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_ATTACHMENT_4", @"")];
    
    if( isIOS5 )
    {
        myData = [ Localizator encodedDataFromString: csvContent withEncoding: NSUTF8StringEncoding];
        if( myData )
        {
            [picker addAttachmentData:myData
                             mimeType:@"text/csv"
                             fileName:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_ATTACHMENT_0", @"")];
        }

        myData = [ Localizator encodedDataFromString: htmlContent withEncoding: NSUTF8StringEncoding];
        if( myData )
        {
            [picker addAttachmentData:myData
                             mimeType:@"text/html"
                             fileName:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_ATTACHMENT_3", @"")];
        }
    }
    else 
    {
        myData = [ Localizator encodedDataFromString: csvContent
                                        withEncoding: NSUTF8StringEncoding];
        if( myData )
        {
            [picker addAttachmentData:myData
                             mimeType:@"text/csv"
                             fileName:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_ATTACHMENT_0", @"")];
        }

        myData = [ Localizator encodedDataFromString: htmlContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
        {
            [picker addAttachmentData:myData
                             mimeType:@"text/html"
                             fileName:NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_ATTACHMENT_3", @"")];
        }
    }
   
    // Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"ACTIVITY_REPORT_EMAIL_CONTENT", @"");
	[picker setMessageBody:emailBody isHTML:NO];
    picker.navigationBar.tintColor=[UIColor blackColor];

	[self presentModalViewController:picker animated:YES];
    [self dismiss];
    [picker release];
}	

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	 
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)launchMailAppOnDevice {
	NSString *recipients = @"mailto:?subject=Test Message";
	NSString *body = @"&body=Test message content";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (NSString*)formCVSContent
{
	NSString *cvsString = @"";
    
    cvsString = 
        [cvsString stringByAppendingString:
            [NSString stringWithFormat:
                @"%@ : %@ %@ %@ %@\n",
                NSLocalizedString(@"REPORT_MYDATERANGE", @""),
                labelFrom.text,
                rangeLabelFrom.text,
                labelTo.text,
                rangeLabelTo.text]
         ];

    if (isFilterResult==NO)
    {    
        cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
        cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),rangeStartLabel.text]];
        cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),rangeEndLabel.text]];
    }
    else
    {
        NSString *string=[NSString stringWithFormat:@"%@",self.totalString];
        cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@\n",string]];
        cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"TOTAL_AMOUNT_HEADER", nil),self.totalAmountString]];
        if([filter isEqualToString:kMultiSelectString])
        {
            NSString *convertedStr = [self.multiFiler stringByReplacingOccurrencesOfString:@"," withString:@";"];
            NSString *filterStr = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"FILTER_HEADER", nil),convertedStr];
            cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@\n", filterStr]];
        }
        else
        {
            cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"FILTER_HEADER", nil),filter]];
        }
    }
	NSString *cvsRow = nil;
    if (isFilterResult)
    {
        cvsRow=[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_MONTH", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""),
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL_MIN", @"")];
    }
    else
    cvsRow=[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_MONTH", @""), 
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""), 
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_OFFSET", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BALANCE", @""),
                        NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL_MIN", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_OFFSET_MIN", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BALANCE_MIN", @"")];
	
	cvsString = [cvsString stringByAppendingString:cvsRow];
	for (Schedule *schedule in filteredReportData)
    {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
		
		NSArray *timeSheets = [NSArray arrayWithArray:[[schedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
		
		[sortDescriptor release];
		[sortDescriptors release];		
		
		BOOL hasTotalRow = NO;
		int total = 0;
		int generalTotal = 0;
        CGFloat totalAmount = 0.0f;
		for (TimeSheet *timeSheet in timeSheets)
        {
			if (!timeSheet.activity)
            {
				continue;
			}
            
            if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)] && [filter isEqualToString:kMultiSelectString])
            {
                BOOL valid = NO;
                for(ActivityModified *mod in self.selectedActivities)
                {
                    if([timeSheet.activity.activityTitle isEqualToString:mod.activity.activityTitle])
                    {
                        valid = YES;
                    }
                    else
                    {
                        
                    }
                }
                
                if(!valid) continue;
            }
            else if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)]&& ![timeSheet.activity.activityTitle isEqualToString:filter])
            {
                continue;
            }
            
//            if (isFilterResult &&! [timeSheet.activity.activityTitle isEqualToString:filter])
//            {
//                continue;
//            }

			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"MMM YYYY"];
            [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
			NSString *month = ([dateFormatter stringFromDate:schedule.scheduleDate]);	
			[dateFormatter release];
			
			dateFormatter = [[NSDateFormatter alloc] init];
			//[dateFormatter setLocale:[NSLocale currentLocale]];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
			NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];	
			[dateFormatter release];
			
			
			if ([timeSheet.activity.flatMode boolValue])
            {
                setTimeForFlatHours = YES;
				if ([timeSheet.flatTime intValue]<0)
                {
                    /*
					NSString *cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n", month, scheduleDate, timeSheet.activity.activityTitle, [self convertPeriodToString:total], total];
					cvsString = [cvsString stringByAppendingString:cvsRow];
					continue;
                    */
				}			
			}
            else
            {
                setTimeForFlatHours = NO;
                
				if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
                {
					NSString *cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n", month, scheduleDate, timeSheet.activity.activityTitle, [self convertPeriodToString:total], total];
					cvsString = [cvsString stringByAppendingString:cvsRow];					
					continue;
				}
			}						
			
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
                    
                    if(timeSheet.activity.showAmount.boolValue)
                    {
                        totalAmount += timeSheet.amount.floatValue;
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
			
			if ([timeSheets count]==1)
            {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [numberFormatter setLocale:[NSLocale currentLocale]];
                NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                
                NSString *str = [numberFormatter stringFromNumber:tmp];
                
				if ([timeSheet.activity.flatMode boolValue])
                {
                    
                    if (isFilterResult==NO)
                    {
                        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n",
                                  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
                                  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                                  [self convertPeriodToString:total], [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(total - [schedule.offset intValue])], timeSheet.activity.showAmount.boolValue ? str : @"",
                                  timeSheet.comments ? timeSheet.comments : @"",
                                  total, [schedule.offset intValue], (total - [schedule.offset intValue])];
                    }
                    else
                    {
                        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n",
                                  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""), 
                                  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                                  [self convertPeriodToString:total], timeSheet.activity.showAmount.boolValue ? str : @"",
                                  timeSheet.comments ? timeSheet.comments : @"",
                                  total];
                    }
				}
                else
                {
                    if (isFilterResult)
                    {
                        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n",
                                  month, scheduleDate, timeSheet.activity.activityTitle,
                                  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
                                  [self convertPeriodToString:total],@"",
                                  timeSheet.comments ? timeSheet.comments : @"",                               total];
                    }
                    else
					cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n",
							  month, scheduleDate, timeSheet.activity.activityTitle, 
							  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
							  [self convertPeriodToString:total], [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(total - [schedule.offset intValue])], @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, [schedule.offset intValue], (total - [schedule.offset intValue])];
				}
                
				hasTotalRow = NO;
                
			}
            else
            {
				if ([timeSheet.activity.flatMode boolValue])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                    
                    NSString *str = [numberFormatter stringFromNumber:tmp];
                    
                    if (isFilterResult)
                    {
                    cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n",
                                  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
                                  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                                  [self convertPeriodToString:total],timeSheet.activity.showAmount.boolValue ? str : @"",
                                  timeSheet.comments ? timeSheet.comments : @"",
                                  total];
                    }
                    else
					cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n",
							  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
							  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
							  [self convertPeriodToString:total], @"", @"", timeSheet.activity.showAmount.boolValue ? str : @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, 0, 0];
				}
                else
                {
                    if (isFilterResult)
                    {
                        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n",
                                  month, scheduleDate, timeSheet.activity.activityTitle,
                                  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
                                  [self convertPeriodToString:total],@"",
                                  timeSheet.comments ? timeSheet.comments : @"",                                  total];
                    }
                    else
					cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n",
							  month, scheduleDate, timeSheet.activity.activityTitle, 
							  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
							  [self convertPeriodToString:total], @"", @"", @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, 0, 0];					
				}	
				hasTotalRow = YES;
			}
            //Meghan
          //  //NSLog(@"CSV ROW : %@",cvsRow);
			cvsString = [cvsString stringByAppendingString:cvsRow];
			generalTotal += total;
			total = 0;
		}
		
		if (hasTotalRow)
        {
            NSNumber * number = [NSNumber numberWithFloat:totalAmount];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            
            NSString *str = [numberFormatter stringFromNumber:number];
            
            if (isFilterResult)
            {
               	cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\"\n",
                          NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @""), @"", @"",
                          @"", @"", @"",
                          [self convertPeriodToString:generalTotal],
                          str,
                          @"",
                          generalTotal];
            }
            else
			cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n",
					  NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @""), @"", @"",
					  @"", @"", @"",
					  [self convertPeriodToString:generalTotal], [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(generalTotal - [schedule.offset intValue])],str,
					  @"",
					  generalTotal, [schedule.offset intValue], (generalTotal - [schedule.offset intValue])];
            //Meghan
           // //NSLog(@"CSV ROW 2: %@",cvsRow);
			cvsString = [cvsString stringByAppendingString:cvsRow];
            
		}
		
	}
    
    NSString *footerRow;
    if (isFilterResult)
    {
        footerRow = [NSString stringWithFormat:@"\"%@:\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                @"",
                @"",
                @"",
                @"",
                @"",
                footerHoursLabel.text,
                @"",
                @"",
                @""];
    }
    else
        footerRow = [NSString stringWithFormat:@"\"%@:\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
                NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                @"",
                @"",
                @"",
                @"",
                @"",
                footerHoursLabel.text,
                footerOffsetLabel.text,
                footerBalanceLabel.text,
                @"",
                @"",
                @"",
                @"",
                @""];
	
	cvsString = [cvsString stringByAppendingString:footerRow];

    
	return cvsString;						
}	



#pragma mark -
#pragma mark PcasoPDFModules

-(NSString*)getPDFFileName
{
    NSString* fileName = @"Temporary.PDF";
    
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSCachesDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}

//Deletes temporaray pdf file
-(void) deleteTemporaryPdf{
    
    //Delete all relevant files from the system
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Delete existing pdf 
    NSString *theFileId=[NSString stringWithFormat:@"Temporary"];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",theFileId]];
    [fileManager removeItemAtPath:imagePath error:NULL];
    
}

- (NSString*)formPDFContentHeader 
{
    // BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;
    NSString * pdfString =
     [NSString stringWithFormat:@"%@     %@\n%@ : %@ %@ %@ %@\n",userName,companyName,NSLocalizedString(@"REPORT_MYDATERANGE", @""),
      labelFrom.text,
      rangeLabelFrom.text,
      labelTo.text,
      rangeLabelTo.text      ];
    
    if (isFilterResult)
    {
        NSString *string=[NSString stringWithFormat:@"%@",self.totalString];
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@\n",string]];
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"TOTAL_AMOUNT_HEADER", nil),self.totalAmountString]];
        if([filter isEqualToString:kMultiSelectString])
        {
            pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"FILTER_HEADER", nil),self.multiFiler]];
        }
        else
        {
            pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",NSLocalizedString(@"FILTER_HEADER", nil),filter]];
        }
    }
    else
    {
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),rangeStartLabel.text]];
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),rangeEndLabel.text]];
    }
    return pdfString;
    
    
}
- (NSArray*)formPDFContent 
{
    NSMutableArray* headers =nil;
    
    if (isFilterResult==NO)
    {
        headers=[NSArray arrayWithObjects:
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_OFFSET", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BALANCE", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""), nil];
    }
    else
        
        headers=[NSArray arrayWithObjects:
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""),nil];
    
    
	NSMutableArray *array=[[[NSMutableArray alloc]initWithCapacity:1000] autorelease];
    [array addObject:headers];
    
	for (Schedule *schedule in filteredReportData)
    {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
		
		NSArray *timeSheets = [NSArray arrayWithArray:[[schedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
		
		[sortDescriptor release];
		[sortDescriptors release];		
		
		BOOL hasTotalRow = NO;
		int total = 0;
		int generalTotal = 0;
        CGFloat totalAmount = 0.0f;
		for (TimeSheet *timeSheet in timeSheets)
        {
			if (!timeSheet.activity)
            {
				continue;
			}
            if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)] && [filter isEqualToString:kMultiSelectString])
            {
                BOOL valid = NO;
                for(ActivityModified *mod in self.selectedActivities)
                {
                    if([timeSheet.activity.activityTitle isEqualToString:mod.activity.activityTitle])
                    {
                        valid = YES;
                    }
                    else
                    {
                        
                    }
                }
                
                if(!valid) continue;
            }
            else if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)]&& ![timeSheet.activity.activityTitle isEqualToString:filter])
            {
                continue;
            }

			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			dateFormatter.dateFormat = @"EEE, dd MMM";
//			[dateFormatter setDateStyle:NSDateFormatterLongStyle];
            
            NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
            
            if ([string isEqualToString:@"en_GB"])
            {
                [dateFormatter setDateFormat:@"EEE, dd MMM"];
            }
            else if ([string isEqualToString:@"en_US"])
            {
                [dateFormatter setDateFormat:@"EEE, MMM dd"];
            }
            else if ([string isEqualToString:@"sv_SE"])
            {
                [dateFormatter setDateFormat:@"EEE, dd MMM"];
            }
            else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"])
            {
                [dateFormatter setDateFormat:@"EEE, dd MMM"];
            }
            
			NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];	
			[dateFormatter release];
			
			
			if ([timeSheet.activity.flatMode boolValue])
            {
                setTimeForFlatHours = YES;
			}
            else
            {
                setTimeForFlatHours = NO;
				if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
                {
                NSArray* item = [NSArray arrayWithObjects:
                                     scheduleDate,
                                     timeSheet.activity.activityTitle,
                                    [self convertPeriodToString:total],
                                 nil];
                    
                    [array addObject:item];		
                    continue;
				}
			}						
			
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

                    if(timeSheet.activity.showAmount.boolValue)
                    {
                        totalAmount += timeSheet.amount.floatValue;
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
			
			if ([timeSheets count]==1)
            {
				if ([timeSheet.activity.flatMode boolValue])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                    
                    NSString *str = [numberFormatter stringFromNumber:tmp];
                    
                    if(isFilterResult)
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @"")],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:timeSheet.flatTime.intValue]],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@"%@", timeSheet.activity.showAmount.boolValue ? str : @""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];
                    }
                    else
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @"")],
                                         [NSString stringWithFormat:@"%@", [self convertPeriodToString:timeSheet.flatTime.intValue]],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@", [self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:[schedule.offset intValue]]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:(total - [schedule.offset intValue])]],
                                         [NSString stringWithFormat:@"%@", timeSheet.activity.showAmount.boolValue ? str : @""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];
                    }
				}
                else
                {
                    if (isFilterResult)
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.startTime]],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.endTime]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:[timeSheet.breakTime intValue]]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];	

                    }
                    else
                    {
                    NSArray* item = [NSArray arrayWithObjects:
                                     [NSString stringWithFormat:@"%@",scheduleDate],
                                     [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                     [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.startTime]],
                                     [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.endTime]],
                                     [NSString stringWithFormat:@"%@",[self convertPeriodToString:[timeSheet.breakTime intValue]]],
                                     [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                                     [NSString stringWithFormat:@"%@",[self convertPeriodToString:[schedule.offset intValue]]],
                                     [NSString stringWithFormat:@"%@",[self convertPeriodToString:(total - [schedule.offset intValue])]],
                                     [NSString stringWithFormat:@""],
                                     [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                    [array addObject:item];	
                    }

                    
				}
				hasTotalRow = NO;
			}
            else
            {
				if ([timeSheet.activity.flatMode boolValue])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                    
                    NSString *str = [numberFormatter stringFromNumber:tmp];
                    
                    if (isFilterResult)
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @"")],
                                         [NSString stringWithFormat:@"%@", [self convertPeriodToString:timeSheet.flatTime.intValue]],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@", [self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.showAmount.boolValue ? str : @""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];
                    }
                    else
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                     [NSString stringWithFormat:@"%@",scheduleDate],
                                     [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @"")],
                                     [NSString stringWithFormat:@"%@", [self convertPeriodToString:timeSheet.flatTime.intValue]],
                                     [NSString stringWithFormat:@"%@",@""],
                                     [NSString stringWithFormat:@"%@", [self convertPeriodToString:total]],
                                     [NSString stringWithFormat:@"%@",@""],
                                     [NSString stringWithFormat:@"%@",@""],
                                     [NSString stringWithFormat:@"%@",timeSheet.activity.showAmount.boolValue ? str : @""],
                                     [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                    [array addObject:item];

                    }
				}
                else
                {
                    if(isFilterResult)
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.startTime]],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.endTime]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:[timeSheet.breakTime intValue]]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];
                    }
                    else
                    {
                        NSArray* item = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"%@",scheduleDate],
                                         [NSString stringWithFormat:@"%@",timeSheet.activity.activityTitle],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.startTime]],
                                         [NSString stringWithFormat:@"%@",[self convertTimeToString:timeSheet.endTime]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:[timeSheet.breakTime intValue]]],
                                         [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@",@""],
                                         [NSString stringWithFormat:@"%@",timeSheet.comments ? timeSheet.comments : @""], nil];
                        [array addObject:item];
                    }

				}	
				hasTotalRow = YES;
			}
            //Meghan
			generalTotal += total;
			total = 0;
		}
		
		if (hasTotalRow)
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            NSNumber *tmp = [[NSNumber alloc] initWithFloat:totalAmount];
            
            NSString *str = [numberFormatter stringFromNumber:tmp];
            
            if (isFilterResult)
            {
                NSArray* item = [NSArray arrayWithObjects:
                                 [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @"")],
                                 [NSString stringWithFormat:@"%@",@""],
                                 [NSString stringWithFormat:@"%@",@""],
                                 [NSString stringWithFormat:@"%@",@""],
                                 [NSString stringWithFormat:@"%@", @""],
                                 [NSString stringWithFormat:@"%@",@""],
                                 [NSString stringWithFormat:@"%@",[self convertPeriodToString:generalTotal]], str,
                                 [NSString stringWithFormat:@"%@", @""], nil];
                [array addObject:item];
            }
            else
            {
            NSArray* item = [NSArray arrayWithObjects:
                             [NSString stringWithFormat:@"%@",NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @"")], 
                             [NSString stringWithFormat:@"%@",@""],
                             [NSString stringWithFormat:@"%@",@""],
                             [NSString stringWithFormat:@"%@",@""],
                             [NSString stringWithFormat:@"%@", @""],
                             [NSString stringWithFormat:@"%@",@""],
                             [NSString stringWithFormat:@"%@",[self convertPeriodToString:generalTotal]],
                             [NSString stringWithFormat:@"%@",  [self convertPeriodToString:[schedule.offset intValue]]],
                             [NSString stringWithFormat:@"%@",  [self convertPeriodToString:(generalTotal - [schedule.offset intValue])]],
                             str,
                               [NSString stringWithFormat:@"%@", @""], nil];
            [array addObject:item];
            }
		}
	}
    
    NSArray *footer;
    if (isFilterResult==NO)
    {
        footer = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @"")]
                 ,
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 footerHoursLabel.text,
                 footerOffsetLabel.text,
                 footerBalanceLabel.text,
                 @"",
                 @"", nil];
    }
    else
        
        footer = [NSArray arrayWithObjects:
                 [NSString stringWithFormat:@"%@:", NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @"")],
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 footerHoursLabel.text,
                 @"",
                 @"",nil];

    [array addObject:footer];
	return array;						
}	


- (NSString*)formHTMLContent
{    
    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;

    NSString * htmlString = 
        [ NSString stringWithFormat: 
            @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=%@\"></head><body><table border=\"1\">",
            isIOS5 ? [ Localizator charsetForActiveLanguage ] : @"utf-8"
         ];
    
    htmlString = 
    [htmlString stringByAppendingString:
     [NSString stringWithFormat:
      @"\n<tr><td>%@</td><td>%@</td></tr>\n",userName,companyName]
     ];
    


    htmlString = 
        [htmlString stringByAppendingString:
            [NSString stringWithFormat:
                @"<tr><td>%@ : %@ %@ %@ %@</td></tr>\n",
                NSLocalizedString(@"REPORT_MYDATERANGE", @""),
                labelFrom.text,
                rangeLabelFrom.text,
                labelTo.text,
                rangeLabelTo.text
             ]
         ];

    if (isFilterResult==NO)
    {
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),rangeStartLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),rangeEndLabel.text]];
    }
    else
    {
        NSString *string=[NSString stringWithFormat:@"%@",self.totalString];
        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@</td></tr>\n",string]];
        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@  %@</td></tr>\n",NSLocalizedString(@"TOTAL_AMOUNT_HEADER", nil),self.totalAmountString]];
        if([filter isEqualToString:kMultiSelectString])
        {
            htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@  %@</td></tr>\n",NSLocalizedString(@"FILTER_HEADER", nil),self.multiFiler]];
        }
        else
        {
            htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@  %@</td></tr>\n",NSLocalizedString(@"FILTER_HEADER", nil),filter]];
        }
    }
	NSString *htmlRow =nil;
    if (isFilterResult)
    {
        htmlRow=[NSString stringWithFormat:
                 @"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_MONTH", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""),
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL_MIN", @"")];
    }
    else{
    htmlRow=[NSString stringWithFormat:
                         @"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_MONTH", @""), 
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_DATE", @""), 
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_ACTIVITY", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_START", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_END", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BREAK", @""),						
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_OFFSET", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BALANCE", @""),
                        NSLocalizedString(@"ACTIVITY_REPORT_HEADER_AMOUNT", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_COMMENTS", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL_MIN", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_OFFSET_MIN", @""),
						NSLocalizedString(@"ACTIVITY_REPORT_HEADER_BALANCE_MIN", @"")];
	}
	htmlString = [htmlString stringByAppendingString:htmlRow];
	for (Schedule *schedule in filteredReportData)
    {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
		
		NSArray *timeSheets = [NSArray arrayWithArray:[[schedule.timeSheets allObjects] sortedArrayUsingDescriptors:sortDescriptors]];
		
		[sortDescriptor release];
		[sortDescriptors release];		
		
		BOOL hasTotalRow = NO;
		int total = 0;
		int generalTotal = 0;
        CGFloat totalAmount = 0.0f;
		for (TimeSheet *timeSheet in timeSheets)
        {
            if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)] && [filter isEqualToString:kMultiSelectString])
            {
                BOOL valid = NO;
                for(ActivityModified *mod in self.selectedActivities)
                {
                    if([timeSheet.activity.activityTitle isEqualToString:mod.activity.activityTitle])
                    {
                        valid = YES;
                    }
                    else
                    {
                        
                    }
                }
                
                if(!valid) continue;
            }
            else if (![filter isEqualToString:NSLocalizedString(@"TITLE_ALL",nil)]&& ![timeSheet.activity.activityTitle isEqualToString:filter])
            {
                continue;
            }
			if (!timeSheet.activity)
            {
				continue;
			}	
//            if (isFilterResult &&! [timeSheet.activity.activityTitle isEqualToString:filter
//                                    ]) {
//                continue;
//                
//            }

			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"MMM YYYY"];
            [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
			NSString *month = ([dateFormatter stringFromDate:schedule.scheduleDate]);	
			[dateFormatter release];
			
			dateFormatter = [[NSDateFormatter alloc] init];
			//[dateFormatter setLocale:[NSLocale currentLocale]];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
            //[dateFormatter setDateFormat:@"dd/MM/YY"];
            NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
            if ([string isEqualToString:@"en_GB"]) {
                [dateFormatter setDateFormat:@"dd/MM/YY"];
            }
            else if ([string isEqualToString:@"en_US"]) {
                [dateFormatter setDateFormat:@"MM/dd/YY"];
            }
            else if ([string isEqualToString:@"sv_SE"]) {
                [dateFormatter setDateFormat:@"YY-MM-dd"];
            }
            else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"]) {
                [dateFormatter setDateFormat:@"dd.MM.YY"];
            }
			NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];	
			[dateFormatter release];
			
			
			if ([timeSheet.activity.flatMode boolValue])
            {
                setTimeForFlatHours = YES;
				if ([timeSheet.flatTime intValue]<0)
                {
                    /*
					NSString *htmlRow = 
                        [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td></tr>\n", 
                         month, scheduleDate, timeSheet.activity.activityTitle, [self convertPeriodToString:total], total];
					htmlString = [htmlString stringByAppendingString:htmlRow];
					continue;
                     */
				}			
			}
            else
            {
                setTimeForFlatHours = NO;
				if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0)){
					NSString *htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td></tr>\n", month, scheduleDate, timeSheet.activity.activityTitle, [self convertPeriodToString:total], total];
					htmlString = [htmlString stringByAppendingString:htmlRow];					
					continue;
				}
			}						
			
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
                    if(timeSheet.activity.showAmount.boolValue)
                    {
                        totalAmount += timeSheet.amount.floatValue;
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
			if ([timeSheets count]==1)
            {
				if ([timeSheet.activity.flatMode boolValue])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                    
                    NSString *str = [numberFormatter stringFromNumber:tmp];
                    
                    if (isFilterResult)
                    {
                        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><</tr>\n",
                                   month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
                                   [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                                   [self convertPeriodToString:total],timeSheet.activity.showAmount.boolValue ? str : @"",
                                   timeSheet.comments ? timeSheet.comments : @"",total];
                    }
                    else
					htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n",
							  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
							  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                               [self convertPeriodToString:total], [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(total - [schedule.offset intValue])], timeSheet.activity.showAmount.boolValue ? str : @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, [schedule.offset intValue], (total - [schedule.offset intValue])];					
				}
                else
                {
                    if (isFilterResult)
                    {
                        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td></tr>\n",
                                   month, scheduleDate, timeSheet.activity.activityTitle,
                                   [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
                                   [self convertPeriodToString:total],@"",
                                   timeSheet.comments ? timeSheet.comments : @"",total];
                    }
                    else
					htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n",
							  month, scheduleDate, timeSheet.activity.activityTitle, 
							  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
							  [self convertPeriodToString:total], [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(total - [schedule.offset intValue])],
                               @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, [schedule.offset intValue], (total - [schedule.offset intValue])];
				}
                
				hasTotalRow = NO;
                
			}
            else
            {
				if ([timeSheet.activity.flatMode boolValue])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    NSNumber *tmp = [[NSNumber alloc] initWithFloat:timeSheet.amount.floatValue];
                    
                    NSString *str = [numberFormatter stringFromNumber:tmp];
                    
                    if (isFilterResult)
                    {
                        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td></tr>\n",
                                   month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
                                   [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
                                   [self convertPeriodToString:total], timeSheet.activity.showAmount.boolValue ? str : @"",
                                   timeSheet.comments ? timeSheet.comments : @"",
                                   total];
                    }
                    else
					htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n", 
							  month, scheduleDate, timeSheet.activity.activityTitle, NSLocalizedString(@"ACTIVITY_REPORT_FLAT", @""),
							  [self convertPeriodToString:timeSheet.flatTime.intValue], @"",
							  [self convertPeriodToString:total], @"", @"", timeSheet.activity.showAmount.boolValue ? str : @"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, 0, 0];
				}
                else
                {
                    if (isFilterResult)
                    {
                        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td></tr>\n",
                                   month, scheduleDate, timeSheet.activity.activityTitle,
                                   [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
                                   [self convertPeriodToString:total], @"",
                                   timeSheet.comments ? timeSheet.comments : @"", total];
                    }
                    else
                    
					htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n", 
							  month, scheduleDate, timeSheet.activity.activityTitle, 
							  [self convertTimeToString:timeSheet.startTime], [self convertTimeToString:timeSheet.endTime], [self convertPeriodToString:[timeSheet.breakTime intValue]],
                               [self convertPeriodToString:total], @"", @"",@"",
							  timeSheet.comments ? timeSheet.comments : @"",
							  total, 0, 0];					
				}	
				hasTotalRow = YES;
			}
            //Meghan
            //  //NSLog(@"CSV ROW : %@",cvsRow);
			htmlString = [htmlString stringByAppendingString:htmlRow];
			generalTotal += total;
			total = 0;
		}
		
		if (hasTotalRow)
        {
            NSNumber *number = [NSNumber numberWithFloat:totalAmount];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:[NSLocale currentLocale]];
            NSString *str = [numberFormatter stringFromNumber:number];
            
            if (isFilterResult)
            {
                htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td></tr>\n",
                           NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @""), @"", @"",
                           @"", @"", @"",
                           [self convertPeriodToString:generalTotal],
                           str,
                           @"",
                           generalTotal];
            }
            else
			htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n",
					  NSLocalizedString(@"ACTIVITY_REPORT_DAILY_TOTAL", @""), @"", @"",
					  @"", @"", @"",
					  [self convertPeriodToString:generalTotal], 
                      [self convertPeriodToString:[schedule.offset intValue]], [self convertPeriodToString:(generalTotal - [schedule.offset intValue])], str,
					  @"",
					  generalTotal, [schedule.offset intValue], (generalTotal - [schedule.offset intValue])];
            //Meghan
            // //NSLog(@"CSV ROW 2: %@",cvsRow);
			htmlString = [htmlString stringByAppendingString:htmlRow];
		}
	}
    
    NSString *footerRow;
    if (isFilterResult)
    {
        footerRow =[NSString stringWithFormat:
                 @"<tr><td>%@:</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 footerHoursLabel.text,
                 @"",
                 @"",
                 @""];
    }
    else
    {
        footerRow = [NSString stringWithFormat:
                 @"<tr><td>%@:</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                 NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @""),
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 footerHoursLabel.text,
                 footerOffsetLabel.text,
                 footerBalanceLabel.text,
                 @"",
                 @"",
                 @"",
                 @"",
                 @""];
	}
    htmlString = [ htmlString stringByAppendingString:footerRow];
    htmlString = [ htmlString stringByAppendingString: @"</table></html></body>" ];
	return htmlString;						
}	

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setRangeEndLabel:nil];
    [self setRangeStartLabel:nil];
    [self setRangeLabel:nil];
    [self setRangeLabelFrom:nil];
    [self setRangeLabelTo:nil];
    [self setHeaderCell:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[activityReportCell release];
	[headerScrollView release];
	[scrollView release];
	
	[managedObjectContext release];
	[reportData release];
   // [filteredReportData release];
	[reportRowViews release];
    [headerCell release];
    [rangeLabelFrom release];
    [rangeLabelTo release];
    [rangeLabel release];
    [rangeStartLabel release];
    [rangeEndLabel release];
    [labelTotal release];labelTotal=nil;
    [super dealloc];
}

#pragma mark -
#pragma mark ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)cScrollView
{
	[headerScrollView scrollRectToVisible:CGRectMake(cScrollView.contentOffset.x, 0, 333, 27) animated:NO];
}	

#pragma mark -
#pragma mark Show Methods Sample

- (void)show {
	[SVProgressHUD show];
}

- (void)showWithStatus:(NSString *) status {
	[SVProgressHUD showWithStatus:status];
}


#pragma mark -
#pragma mark Dismiss Methods Sample

- (void)dismiss {
	[SVProgressHUD dismiss];
}
-(void) viewWillDisAppear:(BOOL)animated{
    [self dismiss];
    
}

- (void)dismissAllPopTipViews
{
	while ([visiblePopTipViews count] > 0)
    {
		CMPopTipView *popTipView = [visiblePopTipViews objectAtIndex:0];
		[popTipView dismissAnimated:YES];
		[visiblePopTipViews removeObjectAtIndex:0];
	}
}

#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	[visiblePopTipViews removeObject:popTipView];
	self.currentPopTipViewTarget = nil;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (CMPopTipView *popTipView in visiblePopTipViews) {
		id targetObject = popTipView.targetObject;
		[popTipView dismissAnimated:NO];
		
		if ([targetObject isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)targetObject;
			[popTipView presentPointingAtView:button inView:self.view animated:NO];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
		}
	}
}

@end

