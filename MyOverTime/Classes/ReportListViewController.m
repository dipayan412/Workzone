//
//  ReportListViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "ReportListViewController.h"
#import "BalanceReportViewController.h"
#import "ActivityReportViewController.h"
#import "ActivityBalanceViewController.h"
#import "StatisticsReportController.h"
#import "Schedule.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "MyOvertimeAppDelegate.h"
#import "CPPickerView.h"
#import "CPPickerViewCell.h"

#import "GraphicalReportController.h"
#import "CalendarViewController.h"

#import "ActivitySelectionViewController.h"
#import "GlobalFunctions.h"
#import "ActivityGraphViewController.h"

// rykosoft: March fix, new feature 1
#define DATE_FROM_1     @"DateMyOvertimeFrom"
#define DATE_FROM_2     @"DateActivityReportFrom"

@interface ReportListViewController()

@property(nonatomic, retain) NSDate * startingDate;
@property(nonatomic, retain) NSDate * endingDate;

@end


@implementation ReportListViewController

@synthesize selectedActivities;
@synthesize activityReportCell;

@synthesize lblActivityReport;
@synthesize btnActivityReportFrom;
@synthesize btnActivityReportTo;
@synthesize myOvertimeCell;
@synthesize lblFrom1;
@synthesize lblTo1;
@synthesize lblMyOvertime;
@synthesize btnMyOvertimeReportFrom;
@synthesize btnMyOvertimeReportTo;
@synthesize managedObjectContext;
@synthesize datePickerView;
@synthesize datePicker;
@synthesize balanceReportCell;
@synthesize userName,companyName;
@synthesize graphicalReportCell,normalReportCell;
@synthesize dateSelectionCell;
@synthesize dateFromToCell;
@synthesize pickerActivity;
@synthesize buttonFrom,buttonTo,labelDummy;
@synthesize startingDate;
@synthesize endingDate;
@synthesize activityGraphReportCell;

#pragma mark -
#pragma mark View lifecycle

-(void)getActivities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEnabled == %@", [NSNumber numberWithBool:YES]];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subSequence" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil)
    {
		// Handle the error.
	}
	self.pickerActivity = mutableFetchResults;
	[mutableFetchResults release];
	[request release];
}

- (void)reloadFetchedResults:(NSNotification*)note
{
    NSLog(@"Underlying data changed ... refreshing!");
    
    [self fetchReportData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFetchedResults:)
                                                 name:@"iCloudDataChanged"
                                               object:[[UIApplication sharedApplication] delegate]];

    NSInteger start=10;
    NSInteger start2=140;

    buttonFrom.frame=CGRectMake(start,40,120,36);
    buttonTo.frame=CGRectMake(start2,40,120,36);
    lblFrom1.frame=CGRectMake(start,45,120,21);
    lblTo1.frame=CGRectMake(start2,45,120,21);

    [buttonFrom setTitle:@"" forState:UIControlStateNormal];
    [buttonFrom setTitle:@"" forState:UIControlStateHighlighted];
    [buttonTo setTitle:@"" forState:UIControlStateNormal];
    [buttonTo setTitle:@"" forState:UIControlStateHighlighted];
       

    labelDummy.frame=CGRectMake(135-7,45,10,21);
    labelDummy.textAlignment = UITextAlignmentCenter;
    labelDummy.text = @"-";
    lblFrom1.textAlignment = UITextAlignmentCenter;
    lblTo1.textAlignment=UITextAlignmentCenter;

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
//	backButton.title = NSLocalizedString(@"REPORT_LIST_BACK_BUTTON", @"");
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
    
    selectActivityLabel.text = NSLocalizedString(@"TITLE_ALL",nil);
    fromReportDetails = NO;
}

- (void) fetchReportData{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	    
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scheduleDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
    NSMutableArray *reminderArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
  
    self.startingDate = [ [ NSUserDefaults standardUserDefaults ] objectForKey: DATE_FROM_1 ];
    self.endingDate = [ [ NSUserDefaults standardUserDefaults ] objectForKey: DATE_FROM_2 ];
    
    if (!self.startingDate)
    {
        self.startingDate = [NSDate date];
    }

    if (!self.endingDate)
    {
        self.endingDate = [NSDate date];
    }
    
    if ([[dateFormatter stringFromDate:self.startingDate] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }

	NSError *error = nil;
	NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (mutableFetchResults == nil || [mutableFetchResults count] == 0)
    {
        lblFrom1.text = self.startingDate ? [dateFormatter stringFromDate: self.startingDate ] : [dateFormatter stringFromDate:[NSDate date]];

        lblTo1.text = [dateFormatter stringFromDate:[NSDate date]];
        [datePicker setMinimumDate:[NSDate date]];
	}
    else
    {    
        if ([mutableFetchResults count]>0)
        {
            for (Schedule *curSchedule in mutableFetchResults)
            {
                BOOL scheduleFilled = NO;
                
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
                
                if (scheduleFilled)
                {
                    [reminderArray addObject:curSchedule];
                }
            }
        }
        
        if ([reminderArray count]>0)
        {
            Schedule *schedule = [reminderArray objectAtIndex:0];
            

            lblFrom1.text = self.startingDate ? [dateFormatter stringFromDate: self.startingDate ] : [dateFormatter stringFromDate:schedule.scheduleDate];

            lblTo1.text = [dateFormatter stringFromDate:[NSDate date]];

            [datePicker setMinimumDate:schedule.scheduleDate];
        }
        else
        {
            lblFrom1.text = self.startingDate ? [dateFormatter stringFromDate: self.startingDate ] : [dateFormatter stringFromDate:[NSDate date]];
            
            lblTo1.text = [dateFormatter stringFromDate:[NSDate date]];
            [datePicker setMinimumDate:[NSDate date]];

        }
        
        [datePicker setMinimumDate: nil ];        
        [datePicker setMaximumDate: nil ];
        
	}
	[request release];
}	

-(void) getDefaultData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
    
    NSString *user= [settingsDictionary objectForKey:@"userName"];
    NSString *company=[settingsDictionary objectForKey:@"companyName"];
    self.userName =[[NSMutableString alloc]initWithString:user ];
    self.companyName =[[NSMutableString alloc]initWithString: company];
    if (!userName) {
        userName=[NSString stringWithFormat:@""];
    }
    if (!companyName) {
        companyName=[NSString stringWithFormat:@""];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lblActivityReport.text = NSLocalizedString(@"TITLE_ACTIVITY_REPORT",nil);
    
    if(fromReportDetails)
    {
        selectActivityLabel.text = NSLocalizedString(@"TITLE_ALL",nil);
        fromReportDetails = NO;
        self.selectedActivities = nil;
    }
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkIfDataExist];
    
    [self getActivities];
    [self.tableView reloadData];
    pickerActivityIndex=0;
    
    [app checkProductStatus];
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
    
    [self fetchReportData];
    [self getDefaultData];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row > 0)
    {
        return 54;
    }
    return 79;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

-(void) setMinimumDateForRange :(NSString *)currentDateString
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSDate *maxDate;
    NSDate *toDate = [dateFormatter dateFromString:currentDateString];
    NSDate *fromDate;
    if (btnTag == 2)
    {
        fromDate = [dateFormatter dateFromString:lblTo1.text];
    }
    else if (btnTag == 4)
    {
        fromDate = [dateFormatter dateFromString:lblTo1.text];
    }
    if ([fromDate compare:toDate] == NSOrderedAscending)
    {
        maxDate = fromDate;
    }
    else
    {
        maxDate = toDate;
    }
}

-(IBAction) showDateView:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    
    NSString *dateString;
    if (sender.tag==3)
    {
        dateString = lblFrom1.text ;
    }
    else if (sender.tag==4)
    {
        dateString = lblTo1.text;
    }
    
    CalendarViewController *calVC = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil withTabBar:YES];
    calVC.calendarDelegate = self;
    
    calVC.setDate = [dateFormatter dateFromString:dateString];
    
    [self addChildViewController:calVC];                 // 1
    CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
    initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	calVC.view.frame = initialRect;
    
    [self.view addSubview:calVC.view];
    [calVC didMoveToParentViewController:self];          // 3
    
    
    btnTag = sender.tag;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
                         calVC.view.frame = CGRectMake([[UIScreen mainScreen] applicationFrame].origin.x, [[UIScreen mainScreen] applicationFrame].origin.y - 20, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
                         self.navigationController.tabBarController.tabBar.hidden = YES;
					 }
					 completion:^(BOOL finished) {
					 }];
}

-(void)delegateDidSelectDate:(NSDate *)_d fromController:(UIViewController *)controller
{
    NSLog(@"_d %@", _d);
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
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    if ([[dateFormatter stringFromDate:_d] rangeOfString:@"yy"].location == NSNotFound)
    {
        NSString *twoDigitYearFormat = [[dateFormatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
        [dateFormatter setDateFormat:twoDigitYearFormat];
    }
    
    NSString *dateString = [dateFormatter stringFromDate:_d];
    NSLog(@"dateString %@", dateString);
    
    if (btnTag==3)
    {
        self.startingDate = _d;
        [lblFrom1 setText:dateString];
        [ [ NSUserDefaults standardUserDefaults ] setObject: _d
                                                     forKey: DATE_FROM_1
         ];
    }
    else if (btnTag==4)
    {
        self.endingDate = _d;
        [lblTo1 setText:dateString];
        [ [ NSUserDefaults standardUserDefaults ] setObject: _d
                                                     forKey: DATE_FROM_2
         ];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];    
	}
    
    if (indexPath.row==0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0)
    {
        dateFromToCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return dateFromToCell;
	}
    
    if (indexPath.row == 1)
    {
        myOvertimeCell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        return myOvertimeCell;
	}
    if (indexPath.row == 2)
    {
        activityReportCell.selectionStyle=UITableViewCellSelectionStyleGray;
        return activityReportCell;
	}
    
    if (indexPath.row == 3)
    {
        normalReportCell.selectionStyle=UITableViewCellSelectionStyleGray;

        return normalReportCell;
	}
    
    if (indexPath.row == 4)
    {
        graphicalReportCell.selectionStyle=UITableViewCellSelectionStyleGray;

        return graphicalReportCell;
	}
    else if (indexPath.row == 5)
    {
        if( balanceReportCell != nil )
        {
            balanceReportCell.selectionStyle=UITableViewCellSelectionStyleGray;

            return balanceReportCell;            
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(@"REPORT_LIST_ACTIVITY_BALANCE_REPORT", @"");
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
        }
	}
    else if(indexPath.row == 6)
    {
        activityGraphReportCell.selectionStyle = UITableViewCellSelectionStyleGray;
        return activityGraphReportCell;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
		BalanceReportViewController *balanceReport = [[BalanceReportViewController alloc] initWithNibName:@"BalanceReportViewController" bundle:[NSBundle mainBundle]];
		balanceReport.managedObjectContext = managedObjectContext;
        balanceReport.beginDate = lblFrom1.text;
        balanceReport.endDate = lblTo1.text;
        balanceReport.userName=userName;
        balanceReport.companyName=companyName;
		[self.navigationController pushViewController:balanceReport animated:YES];
		[balanceReport release];
	}
    else if (indexPath.row == 2)
    {
		ActivityReportViewController *activityReport = [[ActivityReportViewController alloc] initWithNibName:@"ActivityReportViewController" bundle:[NSBundle mainBundle]];
		activityReport.managedObjectContext = managedObjectContext;
        activityReport.beginDate = lblFrom1.text;
        activityReport.endDate = lblTo1.text;
        activityReport.userName=userName;
        activityReport.companyName=companyName;
        NSString *filter=nil;
        
        if (self.selectedActivities.count > 1)
        {
            activityReport.selectedActivities = self.selectedActivities;
            
            NSMutableString *activitiesName = [[NSMutableString alloc] init];
            
            for(int i=0; i<self.selectedActivities.count; i++)
            {
                ActivityModified *mod = [self.selectedActivities objectAtIndex:i];
                if(i == self.selectedActivities.count-1)
                {
                    [activitiesName appendFormat:@"%@",mod.activity.activityTitle];
                }
                else
                {
                    [activitiesName appendFormat:@"%@,",mod.activity.activityTitle];
                }
            }
            filter = kMultiSelectString;
            activityReport.filter=filter;
            activityReport.multiFiler = activitiesName;
        }
        else
        {
            ActivityModified *mod = [self.selectedActivities objectAtIndex:0];
            if(mod.activity == nil)
            {
                filter = NSLocalizedString(@"TITLE_ALL",nil);
                activityReport.filter=filter;
            }
            else
            {
                activityReport.selectedActivities = self.selectedActivities;
                filter = mod.activity.activityTitle;
                activityReport.filter=filter;
            }
        }

        fromReportDetails = YES;
		[self.navigationController pushViewController:activityReport animated:YES];
		[activityReport release];
	}
    else if (indexPath.row == 3)
    {
        StatisticsReportController *controller=[[[StatisticsReportController alloc]init] autorelease];
        controller.managedObjectContext = managedObjectContext;
        controller.startingDate = self.startingDate;
        controller.endingDate = self.endingDate;
        controller.userName = userName;
        controller.companyName = companyName;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if (indexPath.row == 4)
    {
        GraphicalReportController *controller=[[[GraphicalReportController alloc]init] autorelease];
        controller.managedObjectContext = managedObjectContext;
        controller.startingDate = self.startingDate;
        controller.endingDate = self.endingDate;
        controller.userName = userName;
        controller.companyName = companyName;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 5)
    {
		ActivityBalanceViewController *activityBalanceReport = [[ActivityBalanceViewController alloc] initWithNibName:@"ActivityBalanceViewController" bundle:[NSBundle mainBundle]];
		activityBalanceReport.managedObjectContext = managedObjectContext;
        activityBalanceReport.userName=userName;
        activityBalanceReport.companyName=companyName;
		[self.navigationController pushViewController:activityBalanceReport animated:YES];
		[activityBalanceReport release];
	}
    else if (indexPath.row == 6)
    {
        ActivityGraphViewController *vc = [[ActivityGraphViewController alloc] initWithNibName:@"ActivityGraphViewController" bundle:nil];
        
        //TODO: set date values
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

-(IBAction)selectActivitiesForReport:(id)sender
{
    ActivitySelectionViewController *selectionVC = [[ActivitySelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    selectionVC.activitySelectionDelegate = self;
    selectionVC.activitiesArray = self.pickerActivity;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectionVC];
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController presentModalViewController:navController animated:YES];
}

#pragma mark Activity Selection Delegate

-(void)delegateDidSelectActivities:(NSArray *)_selectedActivities
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    self.selectedActivities = _selectedActivities;
    if(self.selectedActivities.count > 1)
    {
        selectActivityLabel.text = kMultiSelectString;
    }
    else
    {
        ActivityModified *mod = [self.selectedActivities objectAtIndex:0];
        if(mod.activity == nil)
        {
          selectActivityLabel.text = NSLocalizedString(@"TITLE_ALL",nil);;
        }
        else
        {
            selectActivityLabel.text = mod.activity.activityTitle;
        }
    }
    
    selectActivityLabel.minimumFontSize = 8.0f;
    selectActivityLabel.adjustsFontSizeToFitWidth = YES;
}
    
-(void)delegateDidCancelSelection
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    [self setBtnMyOvertimeReportTo:nil];
    [self setBtnMyOvertimeReportFrom:nil];
    [self setBtnActivityReportTo:nil];
    [self setBtnActivityReportFrom:nil];
    [self setLblMyOvertime:nil];
    [self setLblActivityReport:nil];
    [self setDatePicker:nil];
    [self setLblTo1:nil];
    [self setLblFrom1:nil];
    [self setMyOvertimeCell:nil];
    [self setBalanceReportCell:nil];
    //[self setLblTo2:nil];
   // [self setLblFrom2:nil];
    [self setActivityReportCell:nil];
    [self setDatePickerView:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc
{
	[managedObjectContext release];
    [datePickerView release];
    [activityReportCell release];
    [balanceReportCell release];
    [myOvertimeCell release];
    [lblFrom1 release];
    [lblTo1 release];
    [datePicker release];
    [lblActivityReport release];
    [lblMyOvertime release];
    [btnActivityReportFrom release];
    [btnActivityReportTo release];
    [btnMyOvertimeReportFrom release];
    [btnMyOvertimeReportTo release];
    [super dealloc];
}

#pragma mark - CPPickerViewCell DataSource

- (NSInteger)numberOfItemsInPickerViewAtIndexPath:(NSIndexPath *)pickerPath
{
    return [pickerActivity count]+1;
}

- (NSString *)pickerViewAtIndexPath:(NSIndexPath *)pickerPath titleForItem:(NSInteger)item
{
    if (item == 0)
    {
        return NSLocalizedString(@"TITLE_ALL", nil);
    }
    
    Activity *activity = [pickerActivity objectAtIndex:(item - 1)];
    return activity.activityTitle;
}

#pragma mark - CPPickerViewCell Delegate

- (void)pickerViewAtIndexPath:(NSIndexPath *)pickerPath didSelectItem:(NSInteger)item
{
    pickerActivityIndex=item;
}

@end

