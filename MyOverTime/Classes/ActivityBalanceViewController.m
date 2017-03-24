//
//  ActivityBalanceViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ActivityBalanceViewController.h"
#import "ActivityBalanceRowView.h"
#import "Activity.h"
#import "Schedule.h"
#import "GlobalFunctions.h"
#import "Localizator.h"
#import "PDFGenerator.h"
#import "PDFRenderer.h"
#import "MyOvertimeAppDelegate.h"
#import "StaticConstants.h"
#import "SVProgressHUD.h"
#import "GlobalFunctions.h"

@interface ActivityBalanceViewController (PrivateMethods)
- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate;
- (void) displayFetchedData;

- (void)launchMailAppOnDevice;
- (NSString *)applicationDocumentsDirectory;
- (NSString*)formCVSContent;
- (NSString*)formHTMLContent;
- (NSString*)convertPeriodToString:(int)period;
@end

@implementation ActivityBalanceViewController

@synthesize managedObjectContext, activityBalanceCell, scrollView, reportData, reportRowViews;
@synthesize userName,companyName;
#pragma mark -
#pragma mark View lifecycle



-(void) makeToolBarButtons{
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

    UILabel *defaultTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    defaultTitle.backgroundColor = [UIColor clearColor];
    defaultTitle.textAlignment = UITextAlignmentCenter;
    defaultTitle.textColor = [UIColor whiteColor];
    defaultTitle.font = [UIFont boldSystemFontOfSize:14];
    defaultTitle.text = NSLocalizedString(@"REPORT_LIST_ACTIVITY_BALANCE_REPORT", @"");
    self.navigationItem.titleView = defaultTitle;
    defaultTitle.numberOfLines=2;
    [defaultTitle release];

	//self.navigationItem.title = NSLocalizedString(@"ACTIVITY_BALANCE_TITLE", @"");
	
	self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
	
	scrollView.backgroundColor = [UIColor clearColor];	
    
    CGRect frame=scrollView.frame;
    frame.size.height=240;
    scrollView.frame=frame;
    [self makeToolBarButtons];
}


- (void)viewWillAppear:(BOOL)animated {
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
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	myImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
	self.tableView.backgroundView = myImageView;
	[myImageView release];
	
	[self fetchReportDataFrom:nil to:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return activityBalanceCell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 300.0;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[activityBalanceCell release];
	[scrollView release];
	
	[managedObjectContext release];
	[reportData release];
	
	[reportRowViews release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Report Data Managemnent

- (void) fetchReportDataFrom:(NSDate*)startDate to:(NSDate*)finalDate {
		
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeSheet" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSDate *invalidDate = [df dateFromString:@"2002-01-01"];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"schedule.scheduleDate > %@ AND activity.allowance > %@", invalidDate, [NSNumber numberWithInt:0]];
	[request setPredicate:predicate];
	
	NSSortDescriptor *allowanceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activity" ascending:NO];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"schedule.scheduleDate" ascending:NO];
	
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:allowanceSortDescriptor, sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	[allowanceSortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (fetchResults == nil)
    {
		// Handle the error.
	}
    else
    {
		self.reportData = fetchResults;
	}
	[request release];	
		
	[self displayFetchedData];
}	

- (void) displayFetchedData
{
	for (ActivityBalanceRowView *curRowView in reportRowViews)
    {
		[curRowView removeFromSuperview];
	}
	
	if ([reportData count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REPORT_LIST_ACTIVITY_BALANCE_REPORT", @"") message:NSLocalizedString(@"EMPTY_ALLOWANCE_ALERT", nil) delegate:self cancelButtonTitle:kAlertOK otherButtonTitles: nil];
        [alert show];
        [alert release];
        
		return;
	}	
	
	scrollView.contentSize = CGSizeMake(270, 100);		
	self.reportRowViews = [[NSMutableArray alloc] initWithCapacity:0];

	Activity *currentActivity = nil;
	int rowShift = 0;
	int totalApplied = 0;
	for (TimeSheet *timeSheet in reportData)
    {
		if (([timeSheet.activity.flatMode boolValue])&&([timeSheet.flatTime intValue]==-1))
        {
			continue;
		}
        else if ((![timeSheet.activity.flatMode boolValue])&&(([timeSheet.startTime intValue]==-1)||([timeSheet.endTime intValue]==-1)||([timeSheet.breakTime intValue]==-1)))
        {
			continue;
		}	
		
		if ((![timeSheet.activity isEqual:currentActivity])&&(currentActivity))
        {
			ActivityBalanceRowView *rowView = [[ActivityBalanceRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
			
			rowView.isTotal = YES;
			rowView.allowanceHours = [currentActivity.allowance floatValue];
			rowView.totalApplied = totalApplied;
			[rowView bindDataToView:nil];
			[scrollView addSubview:rowView];
			[reportRowViews addObject:rowView];
			rowShift +=30;	
			
			totalApplied = 0;
		}		
		
		ActivityBalanceRowView *rowView = [[ActivityBalanceRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
		rowView.isHeader = ![timeSheet.activity isEqual:currentActivity];
		[rowView bindDataToView:timeSheet];
		[scrollView addSubview:rowView];
		[reportRowViews addObject:rowView];
		rowShift +=30;
		
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                totalApplied -= [timeSheet.flatTime intValue];
            }
			else
            {
                totalApplied += [timeSheet.flatTime intValue];
            }
            */
            totalApplied += [timeSheet.flatTime intValue];
		}
        else
        {
			totalApplied += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	

		if (currentActivity)
        {
			[currentActivity release];
		}	
		currentActivity = [timeSheet.activity retain];
	}
	
	ActivityBalanceRowView *rowView = [[ActivityBalanceRowView alloc] initWithFrame:CGRectMake(0, rowShift, 270, 30)];
	
	rowView.isTotal = YES;
//	rowView.allowanceHours = [GlobalFunctions allowanceHoursFromField:[currentActivity.allowance floatValue]];
	rowView.allowanceHours = [currentActivity.allowance floatValue];
	rowView.totalApplied = totalApplied;
	[rowView bindDataToView:nil];
	[scrollView addSubview:rowView];
	[reportRowViews addObject:rowView];	
	
	scrollView.contentSize = CGSizeMake(270, rowShift+30);	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Export to xls

- (IBAction)emailAction:(id)sender {
	
#ifdef INAPP_VERSION	
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!app.isProduct2Purchased)
    {
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: kAlertHeader
                              message: kAlertMessage
                              delegate:nil
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
	
	[picker setSubject:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_SUBJECT", @"")];
	
	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:@""];
    NSArray *toRecipients = [NSArray arrayWithObjects:[GlobalFunctions getDefaultEmail], nil];
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
    // rykosoft: March fix, bug 2: changed allowLossyConversion: from YES to NO
	NSString *csvContent = [self formCVSContent];

    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;
    NSString *htmlContent = [self formHTMLContent];
    NSString * pdfHeader = [self formPDFContentHeader];
    NSArray * pdfData = [self formPDFContent];
    NSString* fileName = [self getPDFFileName];
    //Delete stored pdf
    [self deleteTemporaryPdf];
    [PDFRenderer drawPDF:fileName forArray:pdfData andHeaderText:pdfHeader andAdjust:YES orientation:PageOrientation_Portrait];
    NSData * myData = nil;
    
    
    myData=[NSData dataWithContentsOfFile:[self getPDFFileName]];
    
    if( myData )
        [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_ATTACHMENT_4", @"")];	
    
    
    
    if( isIOS5 )
    {
        myData = [ Localizator encodedDataFromString: csvContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [picker addAttachmentData:myData mimeType:@"text/csv" fileName:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_ATTACHMENT_0", @"")];        

    	myData = [ Localizator encodedDataFromString: htmlContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [picker addAttachmentData:myData mimeType:@"text/html" fileName:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_ATTACHMENT_3", @"")];	
    }
    else
    {
        myData = [ Localizator encodedDataFromString: csvContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [picker addAttachmentData:myData mimeType:@"text/csv" fileName:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_ATTACHMENT_0", @"")];

    	myData = [ Localizator encodedDataFromString: htmlContent
                                        withEncoding: NSUTF8StringEncoding
                  ];
        if( myData )
            [picker addAttachmentData:myData mimeType:@"text/html" fileName:NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_ATTACHMENT_3", @"")];	
    }
	


	// Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"ACTIVITY_BALANCE_EMAIL_CONTENT", @"");
	[picker setMessageBody:emailBody isHTML:NO];
    picker.navigationBar.tintColor=[UIColor blackColor];

	[self presentModalViewController:picker animated:YES];
    [self dismiss];
    [picker release];
	
}	

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	 
	[self dismissModalViewControllerAnimated:YES];
}

- (void)launchMailAppOnDevice {
	NSString *recipients = @"mailto:?subject=Test Message";
	NSString *body = @"&body=Test message content";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (NSString*)formCVSContent {
	
	if ([reportData count]==0) {
		return @"";
	}	
	    
	NSString *cvsString = @"";
	NSString *cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n", 
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ACTIVITY", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_DATE", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE_MIN", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED_MIN", @""),
						NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE_MIN", @"")];
	
	cvsString = [cvsString stringByAppendingString:cvsRow];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	Activity *currentActivity = nil;
	int totalApplied = 0;
	for (TimeSheet *timeSheet in reportData) {
		if (([timeSheet.activity.flatMode boolValue])&&([timeSheet.flatTime intValue]==-1)) {
			continue;
		} else if ((![timeSheet.activity.flatMode boolValue])&&(([timeSheet.startTime intValue]==-1)||([timeSheet.endTime intValue]==-1)||([timeSheet.breakTime intValue]==-1))) {
			continue;
		}	
		
		if ((![timeSheet.activity isEqual:currentActivity])&&(currentActivity)) {

			//Edited By Meghan
            NSString *cvsRow;
            /*
			if(totalApplied < 0)
            {
                cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
                          NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                          [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                          @"",
                          [self convertPeriodToString:totalApplied],
                          [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                          [currentActivity.allowance floatValue] * 60,
                          totalApplied,
                          ([currentActivity.allowance floatValue]*60 + totalApplied)];
            }
            else
            {
                cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
                          NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                          [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                          @"",
                          [self convertPeriodToString:totalApplied],
                          [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                          [currentActivity.allowance floatValue] * 60,
                          totalApplied,
                          ([currentActivity.allowance floatValue]*60 - totalApplied)];
            }
            */
            cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
                      NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                      [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                      @"",
                      [self convertPeriodToString:totalApplied],
                      [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                      [currentActivity.allowance floatValue] * 60,
                      totalApplied,
                      ([currentActivity.allowance floatValue]*60 - totalApplied)];

//            //NSLog(@"CSVROW : %@",cvsRow);
			cvsString = [cvsString stringByAppendingString:cvsRow];
			
			totalApplied = 0;
		}		
		
		int currentApplied = 0;
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                currentApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                currentApplied = [timeSheet.flatTime intValue];
            }
            */
            currentApplied = [timeSheet.flatTime intValue];
		}
        else
        {
			currentApplied = [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	
		cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\"\n", 
				  [timeSheet.activity isEqual:currentActivity]?@"\"\"":timeSheet.activity.activityTitle, 
				  @"", 
				  [dateFormatter stringFromDate:timeSheet.schedule.scheduleDate], 
				  [self convertPeriodToString:currentApplied], 
				  @"",
				  0,
				  currentApplied,
				  0];
		cvsString = [cvsString stringByAppendingString:cvsRow];
		
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                totalApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                totalApplied += [timeSheet.flatTime intValue];
            }
            */
            totalApplied += [timeSheet.flatTime intValue];
		}
        else
        {
			totalApplied += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	
		
		if (currentActivity)
        {
			[currentActivity release];
		}	
		currentActivity = [timeSheet.activity retain];
	}
	
    /*
	if(totalApplied < 0)
    {
        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
                  NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
                  [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
                  @"", //Date
                  [self convertPeriodToString:totalApplied], //Applied
                  [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
                  [currentActivity.allowance floatValue]*60, //Allowance (min)
                  totalApplied, //Applied (min)
                  ([currentActivity.allowance floatValue]*60 + totalApplied)]; //BAlance (min)
    }
    else
    {
        cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
                  NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
                  [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
                  @"", //Date
                  [self convertPeriodToString:totalApplied], //Applied
                  [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
                  [currentActivity.allowance floatValue]*60, //Allowance (min)
                  totalApplied, //Applied (min)
                  ([currentActivity.allowance floatValue]*60 - totalApplied)]; //BAlance (min)
    }
    */
    cvsRow = [NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%0.0f\",\"%d\",\"%0.0f\"\n",
              NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
              [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
              @"", //Date
              [self convertPeriodToString:totalApplied], //Applied
              [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
              [currentActivity.allowance floatValue]*60, //Allowance (min)
              totalApplied, //Applied (min)
              ([currentActivity.allowance floatValue]*60 - totalApplied)]; //BAlance (min)
    
	cvsString = [cvsString stringByAppendingString:cvsRow];
//	//NSLog(@"CSV : %@",cvsString);
	[dateFormatter release];	

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

    NSString * htmlString =
    [NSString stringWithFormat:@"%@     %@",userName,companyName];
    return htmlString;

    
}
- (NSArray*)formPDFContent 
{
    NSArray* headers = [NSArray arrayWithObjects:
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ACTIVITY", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_DATE", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE_MIN", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED_MIN", @""),
                        NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE_MIN", @""), nil];
    
    
	NSMutableArray *array=[[[NSMutableArray alloc]initWithCapacity:1000] autorelease];
    
    [array addObject:headers];
    
	
            
         
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
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
	Activity *currentActivity = nil;
	int totalApplied = 0;
	for (TimeSheet *timeSheet in reportData) {
		if (([timeSheet.activity.flatMode boolValue])&&([timeSheet.flatTime intValue]==-1)) {
			continue;
		} else if ((![timeSheet.activity.flatMode boolValue])&&(([timeSheet.startTime intValue]==-1)||([timeSheet.endTime intValue]==-1)||([timeSheet.breakTime intValue]==-1))) {
			continue;
		}	
		
		if ((![timeSheet.activity isEqual:currentActivity])&&(currentActivity))
        {
            NSArray* item;
            /*
            if(totalApplied < 0)
            {
                item = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
                        [NSString stringWithFormat:@"%@",[self convertPeriodToString:[currentActivity.allowance floatValue] * 60]],
                        [NSString stringWithFormat:@"%@",@""],
                        [NSString stringWithFormat:@"%@",[self convertPeriodToString:totalApplied]],
                        [NSString stringWithFormat:@"%@",  [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
                        [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue] * 60],
                        [NSString stringWithFormat:@"%d",totalApplied],
                        [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 + totalApplied)], nil];
            }
            else
            {
                item = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
                        [NSString stringWithFormat:@"%@",[self convertPeriodToString:[currentActivity.allowance floatValue] * 60]],
                        [NSString stringWithFormat:@"%@",@""],
                        [NSString stringWithFormat:@"%@",[self convertPeriodToString:totalApplied]],
                        [NSString stringWithFormat:@"%@",  [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
                        [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue] * 60],
                        [NSString stringWithFormat:@"%d",totalApplied],
                        [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 - totalApplied)], nil];
            }
            */
            
            item = [NSArray arrayWithObjects:
                    [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
                    [NSString stringWithFormat:@"%@",[self convertPeriodToString:[currentActivity.allowance floatValue] * 60]],
                    [NSString stringWithFormat:@"%@",@""],
                    [NSString stringWithFormat:@"%@",[self convertPeriodToString:totalApplied]],
                    [NSString stringWithFormat:@"%@",  [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
                    [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue] * 60],
                    [NSString stringWithFormat:@"%d",totalApplied],
                    [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 - totalApplied)], nil];
            [array addObject:item];
            			
			totalApplied = 0;
		}		
		
		int currentApplied = 0;
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                currentApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                currentApplied = [timeSheet.flatTime intValue];
            }
            */
            currentApplied = [timeSheet.flatTime intValue];
		}
        else
        {
			currentApplied = [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	
        
        NSArray* item = [NSArray arrayWithObjects:
                         [NSString stringWithFormat:@"%@",  [timeSheet.activity isEqual:currentActivity]?@"\"\"":timeSheet.activity.activityTitle], 
                         [NSString stringWithFormat:@"%@", @""],
                         [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:timeSheet.schedule.scheduleDate]],
                         [NSString stringWithFormat:@"%@",  [self convertPeriodToString:currentApplied]],
                         [NSString stringWithFormat:@""],
                         [NSString stringWithFormat:@"%d",0],
                         [NSString stringWithFormat:@"%d",currentApplied],
                         [NSString stringWithFormat:@"%d", 0 ], nil];
        [array addObject:item];
        
        
		
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                totalApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                totalApplied += [timeSheet.flatTime intValue];
            }
            */
            totalApplied += [timeSheet.flatTime intValue];
		}
        else
        {
			totalApplied += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	
		
		if (currentActivity) {
			[currentActivity release];
		}	
		currentActivity = [timeSheet.activity retain];
	}
    
    NSArray* item;
    /*
    if(totalApplied < 0)
    {
        item = [NSArray arrayWithObjects:
                [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
                [NSString stringWithFormat:@"%@", [self convertPeriodToString:[currentActivity.allowance floatValue]*60]],
                [NSString stringWithFormat:@"%@",  @""],
                [NSString stringWithFormat:@"%@", [self convertPeriodToString:totalApplied]],
                [NSString stringWithFormat:@"%@",   [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
                [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue]*60],
                [NSString stringWithFormat:@"%d",totalApplied],
                [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 + totalApplied) ], nil];
    }
    else
    {
        item = [NSArray arrayWithObjects:
                [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
                [NSString stringWithFormat:@"%@", [self convertPeriodToString:[currentActivity.allowance floatValue]*60]],
                [NSString stringWithFormat:@"%@",  @""],
                [NSString stringWithFormat:@"%@", [self convertPeriodToString:totalApplied]],
                [NSString stringWithFormat:@"%@",   [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
                [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue]*60],
                [NSString stringWithFormat:@"%d",totalApplied],
                [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 - totalApplied) ], nil];
    }
    */
    item = [NSArray arrayWithObjects:
            [NSString stringWithFormat:@"%@", NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @"")],
            [NSString stringWithFormat:@"%@", [self convertPeriodToString:[currentActivity.allowance floatValue]*60]],
            [NSString stringWithFormat:@"%@",  @""],
            [NSString stringWithFormat:@"%@", [self convertPeriodToString:totalApplied]],
            [NSString stringWithFormat:@"%@",   [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)]],
            [NSString stringWithFormat:@"%0.0f",[currentActivity.allowance floatValue]*60],
            [NSString stringWithFormat:@"%d",totalApplied],
            [NSString stringWithFormat:@"%0.0f",  ([currentActivity.allowance floatValue]*60 - totalApplied) ], nil];
    
    [array addObject:item];
    
	[dateFormatter release];	

	return array;						
}	

- (NSString*)formHTMLContent 
{	
	if ([reportData count]==0)
    {
		return @"";
	}	

    BOOL isIOS5 = [[[UIDevice currentDevice] systemVersion] intValue] == 5;

    NSString * htmlString = 
        [ NSString stringWithFormat: 
            @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=%@\"></head><body><table border=\"1\">",
            isIOS5 ? [ Localizator charsetForActiveLanguage ] : @"utf-8"
         ];
    
	NSString *htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>\n",
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ACTIVITY", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_DATE", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_ALLOWANCE_MIN", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_APPLIED_MIN", @""),
                         NSLocalizedString(@"ACTIVITY_BALANCE_HEADER_BALANCE_MIN", @"")];
	
    htmlString = [htmlString stringByAppendingString:
                  [NSString stringWithFormat:
                   @"<tr><td>%@</td><td>%@</td></tr>\n",
                   userName, companyName]];
    
	htmlString = [htmlString stringByAppendingString:htmlRow];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
   // [dateFormatter setDateFormat:@"dd/MM/YY"];
	
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
	Activity *currentActivity = nil;
	int totalApplied = 0;
	for (TimeSheet *timeSheet in reportData)
    {
		if (([timeSheet.activity.flatMode boolValue])&&([timeSheet.flatTime intValue]==-1))
        {
			continue;
		}
        else if ((![timeSheet.activity.flatMode boolValue])&&(([timeSheet.startTime intValue]==-1)||([timeSheet.endTime intValue]==-1)||([timeSheet.breakTime intValue]==-1)))
        {
			continue;
		}
		
		if ((![timeSheet.activity isEqual:currentActivity])&&(currentActivity))
        {
            NSString *htmlRow;
            /*
			if(totalApplied < 0)
            {
                htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
                                     NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                                     [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                                     @"",
                                     [self convertPeriodToString:totalApplied],
                                     [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                                     [currentActivity.allowance floatValue] * 60,
                                     totalApplied,
                                     ([currentActivity.allowance floatValue]*60 + totalApplied)];
            }
            else
            {
                htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
                                     NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                                     [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                                     @"",
                                     [self convertPeriodToString:totalApplied],
                                     [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                                     [currentActivity.allowance floatValue] * 60,
                                     totalApplied,
                                     ([currentActivity.allowance floatValue]*60 - totalApplied)];
            }
            
            */
            
            htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
                       NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""),
                       [self convertPeriodToString:[currentActivity.allowance floatValue] * 60],
                       @"",
                       [self convertPeriodToString:totalApplied],
                       [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)],
                       [currentActivity.allowance floatValue] * 60,
                       totalApplied,
                       ([currentActivity.allowance floatValue]*60 - totalApplied)];
            
			htmlString = [htmlString stringByAppendingString:htmlRow];
			
			totalApplied = 0;
		}
		
		int currentApplied = 0;
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                currentApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                currentApplied = [timeSheet.flatTime intValue];
            }
            */
            currentApplied = [timeSheet.flatTime intValue];
		}
        else
        {
			currentApplied = [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}
		htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%d</td><td>%d</td><td>%d</td></tr>\n", 
                   [timeSheet.activity isEqual:currentActivity]?@"\"\"":timeSheet.activity.activityTitle, 
                   @"", 
                   [dateFormatter stringFromDate:timeSheet.schedule.scheduleDate], 
                   [self convertPeriodToString:currentApplied], 
                   @"",
                   0,
                   currentApplied,
                   0];
		htmlString = [htmlString stringByAppendingString:htmlRow];
		
		if ([timeSheet.activity.flatMode boolValue])
        {
            /*
            if(timeSheet.activity.overtimeReduce.boolValue)
            {
                totalApplied -= [timeSheet.flatTime intValue];
            }
            else
            {
                totalApplied += [timeSheet.flatTime intValue];
            }
            */
            totalApplied += [timeSheet.flatTime intValue];
		}
        else
        {
			totalApplied += [timeSheet.endTime intValue] - [timeSheet.startTime intValue] - [timeSheet.breakTime intValue];
		}	
		
		if (currentActivity) {
			[currentActivity release];
		}	
		currentActivity = [timeSheet.activity retain];
	}
	/*
	if(totalApplied < 0)
    {
        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
                   NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
                   [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
                   @"", //Date
                   [self convertPeriodToString:totalApplied], //Applied
                   [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
                   [currentActivity.allowance floatValue]*60, //Allowance (min)
                   totalApplied, //Applied (min)
                   ([currentActivity.allowance floatValue]*60 + totalApplied)]; //BAlance (min)
    }
    else
    {
        htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
                   NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
                   [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
                   @"", //Date
                   [self convertPeriodToString:totalApplied], //Applied
                   [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
                   [currentActivity.allowance floatValue]*60, //Allowance (min)
                   totalApplied, //Applied (min)
                   ([currentActivity.allowance floatValue]*60 - totalApplied)]; //BAlance (min)
    }
    */
    
    htmlRow = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%0.0f</td><td>%d</td><td>%0.0f</td></tr>\n",
               NSLocalizedString(@"ACTIVITY_BALANCE_TOTAL", @""), //Activity
               [self convertPeriodToString:[currentActivity.allowance floatValue]*60], //Allowance (hrs)
               @"", //Date
               [self convertPeriodToString:totalApplied], //Applied
               [self convertPeriodToString:([currentActivity.allowance floatValue]*60 - totalApplied)], //Balance
               [currentActivity.allowance floatValue]*60, //Allowance (min)
               totalApplied, //Applied (min)
               ([currentActivity.allowance floatValue]*60 - totalApplied)]; //BAlance (min)
    
    
	htmlString = [htmlString stringByAppendingString:htmlRow];
	[dateFormatter release];	
    
    htmlString = [ htmlString stringByAppendingString: @"</table></html></body>" ];

	return htmlString;
}

- (NSString*) convertPeriodToString:(int)period
{
    
	int hours = floor(period/60.0);
	int minutes = period - hours * 60;
    
    CGFloat floatHours = hours;
    CGFloat floatMinutes = minutes;
    
    CGFloat decimalHours = floatHours + (floatMinutes/60);
    
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    
    if(timeStyle != decimalHours)
    {
        if (minutes < 10)
        {
            return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
        }
        else
        {
            return [NSString stringWithFormat:@"%d:%d", hours, minutes];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%0.2f", decimalHours];
    }
}

#pragma mark -
#pragma mark Show Methods Sample

- (void)show
{
	[SVProgressHUD show];
}

- (void)showWithStatus:(NSString *) status
{
	[SVProgressHUD showWithStatus:status];
}


#pragma mark -
#pragma mark Dismiss Methods Sample

- (void)dismiss
{
	[SVProgressHUD dismiss];
}

-(void) viewWillDisAppear:(BOOL)animated
{
    [self dismiss];
}

@end

