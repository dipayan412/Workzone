//
//  SettingsViewController.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ActivitiesViewController.h"
#import "HelpViewController.h"
#import "UserIdentificationViewController.h"
#import "ResetViewController.h"
#import "MyOvertimeAppDelegate.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "DropboxViewController.h"

#import "Localizator.h"
#import "BackUpViewController.h"
#import "SetWorkDaysViewController.h"
#import "MyTemplatesViewController.h"
#import "StaticConstants.h"
#import "GlobalFunctions.h"
#import "FAQViewController.h"
#import "Activity.h"


#define docPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SettingsViewController()
{
    NSMutableArray *hoursArray;
}

@property (nonatomic, retain) NSArray *activities;
@property (nonatomic, retain) Settings *settings;

@end

@interface SettingsViewController(PrivateMethods)

- (NSString*) convertPeriodToString:(NSNumber*)period;
- (NSNumber*) convertPickerDataToPeriodFromView:(UIPickerView*)pickerView;
- (NSArray*) getInitialPickerValuesFromPeriod:(NSNumber*)period;

- (void) bindDataToProperties;

@end

@implementation SettingsViewController

@synthesize activities;
@synthesize settings;

@synthesize timeStyleCell, timeDialIntervalCell, reminderCell, defineActivitiesCell, firstCheckinCell, hoursToDaysCell;

@synthesize settingsDictionary;

@synthesize amDayMode, roundDayMode;

@synthesize interval1Min, interval5Min, interval15Min,interval3Min;

@synthesize reminderSwitch;

@synthesize managedObjectContext;
@synthesize filename;

@synthesize activitySelectView, activitySelectPicker, activitiesPickerData, hoursToDaysSelectTimeView, hoursToDaysSelectTimePicker;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activitySelectPicker.dataSource = self;
    activitySelectPicker.delegate = self;
    
    [showDayTemplateButton setTag:301];
    [showMyTemplateButton setTag:302];
    [showCopyLastSheetButton setTag:303];
    [showFirstCheckinButton setTag:304];
    
    showDayTemplateButton.selected = [GlobalFunctions getShowButtonsOptions1];
    showMyTemplateButton.selected = [GlobalFunctions getShowButtonsOptions2];
    showCopyLastSheetButton.selected = [GlobalFunctions getShowButtonsOptions3];
    showFirstCheckinButton.selected = [GlobalFunctions getShowButtonsOptions4];

    [ interval1Min setTag: 1 ];
    [ interval5Min setTag: 5 ];
    [ interval15Min setTag: 15 ];
    [ interval3Min setTag: 3 ];
	
	UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[helpButton addTarget:self action:@selector(showHelpWindow:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
	self.navigationItem.rightBarButtonItem = helpBarButton;
	[helpBarButton release];

    showButtonOptionsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    hoursArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<23;i++)
    {
        [hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchActivities];
    [self fetchSettings];
    
    
    NSInteger index = NSNotFound;
    if (self.activities && settings.checkinActivity)
    {
        index = [self.activities indexOfObject:settings.checkinActivity];
    }
    
    if (index != NSNotFound)
    {
        Activity *act = [self.activities objectAtIndex:index];
        checkinActivityLabel.text = act.activityTitle;
    }
    
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app checkIfDataExist];
	
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
    
    amDayMode.selected =
    roundDayMode.selected =
    decimalButton.selected = NO;
    
    TimeStyle style = [GlobalFunctions getTimeStyle];
    switch (style)
    {
        case StyleAmPm:
            amDayMode.selected = YES;
            break;
            
        case Style24Mode:
            roundDayMode.selected = YES;
            break;
            
        case StyleDecimal:
            decimalButton.selected = YES;
            break;
            
        default:
            break;
    }
	
    NSInteger timeDialInterval = [ self safeTimeInterval ];

    interval1Min.selected = timeDialInterval == 1;
    interval5Min.selected = timeDialInterval == 5;
    interval15Min.selected = timeDialInterval == 15;
    interval3Min.selected = timeDialInterval == 3;

	reminderSwitch.on = [[self.settingsDictionary objectForKey:@"reminderMode"] boolValue];
    
    hoursToDaysTimeLabel.text = [NSString stringWithFormat:@"%02d",[GlobalFunctions hoursToDays]];
}

- ( NSInteger ) safeTimeInterval
{
    NSInteger timeInterval = [ [ self.settingsDictionary objectForKey: @"timeDialInterval" ] intValue ];
    
    if( ( timeInterval != 1 ) && ( timeInterval != 5 ) && ( timeInterval != 15 ) && ( timeInterval != 3 ) )
        timeInterval = 1;
    
    return timeInterval;
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated 
{	
	[super viewWillDisappear:animated];
	[ self saveAllSettings ];
}


- ( void ) saveAllSettings
{
    [self bindDataToProperties];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	[self.settingsDictionary writeToFile:path atomically:YES];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
    {
        return 70.0;
	}
    else if (indexPath.row == 1)
    {
        return 95.0;
	}
    else if (indexPath.row == 2)
    {
        return 70.0;
	}
    else if (indexPath.row == 3)
    {
        return 70.0;
	}
    else if (indexPath.row == 4)
    {
        return 164.0;
	}
    else if (indexPath.row == 5)
    {
        return 80.0;
	}
    return 414.0;
}	

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
    {
        return timeDialIntervalCell;
	}
    else if (indexPath.row == 1)
    {
        return hoursToDaysCell;
    }
    else if (indexPath.row == 2)
    {
        return firstCheckinCell;
	}
    else if (indexPath.row == 3)
    {
        return timeStyleCell;
	}
    else if (indexPath.row == 4)
    {
        return showButtonOptionsCell;
	}
    else if (indexPath.row == 5)
    {
        return reminderCell;
	}
    return defineActivitiesCell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(IBAction)dropBoxButtonPressed:(id)sender
{
#ifdef INAPP_VERSION
    MyOvertimeAppDelegate *app= (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
//    /*
    if (!app.isProduct3Purchased)
    {
        [app showDropBoxAlert];
        
        return;
    }
//     */
//    else
//    {
//        DropboxViewController *dropboxVC = [[DropboxViewController alloc] initWithNibName:@"DropboxViewController" bundle:nil];
//        [self.navigationController pushViewController:dropboxVC animated:YES];
//        [dropboxVC release];
//    }
#endif
    
    DropboxViewController *dropboxVC = [[DropboxViewController alloc] initWithNibName:@"DropboxViewController" bundle:nil];
    [self.navigationController pushViewController:dropboxVC animated:YES];
    [dropboxVC release];
}

-(IBAction)setWorkDaysButtonPressed:(id)sender
{
    SetWorkDaysViewController *setVC = [[SetWorkDaysViewController alloc] initWithNibName:@"SetWorkDaysViewController" bundle:nil];
    [self.navigationController pushViewController:setVC animated:YES];
    [setVC release];
}

-(IBAction)myTemplatesButtonPressed:(id)sender
{
    MyTemplatesViewController *templateVC = [[MyTemplatesViewController alloc] initWithNibName:@"MyTemplatesViewController" bundle:nil];
    [self.navigationController pushViewController:templateVC animated:YES];
    [templateVC release];
}

-(IBAction)showButtonsOptionSelection:(id)sender
{
    UIButton *curButton = (UIButton*)sender;
	if (curButton.selected)
    {
		curButton.selected = NO;
	}
    else
    {
		curButton.selected = YES;
	}

    [ self saveAllSettings ];
}

- ( IBAction ) timeDialIntervalCheckboxSelected: ( id ) sender
{
    NSInteger tag = [ sender tag ];
    interval1Min.selected = tag == 1;
    interval5Min.selected = tag == 5;
    interval15Min.selected = tag == 15;
    interval3Min.selected=tag==3;
    [ self.settingsDictionary setObject: [ NSNumber numberWithInt: tag ]
                                 forKey: @"timeDialInterval"
     ];
    [ self saveAllSettings ];
}

- (IBAction) hoursToDaysButtonPressed:(id)sender
{
    CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	hoursToDaysSelectTimeView.frame = initialRect;
	[self.view.window addSubview:hoursToDaysSelectTimeView];
	
	[UIView animateWithDuration:0.3
						  delay:0.0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 hoursToDaysSelectTimeView.frame = [[UIScreen mainScreen] applicationFrame];
					 }
					 completion:^(BOOL finished) {
					 }];
}

- (IBAction) fistCheckingButtonPressed:(id)sender
{
    NSInteger index = NSNotFound;
    if (self.activities && settings.checkinActivity)
    {
        index = [self.activities indexOfObject:settings.checkinActivity];
    }
    
    if (index != NSNotFound)
    {
        [activitySelectPicker selectRow:index inComponent:0 animated:NO];
    }
	
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
    Activity *act = [self.activities objectAtIndex:[activitySelectPicker selectedRowInComponent:0]];
    settings.checkinActivity = act;
    
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error = nil;
    [context save:&error];
    
    checkinActivityLabel.text = act.activityTitle;
    
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

- (IBAction) hideHoursToDaysSelectTimeView:(id)sender
{
    //hoursToDaysTimeLabel.text =
    
    int h = [hoursToDaysSelectTimePicker selectedRowInComponent:0];
    
    hoursToDaysTimeLabel.text = [NSString stringWithFormat:@"%02d",h];
    
    [GlobalFunctions setHoursToDays:h];
    
    //NSString *
    
	CGRect initialRect = [[UIScreen mainScreen] applicationFrame];
	initialRect.origin.x = 0;
	initialRect.origin.y = initialRect.size.height;
	
	[UIView animateWithDuration:0.3
						  delay:0.0
					 	options:UIViewAnimationCurveLinear
					 animations:^{
						 hoursToDaysSelectTimeView.frame = initialRect;
					 }
					 completion:^(BOOL finished) {
						 [hoursToDaysSelectTimeView removeFromSuperview];
					 }];
}

- (IBAction) dayModeCheckboxSelected:(id)sender
{
    TimeStyle style;
    
    roundDayMode.selected = NO;
    amDayMode.selected = NO;
    decimalButton.selected = NO;
    
    UIButton *curButton = (UIButton*)sender;
	if (curButton.selected)
    {
		curButton.selected = NO;
	}
    else
    {
		curButton.selected = YES;
	}
    
    if (amDayMode.selected)
    {
        style = StyleAmPm;
	}
    else if (roundDayMode.selected)
    {
        style = Style24Mode;
	}
    else
    {
        style = StyleDecimal;
    }

    [GlobalFunctions setTimeStyle:style];
}

- (IBAction)resetTimesheets:(id)sender
{
    ResetViewController *controller=[[[ResetViewController alloc]init] autorelease];
    controller.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSData *)exportToNSData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Schedules.sqlite"];
    
	NSError *error;
    NSString *attachmentPath = [docPath stringByAppendingPathComponent:@"attachment"];
    //NSLog(@"Attachment : %@",attachmentPath);
    NSFileManager *fileman = [NSFileManager defaultManager];
    if ([fileman fileExistsAtPath:attachmentPath]) {
        NSError *removeError = nil;
        [fileman removeItemAtPath:attachmentPath error:&removeError];
        if (removeError) {
            //NSLog(@"Remove error : %@",[removeError localizedDescription]);
        }
    }
    NSError *createdirError = nil;
    [fileman createDirectoryAtPath:attachmentPath withIntermediateDirectories:YES attributes:nil error:&createdirError];
    if (createdirError) {
        //NSLog(@"CreateDirectory Error : %@",[createdirError localizedDescription]);
    }
    NSError *copyError = nil;
    [fileman copyItemAtPath:path toPath:[attachmentPath stringByAppendingPathComponent:@"Schedules.sqlite"] error:&copyError];
    
    if (copyError) {
        //NSLog(@"Copy Error : %@",[copyError localizedDescription]);
    }
    
    NSURL *url = [NSURL fileURLWithPath:attachmentPath];
	//NSLog(@"URL : %@",url);
	NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithURL:url options:0 error:&error] autorelease];
    if (dirWrapper == nil) {
        //NSLog(@"Error creating directory wrapper: %@", error.localizedDescription);
        return nil;
    }   
    
	//[self saveImages];
    NSData *dirData = [dirWrapper serializedRepresentation];
    
    NSData *gzData = [dirData gzipDeflate];    
    //converts data from private folder and returns it.. 
   // [[gzData gzipInflate] writeToFile:[docPath stringByAppendingPathComponent:@"Attachment.motd"] atomically:YES];
    return gzData;
	
}

- (IBAction)backup:(id)sender
{    
    BackUpViewController *controller=[[[BackUpViewController alloc]init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Text Field Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [filename resignFirstResponder];
    return YES;
}

#pragma mark AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == 1) {
//        if (buttonIndex == 0) {
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateStyle:NSDateFormatterLongStyle];    
//            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//            [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
//            NSString *cDate = [dateFormatter stringFromDate:[[NSDate alloc] init]];
//            
//            NSString *attachmentName = [NSString stringWithFormat:@"MyOvertime_%@_%@",filename.text,cDate];
//            NSString *messageBody = NSLocalizedString(@"EXPORT_EMAIL_BODY", @"");
//            
//            ScaryBugDoc *bugDoc = [[ScaryBugDoc alloc]initWithTitle:@"MyOvertimeBackup"];
//            bugDoc.data.title = attachmentName;
//            //NSLog(@"bugDoc title : %@",bugDoc.data.title);
//            //[bugDoc saveData];
//            NSData *bugData = [bugDoc testEmail];
//            //  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            if (bugData != nil) {
//                MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
//                [picker setSubject:[attachmentName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
//                [picker addAttachmentData:bugData mimeType:@"application/myovertime" fileName:[NSString stringWithFormat:@"%@.motd",attachmentName]];
//                [picker setToRecipients:[NSArray array]];
//                [picker setMessageBody:messageBody isHTML:NO];
//                [picker setMailComposeDelegate:self];
//                [self presentModalViewController:picker animated:YES];                    
//            }
//            
//            
//        }
//    } 
}



#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
    NSString *privatedoc = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *removeprivatedir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:privatedoc])
    {
        [[NSFileManager defaultManager] removeItemAtPath:privatedoc error:&removeprivatedir];
    }
}

#pragma mark -
#pragma mark Button actions

- (IBAction) showHelpWindow:(id)sender {
	FAQViewController *helpViewController = [[FAQViewController alloc] initWithNibName:@"FAQViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:helpViewController animated:YES];
	[helpViewController release];
}	

- (IBAction) openDefineActivitiesWindow:(id)sender {
	//NSLog(@"openDefineActivitiesWindow start");
	ActivitiesViewController *activitiesViewController = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesViewController" bundle:[NSBundle mainBundle]];
	//NSLog(@"openDefineActivitiesWindow point #100");
	activitiesViewController.managedObjectContext = managedObjectContext;
	//NSLog(@"openDefineActivitiesWindow point #105");
	[self.navigationController pushViewController:activitiesViewController animated:YES];
	//NSLog(@"openDefineActivitiesWindow point #110");
	[activitiesViewController release];
	//NSLog(@"openDefineActivitiesWindow stop");
}

-(IBAction) chooseBackground:(id) sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"BACKGROUND_ACTION_SHEET_TITLE", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"BACKGROUND_ACTION_SHEET_CANCEL_BUTTON", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"BACKGROUND_ACTION_SHEET_DEFAULT_BCKGRD_BUTTON", @""),NSLocalizedString(@"BACKGROUND_ACTION_SHEET_CHOOSE_PHOTOS_BUTTON", @""),nil];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

- (IBAction) userIdentication:(id)sender
{
	UserIdentificationViewController *userViewController = [[UserIdentificationViewController alloc] initWithNibName:@"UserIdentificationViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:userViewController animated:YES];
	[userViewController release];
}	

#pragma mark -
#pragma mark Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
    {
		[self.settingsDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"defaultBackground"];
		
		UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_bckgrnd.png"]];
		self.tableView.backgroundView = myImageView;
		[myImageView release];	
	} else if (buttonIndex == 1) {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:picker animated:YES];
	}	
}	

#pragma mark -
#pragma mark Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	
	[self.settingsDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"defaultBackground"];
	
	//[info objectForKey:@"UIImagePickerControllerOriginalImage"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];	
	
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0)];
	[imageData writeToFile:path atomically:YES];
	
	UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
	self.tableView.backgroundView = myImageView;
	[myImageView release];
	
}

#pragma mark -
#pragma mark Bind data to properties
- (void) bindDataToProperties
{
    [GlobalFunctions setShowButtonsOptions1:showDayTemplateButton.selected];
    [GlobalFunctions setShowButtonsOptions2:showMyTemplateButton.selected];
    [GlobalFunctions setShowButtonsOptions3:showCopyLastSheetButton.selected];
    [GlobalFunctions setShowButtonsOptions4:showFirstCheckinButton.selected];
    
    /*
	NSNumber *dayMode;
	
	if (roundDayMode.selected)
    {
		dayMode = [NSNumber numberWithBool:YES];
	}
    else if (amDayMode.selected)
    {
		dayMode = [NSNumber numberWithBool:NO];
	}	
	
	[self.settingsDictionary setObject:dayMode forKey:@"is24hoursMode"];
     */
    
    NSNumber *timeDialInterval;
    if(interval5Min.selected)
        timeDialInterval = [ NSNumber numberWithInt: 5 ];
    else if(interval15Min.selected)
        timeDialInterval = [ NSNumber numberWithInt: 15 ];
    else if(interval3Min.selected)
        timeDialInterval = [ NSNumber numberWithInt: 3 ];
    else // anyway use default value here to prevent errors
        timeDialInterval = [ NSNumber numberWithInt: 1 ];
    
	[self.settingsDictionary setObject:timeDialInterval forKey:@"timeDialInterval"];
    	
	[self.settingsDictionary setObject:[NSNumber numberWithBool:reminderSwitch.on] forKey:@"reminderMode"];
	
	[self.settingsDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isModified"];	
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == hoursToDaysSelectTimePicker)
    {
        return hoursArray.count;
    }
    return self.activities.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == hoursToDaysSelectTimePicker)
    {
        return [hoursArray objectAtIndex:row];
    }
    Activity *act = [self.activities objectAtIndex:row];
    return act.activityTitle;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(pickerView == hoursToDaysSelectTimePicker)
    {
        return 100;
    }
    return 300;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(pickerView == hoursToDaysSelectTimePicker)
    {
        NSString *str = [hoursArray objectAtIndex:row];
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        return label;
    }
    Activity *act = [self.activities objectAtIndex:row];
    UILabel *label = [[UILabel alloc] init];
    label.text = act.activityTitle;
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    return label;
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
}

- (void)dealloc
{
	[amDayMode release];
	[roundDayMode release];
	
	[timeStyleCell release];
	[reminderCell release];
	[defineActivitiesCell release];
	
	[settingsDictionary release];
	
	[reminderSwitch release];
	
	[managedObjectContext release];
	
    [super dealloc];
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

-(void)fetchActivities
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
    
    self.activities = [activitiesResults copy];
}

@end

