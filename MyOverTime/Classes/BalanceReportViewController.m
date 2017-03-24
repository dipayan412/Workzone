//
//  BalanceReportViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "BalanceReportViewController.h"
#import "BalanceReportRowView.h"
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
#import "GlobalFunctions.h"

@interface BalanceReportViewController(PrivateMethods)
- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate;
- (void) displayFetchedData:(NSDate*)startDate to:(NSDate*)finalDate;
//- (void) displayFetchedData;

- (NSString*) convertPeriodToString:(int)period;

- (NSString *)applicationDocumentsDirectory;
- (void)launchMailAppOnDevice;
- (NSString*)formCVSContent;
- (NSString*)formHTMLContent;

@end

@implementation BalanceReportViewController

@synthesize reportCell, headerCell, footerCell;
@synthesize totalBalanceLabel;
@synthesize labelFrom;
@synthesize labelTo;
@synthesize rangeLabelFrom;
@synthesize rangeLabelTo;
@synthesize rangeLabel;
@synthesize inRangeLabel;
@synthesize footerBalanceLabel, footerHoursLabel, footerOffsetLabel;

@synthesize scrollView;
@synthesize managedObjectContext, reportData;
@synthesize reportRowViews;
@synthesize beginDate,endDate;
@synthesize userName,companyName;
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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	/*	
	UIBarButtonItem *changeReportBtn = [[UIBarButtonItem alloc] initWithTitle:@"Activity" style:UIBarButtonItemStylePlain target:self action:@selector(someAction:)];
	self.navigationItem.rightBarButtonItem = changeReportBtn;
	[changeReportBtn release];
	*/
    UILabel *defaultTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    defaultTitle.backgroundColor = [UIColor clearColor];
    defaultTitle.textAlignment = UITextAlignmentCenter;
    defaultTitle.textColor = [UIColor whiteColor];
    defaultTitle.font = [UIFont boldSystemFontOfSize:15];
    defaultTitle.text = NSLocalizedString(@"BALANCE_REPORT_TITLE", @"");
    self.navigationItem.titleView = defaultTitle;
    [defaultTitle release];
	
	scrollView.backgroundColor = [UIColor clearColor];
    
    footerCell.backgroundColor = [UIColor clearColor];
    footerCell.backgroundView = nil;
    footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = footerBalanceLabel.frame;
    frame.size.width = 42;
    frame.origin.x = frame.origin.x + 3;
    frame.size.width = frame.size.width + 2;
    footerBalanceLabel.frame = frame;
    frame = footerHoursLabel.frame;
    frame.origin.x = frame.origin.x + 2;
    frame.size.width = 42;
    footerHoursLabel.frame = frame;
    frame = footerOffsetLabel.frame;
    frame.size.width = 42;
    frame.origin.x = frame.origin.x + 2;
    footerOffsetLabel.frame = frame;
    
//    footerBalanceLabel.backgroundColor =
//    footerHoursLabel.backgroundColor =
//    footerOffsetLabel.backgroundColor = [UIColor lightGrayColor];
    footerHoursLabel.textAlignment =
    footerBalanceLabel.textAlignment =
    footerOffsetLabel.textAlignment = UITextAlignmentRight;
    
    if(USER_INTERFACE_IPHONE5())
    {
        CGRect frame = reportCell.frame;
        frame.size.height += 90;
        reportCell.frame = frame;
        
        frame = scrollView.frame;
        frame.origin.y = 30;
        frame.size.height += 90;
        scrollView.frame = frame;
    }
    
    [self makeToolBarButtons];
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
	
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}	
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
    //Added by Meghan
    
//    //NSLog(@"Start Date : %@  End Date : %@",beginDate,endDate);
//    dateRangeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",NSLocalizedString(@"REPORT_FROM", @""), beginDate,NSLocalizedString(@"REPORT_TO", @""),endDate];
    
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
  
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter dateFromString:beginDate]];
	[comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
   //NSLog(@"Known Timezones : %@",[NSTimeZone timeZoneWithName:@"GMT-1000"]);
    
	NSDate *sDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:[dateFormatter dateFromString:endDate]];
	[comps1 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
	NSDate *eDate = [[NSCalendar currentCalendar] dateFromComponents:comps1];
    
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dateFormatter setLocale:locale];

    //[dateFormatter setDateFormat:@"dd/MM/YY"];
//    NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
//    if ([string isEqualToString:@"en_GB"])
//    {
//        [dateFormatter setDateFormat:@"dd/MM/YY"];
//    }
//    else if ([string isEqualToString:@"en_US"])
//    {
//        [dateFormatter setDateFormat:@"MM/dd/YY"];
//    }
//    else if ([string isEqualToString:@"sv_SE"])
//    {
//        [dateFormatter setDateFormat:@"YY-MM-dd"];
//    }
//    else if ([string isEqualToString:@"pl_PL"]||[string isEqualToString:@"tr_TR"])
//    {
//        [dateFormatter setDateFormat:@"dd.MM.YY"];
//    }
    
    if ([[dateFormatter stringFromDate:sDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
    rangeLabelFrom.text = [dateFormatter stringFromDate: sDate];
    rangeLabelTo.text = [dateFormatter stringFromDate: eDate];
    rangeLabelTo.minimumFontSize =
    rangeLabelFrom.minimumFontSize = 8.0;
    rangeLabelFrom.adjustsFontSizeToFitWidth = YES;
    rangeLabelTo.adjustsFontSizeToFitWidth = YES;
    
	[self fetchReportDataFrom:[sDate midnightUTC] to:[eDate dateByAddingTimeInterval:0]];
    //[self fetchReportDataFrom:nil to:nil];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
    {
		return 110.0;
	}
    else if (indexPath.row == 1)
    {
        if(USER_INTERFACE_IPHONE5())
        {
            return 282.0;
        }
        return 192.0;
    }
    return 45.0;
}	

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	if (indexPath.row == 0)
    {
		return headerCell;
	}
    else if (indexPath.row == 1)
    {
		return reportCell;
	}
    return footerCell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark Report Data Managemnent

- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	/*
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
															  fromDate:cDate];
	NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate == %@", beginningOfDay];
	[request setPredicate:predicate];
	*/
    
    //Added by Meghan
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleDate <= %@",finalDate];
	[request setPredicate:predicate];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:NO];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:NO selector:@selector(localizedCompare:)];
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
	}
    else
    {
//		self.reportData = mutableFetchResults;
        
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
        
        [temp release];
        [array release];
	}
	[request release];
    
	
	[self displayFetchedData:startDate to:finalDate];
	
}	/*
-(void) localizedCompare:(id) dummy{
    NSLog(@"xxxxxx");

}*/
- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)sDate andDate:(NSDate*)eDate
{
    if ([date compare:sDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:eDate] == NSOrderedDescending) 
        return NO;
    
    return YES;
}

- (void) displayFetchedData:(NSDate*)startDate to:(NSDate*)finalDate
{
	
	for (BalanceReportRowView *curRowView in reportRowViews)
    {
		[curRowView removeFromSuperview];
	}
	
	scrollView.contentSize = CGSizeMake(270, 150);	
	self.reportRowViews = [[NSMutableArray alloc] initWithCapacity:0];
	
	int rowShift = 0;
	int balance = 0;
    int balanceRange = 0;
    
    int totalFullHours = 0;
    int totalFullOffset = 0;
    int totalFullBalance = 0;
    
    BOOL inRange = NO;
	for (Schedule *schedule in reportData)
    {
        if ([self date:schedule.scheduleDate isBetweenDate:startDate andDate:finalDate])
        {
            inRange = YES;
        }
        else
        {
            inRange = NO;
        }       
        

        if ([schedule.timeSheets count]==0)
        {
            continue;
        }	
        int offset = [schedule.offset intValue];
        int offsetRange=0;
        if (inRange)
        {
            offsetRange = [schedule.offset intValue];
            totalFullOffset += offsetRange;
        }
        int total = 0;
        int totalinRange = 0;
        BOOL newSchedule = YES;
        for (TimeSheet *timeSheet in schedule.timeSheets)
        {
            if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
            {
                continue;
            }
            
            if (inRange)
            {
                if (newSchedule)
                {
                    BalanceReportRowView *rowView = [[BalanceReportRowView alloc] initWithFrame:CGRectMake(0, rowShift, 280, 30)];
                    [rowView bindDataToView:schedule];
                    [scrollView addSubview:rowView];
                    rowShift += 30;
                    [reportRowViews addObject:rowView];
                    [rowView release];
                    
                    newSchedule = NO;
                }	
            }
            
            
            if ([timeSheet.activity.flatMode boolValue])
            {
                if ([timeSheet.flatTime intValue]<0)
                {
                    continue;
                }			
            }
            else
            {
                if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
                {
                    continue;
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
                            totalinRange -= [timeSheet.flatTime intValue];
                            totalFullHours -= [timeSheet.flatTime intValue];
                        }
                        else
                        {
                            totalinRange += [timeSheet.flatTime intValue];
                            totalFullHours += [timeSheet.flatTime intValue];
                        }
                    }
                    else
                    {
                        if ([timeSheet.endTime intValue]<[timeSheet.startTime intValue])
                        {
                            totalinRange += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                            totalFullHours += 24*60 - [timeSheet.startTime intValue] + [timeSheet.endTime intValue];
                        }
                        else
                        {
                            totalinRange += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                            totalFullHours += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }					
                        if ([timeSheet.breakTime intValue]>0)
                        {
                            totalinRange -= [timeSheet.breakTime intValue];
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
        
        balance += (total - offset);
        
        if (inRange)
        {
            balanceRange += (totalinRange - offsetRange);
        }
	}
    
    totalFullBalance = (totalFullHours - totalFullOffset);
    
	totalBalanceLabel.text = [self convertPeriodToString:balance];//3
    rangeLabel.text = [self convertPeriodToString:balanceRange];//1
    inRangeLabel.text = [self convertPeriodToString:balance-balanceRange];//2
    
    footerBalanceLabel.textAlignment =
    footerHoursLabel.textAlignment =
    footerOffsetLabel.textAlignment = UITextAlignmentCenter;
    
    footerBalanceLabel.adjustsFontSizeToFitWidth =
    footerHoursLabel.adjustsFontSizeToFitWidth =
    footerOffsetLabel.adjustsFontSizeToFitWidth = YES;
    
    footerHoursLabel.text = [self convertPeriodToString:totalFullHours];
    footerOffsetLabel.text = [self convertPeriodToString:totalFullOffset];
    footerBalanceLabel.text = [self convertPeriodToString:balanceRange];
    
//    footerHoursLabel.backgroundColor =
//    footerOffsetLabel.backgroundColor =
//    footerBalanceLabel.backgroundColor = [UIColor lightGrayColor];
//    
	scrollView.contentSize = CGSizeMake(270, rowShift);
}

- (NSString*) convertPeriodToString:(int)period
{
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    if(timeStyle != StyleDecimal)
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
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
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
            if (minutes < 10)
            {
                return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
            }
            else
            {
                return [NSString stringWithFormat:@"%d:%d", hours, minutes];
            }
        }
    }
    else
    {
        if (period < 0)
        {
            period *= (-1);
            
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            return [NSString stringWithFormat:@"-%0.2f", decimalHours];
        }
        else
        {
            int hours = floor(period/60.0);
            int minutes = period - hours * 60;
            
            CGFloat floatHours = hours;
            CGFloat floatMinutes = minutes;
            
            CGFloat decimalHours = floatHours + (floatMinutes/60);
            
            return [NSString stringWithFormat:@"%0.2f", decimalHours];
        }
    }	
}

#pragma mark -
#pragma mark Export to xls

- (IBAction) emailAction:(id)sender {

#ifdef INAPP_VERSION	
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!app.isProduct2Purchased)
    {
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: kAlertHeader
                              message: kAlertMessage
                              delegate:self
                              cancelButtonTitle:kAlertOK
                              otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        
        */
        [app showEmailAlert];
        return;
    }
#endif	

	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if (![mailClass canSendMail]){
			[self launchMailAppOnDevice];
		}
	} else {
		[self launchMailAppOnDevice];
	}	
	
    [self showWithStatus:NSLocalizedString(@"PREPARING_MAIL", @"")];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:NSLocalizedString(@"BALANCE_REPORT_EMAIL_SUBJECT", @"")];
	
	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:@""];
    NSArray *toRecipients = [NSArray arrayWithObjects:[GlobalFunctions getDefaultEmail], nil];
	
	[picker setToRecipients:toRecipients];
	

    NSString * cvsContent = [self formCVSContent];
    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;
    
    NSData * myData = nil;
    NSString * htmlContent = [self formHTMLContent];
    NSString * pdfHeader = [self formPDFContentHeader];
    NSArray * pdfData = [self formPDFContent];
    NSString* fileName = [self getPDFFileName];
    //Delete stored pdf
    [self deleteTemporaryPdf];
    [PDFRenderer drawPDF:fileName forArray:pdfData andHeaderText:pdfHeader andAdjust:NO orientation:PageOrientation_Portrait];
    
    
    myData=[NSData dataWithContentsOfFile:[self getPDFFileName]];
    if( myData )
        [ picker addAttachmentData:myData mimeType:@"application/pdf" fileName:NSLocalizedString(@"BALANCE_REPORT_EMAIL_ATTACHMENT_2", @"")];

    if( isIOS5 )
    {
        myData = [ Localizator encodedDataFromString: cvsContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [ picker addAttachmentData: myData
                              mimeType: @"text/csv"
                              fileName: NSLocalizedString( @"BALANCE_REPORT_EMAIL_ATTACHMENT", @"" )
             ];        

        myData = [ Localizator encodedDataFromString: htmlContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [ picker addAttachmentData: myData
                              mimeType: @"text/html"
                              fileName: NSLocalizedString( @"BALANCE_REPORT_EMAIL_ATTACHMENT_1", @"" )
             ];
    }
    else
    {
        myData = [ Localizator encodedDataFromString: cvsContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [ picker addAttachmentData: myData
                              mimeType: @"text/csv"
                              fileName: NSLocalizedString( @"BALANCE_REPORT_EMAIL_ATTACHMENT", @"" )
             ];

        myData = [ Localizator encodedDataFromString: htmlContent
                                        withEncoding: NSUTF8StringEncoding ];
        if( myData )
            [ picker addAttachmentData: myData
                              mimeType: @"text/html"
                              fileName: NSLocalizedString( @"BALANCE_REPORT_EMAIL_ATTACHMENT_1", @"" )
             ];
    }
    

	NSString *emailBody = NSLocalizedString(@"BALANCE_REPORT_EMAIL_CONTENT", @"");
	[picker setMessageBody:emailBody isHTML:NO];
    picker.navigationBar.tintColor=[UIColor blackColor];

	[self presentModalViewController:picker animated:YES];
    [self dismiss];
    [picker release];
	
}	

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	 
    //NSLog( @"result = %d", result );
	[self dismissModalViewControllerAnimated:YES];
}


- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)launchMailAppOnDevice
{
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
                rangeLabelTo.text
             ]
         ];
    cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
    cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),inRangeLabel.text]];
    cvsString = [cvsString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),totalBalanceLabel.text]];
	NSString *cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n", 
						NSLocalizedString(@"BALANCE_REPORT_HEADER_WEEKDAY", @""), 
						NSLocalizedString(@"BALANCE_REPORT_HEADER_DATE", @""), 
						NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL_MIN", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET_MIN", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE_MIN", @"")];
	
	cvsString = [cvsString stringByAppendingString:cvsRow];
	
	for (Schedule *schedule in reportData)
    {
		if ([schedule.timeSheets count]==0)
        {
			continue;
		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setLocale:[NSLocale currentLocale]];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSDate *sDate = [dateFormatter dateFromString:beginDate];
        NSDate *eDate = [dateFormatter dateFromString:endDate];
        
        if ([self date:schedule.scheduleDate isBetweenDate:sDate andDate:[[eDate midnightUTC] dateByAddingTimeInterval:2*86400]])
        {
            NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];
            [dateFormatter release];
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[Localizator localeIdentifierForActiveLanguage]]];
            NSString *weekday = ([dateFormatter stringFromDate:schedule.scheduleDate]);
            [dateFormatter release];
            //Meghan
            
            int offset = [schedule.offset intValue];
            int total = 0;
            for (TimeSheet *timeSheet in schedule.timeSheets)
            {
                if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
                {
                    continue;
                }
                
                if ([timeSheet.activity.flatMode boolValue])
                {
                    if ([timeSheet.flatTime intValue]<0)
                    {
                        continue;
                    }			
                }
                else
                {
                    if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0)){
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
                    }
                    else
                    {
                        if ([timeSheet.breakTime intValue]<0)
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }
                        else
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
                        }		
                    }
                }
            }
            
            cvsRow = 
                [ NSString stringWithFormat: 
                        @"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n", 
                        weekday, 
                        scheduleDate, 
                        [self convertPeriodToString:total], 
                        [self convertPeriodToString:offset],    
                        [self convertPeriodToString:(total - offset)], 
                        total, 
                        offset, 
                        (total-offset)
                 ];
            cvsString = [cvsString stringByAppendingString:cvsRow];
        }
	}
    
    NSString *footerRow = [NSString stringWithFormat:@"\"%@:\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n",
						NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
						@"",
						footerHoursLabel.text,
						footerOffsetLabel.text,
                        footerBalanceLabel.text,
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
    NSString * htmlString =
     [NSString stringWithFormat:
      @"%@     %@\n%@ : %@ %@ %@ %@\n",self.userName,self.companyName,
      NSLocalizedString(@"REPORT_MYDATERANGE", @""),
      labelFrom.text,
      rangeLabelFrom.text,
      labelTo.text,
      rangeLabelTo.text
     ];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),inRangeLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),totalBalanceLabel.text]];
    //NSLog(@"html %@",htmlString);

    return htmlString;
}

- (NSArray*)formPDFContent 
{
//    NSArray* headers = [NSArray arrayWithObjects:
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_WEEKDAY", @""), 
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_DATE", @""), 
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET", @""),
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE", @""),
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL_MIN", @""),
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET_MIN", @""),
//                        NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE_MIN", @""), nil];
    
    NSArray* headers = [NSArray arrayWithObjects:
                        NSLocalizedString(@"BALANCE_REPORT_HEADER_WEEKDAY", @""),
                        NSLocalizedString(@"BALANCE_REPORT_HEADER_DATE", @""),
                        NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
                        NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET", @""),
                        NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE", @""),
                        nil];

    
	NSMutableArray *array=[[[NSMutableArray alloc]initWithCapacity:1000] autorelease];
    [array addObject:headers];
    
	for (Schedule *schedule in reportData)
    {
		if ([schedule.timeSheets count]==0)
        {
			continue;
		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setLocale:[NSLocale currentLocale]];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];

        NSDate *sDate = [dateFormatter dateFromString:beginDate];
        NSDate *eDate = [dateFormatter dateFromString:endDate];
        
        if ([self date:schedule.scheduleDate isBetweenDate:sDate andDate:[[eDate midnightUTC] dateByAddingTimeInterval:2*86400]])
        {

            NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];
            [dateFormatter release];
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
            NSString *weekday = ([dateFormatter stringFromDate:schedule.scheduleDate]);
            [dateFormatter release];
            //Meghan
            
            int offset = [schedule.offset intValue];
            int total = 0;
            for (TimeSheet *timeSheet in schedule.timeSheets)
            {
                if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
                {
                    continue;
                }
                
                if ([timeSheet.activity.flatMode boolValue])
                {
                    if ([timeSheet.flatTime intValue]<0)
                    {
                        continue;
                    }			
                }
                else
                {
                    if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
                    {
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
                    }
                    else
                    {
                        if ([timeSheet.breakTime intValue]<0)
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }
                        else
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
                        }		
                    }
                }
            }
            
            
//            NSArray* item = [NSArray arrayWithObjects:
//                             [NSString stringWithFormat:@"%@",weekday], 
//                             [NSString stringWithFormat:@"%@",scheduleDate],
//                             [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
//                             [NSString stringWithFormat:@"%@",[self convertPeriodToString:offset]],
//                             [NSString stringWithFormat:@"%@", [self convertPeriodToString:(total - offset)]],
//                             [NSString stringWithFormat:@"%d",total],
//                             [NSString stringWithFormat:@"%d",offset],
//                             [NSString stringWithFormat:@"%d", (total-offset)], nil];
//            [array addObject:item];
            
            NSArray* item = [NSArray arrayWithObjects:
                             [NSString stringWithFormat:@"%@",weekday],
                             [NSString stringWithFormat:@"%@",scheduleDate],
                             [NSString stringWithFormat:@"%@",[self convertPeriodToString:total]],
                             [NSString stringWithFormat:@"%@",[self convertPeriodToString:offset]],
                             [NSString stringWithFormat:@"%@", [self convertPeriodToString:(total - offset)]],nil];
            [array addObject:item];
        }
	}
    
//    NSArray* footer = [NSArray arrayWithObjects:
//                        [NSString stringWithFormat:@"%@:", NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @"")],
//                        @"",
//                        [NSString stringWithFormat:@"%@", footerHoursLabel.text],
//                        [NSString stringWithFormat:@"%@", footerOffsetLabel.text],
//                        [NSString stringWithFormat:@"%@", footerBalanceLabel.text],
//                        @"",
//                        @"",
//                        @"", nil];
    
    NSArray* footer = [NSArray arrayWithObjects:
                       [NSString stringWithFormat:@"%@:", NSLocalizedString(@"ACTIVITY_REPORT_HEADER_TOTAL", @"")],
                       @"",
                       [NSString stringWithFormat:@"%@", footerHoursLabel.text],
                       [NSString stringWithFormat:@"%@", footerOffsetLabel.text],
                       [NSString stringWithFormat:@"%@", footerBalanceLabel.text],
                       nil];
    
    [array addObject:footer];
    
	return array;
}	


#pragma mark -
#pragma mark HTML Content
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
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_FOR_RANGE", @""),rangeLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_START", @""),inRangeLabel.text]];
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<tr><td>%@ : %@</td></tr>\n",NSLocalizedString(@"REPORT_BALANCE_RANGE_END", @""),totalBalanceLabel.text]];
	
    NSString *htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
						NSLocalizedString(@"BALANCE_REPORT_HEADER_WEEKDAY", @""), 
						NSLocalizedString(@"BALANCE_REPORT_HEADER_DATE", @""), 
						NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL_MIN", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_OFFSET_MIN", @""),
						NSLocalizedString(@"BALANCE_REPORT_HEADER_BALANCE_MIN", @"")];
	
	htmlString = [htmlString stringByAppendingString:htmlRow];
	//NSLog(@"html string %@",htmlString);
	for (Schedule *schedule in reportData)
    {
		if ([schedule.timeSheets count]==0)
        {
			continue;
		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setLocale:[NSLocale currentLocale]];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
            NSDate *sDate = [dateFormatter dateFromString:beginDate];
        NSDate *eDate = [dateFormatter dateFromString:endDate];
        
        if ([self date:schedule.scheduleDate isBetweenDate:[sDate dateByAddingTimeInterval:0] andDate:[[eDate midnightUTC] dateByAddingTimeInterval:2*86400]])
        {
            NSString *scheduleDate = [dateFormatter stringFromDate:schedule.scheduleDate];
            [dateFormatter release];
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
            NSString *weekday = ([dateFormatter stringFromDate:schedule.scheduleDate]);
            [dateFormatter release];
            //Meghan
            
            int offset = [schedule.offset intValue];
            int total = 0;
            for (TimeSheet *timeSheet in schedule.timeSheets)
            {
                if ((!timeSheet.activity)||(!timeSheet.activity.estimateMode))
                {
                    continue;
                }
                
                if ([timeSheet.activity.flatMode boolValue])
                {
                    if ([timeSheet.flatTime intValue]<0)
                    {
                        continue;
                    }			
                }
                else
                {
                    if (([timeSheet.startTime intValue]<0)||([timeSheet.endTime intValue]<0))
                    {
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
                    }
                    else
                    {
                        if ([timeSheet.breakTime intValue]<0)
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue];
                        }
                        else
                        {
                            total += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
                        }		
                    }
                }
            }
            
            htmlRow = 
                [ NSString stringWithFormat: 
                 @"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n", 
                 weekday, 
                 scheduleDate, 
                 [self convertPeriodToString:total], 
                 [self convertPeriodToString:offset],    
                 [self convertPeriodToString:(total - offset)], 
                 total, 
                 offset, 
                 (total-offset)
                 ];
            htmlString = [htmlString stringByAppendingString:htmlRow];
        }
	}

    NSString *htmlFooter =
    [ NSString stringWithFormat:
     @"<tr><td>%@:</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
     NSLocalizedString(@"BALANCE_REPORT_HEADER_TOTAL", @""),
     @"",
     footerHoursLabel.text,
     footerOffsetLabel.text,
     footerBalanceLabel.text,
     @"",
     @"",
     @""
     ];
    
    htmlString = [htmlString stringByAppendingString:htmlFooter];
    
	return htmlString;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setInRangeLabel:nil];
    [self setRangeLabel:nil];
    [self setRangeLabelFrom:nil];
    [self setRangeLabelTo:nil];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
	[reportCell release];
	[headerCell release];
	
	[totalBalanceLabel release];
	
	[scrollView release];
	
	[managedObjectContext release];
	[reportData release];
	
	[reportRowViews release];
    
    [labelFrom release];
    [labelTo release];
    [rangeLabelFrom release];
    [rangeLabelTo release];
    [rangeLabel release];
    [inRangeLabel release];
    [super dealloc];
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
@end

