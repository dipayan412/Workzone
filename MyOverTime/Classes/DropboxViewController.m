//
//  DropboxViewController.m
//  MyOvertime
//
//  Created by Ashif on 5/30/13.
//
//

#import "DropboxViewController.h"
#import "GlobalFunctions.h"
#import "MyOvertimeAppDelegate.h"
#import "Localizator.h"
#import "DropboxFilesViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DropboxViewController ()

@end

@implementation DropboxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Dropbox";
    
    lastBackupLabel.textAlignment = UITextAlignmentLeft;
    
    
    NSInteger monday=[self getValueForDay:2];
    NSInteger tuesday=[self getValueForDay:3];
    NSInteger wednesday=[self getValueForDay:4];
    NSInteger thursday=[self getValueForDay:5];
    NSInteger friday=[self getValueForDay:6];
    NSInteger saturday=[self getValueForDay:7];
    NSInteger sunday=[self getValueForDay:1];
    
    mondayCheckbox.selected=(monday==1)?YES:NO;
    tuesdayCheckbox.selected=(tuesday==1)?YES:NO;
    wednesdayCheckbox.selected=(wednesday==1)?YES:NO;
    thursdayCheckbox.selected=(thursday==1)?YES:NO;
    fridayCheckbox.selected=(friday==1)?YES:NO;
    saturdayCheckbox.selected=(saturday==1)?YES:NO;
    sundayCheckbox.selected=(sunday==1)?YES:NO;
    
    /*
    if([GlobalFunctions isDropboxEnabled])
    {       
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchDropBoxFiles];
        });
    }
     */
}

-(void)setDropbpxButtonTitle
{
    if([GlobalFunctions isDropboxEnabled])
    {
        [linkDropboxButton setTitle:NSLocalizedString(@"UNLINK_DB", nil) forState:UIControlStateNormal];
    }
    else
    {
        [linkDropboxButton setTitle:NSLocalizedString(@"LINK_DB", nil) forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!stylePerformed)
    {
        stylePerformed = YES;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(5, 4, self.view.bounds.size.width - 10, self.view.bounds.size.height - 8)];
        [containerView.layer setCornerRadius:7.0f];
        [containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [containerView.layer setBorderWidth:1.0f];
        
        containerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        [self.view addSubview:containerView];
        [self.view sendSubviewToBack:containerView];
        [containerView release];
        
        
        UIView *scheduleContainer = [[UIView alloc] initWithFrame:CGRectMake(10, lastBackupLabel.frame.origin.y + lastBackupLabel.frame.size.height + 3, self.view.bounds.size.width - 20, 100)];
        CGRect frame = scheduleContainer.frame;
        
        frame.size.height = (sundayCheckbox.frame.origin.y + sundayCheckbox.frame.size.height) - scheduleContainer.frame.origin.y;
        scheduleContainer.frame = frame;
        
        [scheduleContainer.layer setCornerRadius:7.0f];
        [scheduleContainer.layer setBorderColor:[UIColor grayColor].CGColor];
        [scheduleContainer.layer setBorderWidth:1.0f];
        
        scheduleContainer.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.7f];
        [self.view addSubview:scheduleContainer];
        [self.view sendSubviewToBack:scheduleContainer];
        [scheduleContainer release];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
    NSDictionary * settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	if (([[settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage))
    {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [settingsDictionary release];
    
    [self setDropbpxButtonTitle];
    [self showLastBackupDate];
}

-(void)showLastBackupDate
{
    if([GlobalFunctions getLastBackUpDate])
    {
        TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
        
        NSDateFormatter *fromatter = [[NSDateFormatter alloc] init];
        [fromatter setTimeStyle:NSDateFormatterNoStyle];
        [fromatter setDateStyle:NSDateFormatterShortStyle];
        [fromatter setTimeZone:[NSTimeZone systemTimeZone]];
        [ fromatter setLocale: [NSLocale currentLocale]];
        NSString *dateformat = [fromatter dateFormat]; //M/d/yy
        
        if ([[fromatter stringFromDate:[GlobalFunctions getLastBackUpDate]] rangeOfString:@"yy"].location == NSNotFound)
        {
            NSString *twoDigitYearFormat = [[fromatter dateFormat] stringByReplacingOccurrencesOfString:@"yyyy" withString:@"yy"];
            [fromatter setDateFormat:twoDigitYearFormat];
        }
        
        if(timeStyle == StyleAmPm)
        {
            //        [dateFormatter setDateFormat:@"MM-dd-yyy hh:mm:ss a"];
            [fromatter setDateFormat:[NSString stringWithFormat:@"%@ hh:mm:ss a", dateformat]];
        }
        else
        {
            [fromatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss", dateformat]];
            //        [dateFormatter setDateFormat:@"MM-dd-yyy HH:mm:ss"];
        }
        
        NSString *cDate = [fromatter stringFromDate:[GlobalFunctions getLastBackUpDate]];
        
        NSArray *nameArr = [cDate componentsSeparatedByString:@" "];
        NSString *amPM = [nameArr lastObject];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        if(timeStyle == StyleAmPm)
        {
            [timeFormatter setDateFormat:@"a"];
            NSString *timeStr = [timeFormatter stringFromDate:[NSDate date]];
            if([timeStr isEqualToString:@"AM"])
            {
                cDate = [cDate stringByReplacingOccurrencesOfString:amPM withString:NSLocalizedString(@"LOCAL_AM", nil)];
            }
            else
            {
                cDate = [cDate stringByReplacingOccurrencesOfString:amPM withString:NSLocalizedString(@"LOCAL_PM", nil)];
            }
        }
    
        lastBackupLabel.text = cDate;
    }
    else
    {
        lastBackupLabel.text = NSLocalizedString(@"DB_LABEL_TITLE", nil);
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleAction:(id)sender
{
    if([GlobalFunctions isDropboxEnabled])
    {
        UIButton *button=(id)sender;
        if (button.selected)
        {
            button.selected=NO;
            [self saveValue:button.tag forState:2];
        }
        else
        {
            button.selected=YES;
            [self saveValue:button.tag forState:1];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"LOGIN_ALERT", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)linkDropbox:(id)sender
{
    if(![GlobalFunctions isDropboxEnabled])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxDidLogin) name:kDropboxDidLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxFailedLogin) name:kDropboxFailedLoginNotification object:nil];
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DB_ALERT_HEADING", nil) message:NSLocalizedString(@"DB_ALERT_MSG", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"DB_ALERT_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"DB_ALERT_YES", nil), nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)createBackup:(id)sender
{
    if ([GlobalFunctions isDropboxEnabled])
    {
        TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
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
        
        // testing
        
        NSString *fileName;
        if (bugData != nil)
        {
            fileName=[NSString stringWithFormat:@"%@.motd",attachmentName];
        }
        
        NSLog(@"fileName %@", fileName);
        
//        DBPath *folderPath = [[DBPath root] childPath:NSLocalizedString(@"TITLE_BACKUP", nil)];
        DBPath *folderPath = [[DBPath root] childPath:kDropboxFolderName];
        
        DBPath *dataFilePath = [folderPath childPath:fileName];
        
        DBFile *dataFile = [[DBFilesystem sharedFilesystem] createFile:dataFilePath error:nil];
        
        if (dataFile)
        {
            [dataFile writeData:bugData error:nil];
            [GlobalFunctions setLastBackUpDate:[NSDate date]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DB_ALERT_DONE_TITLE", nil) message:NSLocalizedString(@"DB_ALERT_DONE_MSG", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else
        {
            NSLog(@"error");
            if([[DBFilesystem sharedFilesystem] deletePath:dataFilePath error:nil])
            {
                dataFile = [[DBFilesystem sharedFilesystem] createFile:dataFilePath error:nil];
                [dataFile writeData:bugData error:nil];
                [GlobalFunctions setLastBackUpDate:[NSDate date]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DB_ALERT_DONE_TITLE", nil) message:NSLocalizedString(@"DB_ALERT_DONE_MSG", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)  message:NSLocalizedString(@"DB_BACKUP_ERROR", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
        }
        
        [self showLastBackupDate];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)  message:NSLocalizedString(@"CREATE_LOGIN_ERROR", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)restoreBackup:(id)sender
{
    if([GlobalFunctions isDropboxEnabled])
    {
        DropboxFilesViewController *fileVC = [[DropboxFilesViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:fileVC animated:YES];
        [fileVC release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)  message:NSLocalizedString(@"RESTORE_LOGIN_ERROR", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore" message:@"Please go to dropbox app folder location and open in application to restore." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
     */
}

-(NSInteger)getValueForDay:(NSInteger)day
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key=[NSString stringWithFormat:@"DAY_VAL_%d",day];
    NSInteger dayValue= [[userDefaults valueForKey:key] intValue];
    return dayValue;
}

-(void ) saveValue:(NSInteger ) day forState:(NSInteger)state
{
    //Not needed
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key=[NSString stringWithFormat:@"DAY_VAL_%d",day];
    [userDefaults setValue:[NSNumber numberWithInt:state] forKey:key];
    [userDefaults synchronize];
}

-(void)dropboxDidLogin
{
    NSLog(@"loggedin");
    
    [GlobalFunctions setDropboxEnabled:YES];
    
    [self setDropbpxButtonTitle];
}

-(void)dropboxFailedLogin
{
    NSLog(@"Login failed");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)  message:NSLocalizedString(@"DB_LOGIN_FAILED", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    [GlobalFunctions setDropboxEnabled:NO];
    [self setDropbpxButtonTitle];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        DBAccount *acc = [[DBAccountManager sharedManager] linkedAccount];
        [acc unlink];
        
        [GlobalFunctions setDropboxEnabled:NO];
        
        [self setDropbpxButtonTitle];
    }
}

@end
