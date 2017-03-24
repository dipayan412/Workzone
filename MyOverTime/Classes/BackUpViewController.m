//
//  BackUpViewController.m
//  MyOvertime
//
//  Created by Prashant Choudhary on 11/17/12.
//
//

#import "BackUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Validation.h"
#import <MessageUI/MessageUI.h>
#import "Localizator.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "GlobalFunctions.h"
#import "ExportImportHandler.h"

@interface BackUpViewController ()

@end

@implementation BackUpViewController

@synthesize settingsDictionary;

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
    
//    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(5, 134, self.view.frame.size.width - 10, 1)];
//    separatorLine.backgroundColor = [UIColor lightGrayColor];
////    [self.view addSubview:separatorLine];
    
    self.title=NSLocalizedString(@"TITLE_BACKUP",nil);
    
    email = [GlobalFunctions getDefaultEmail];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"background.jpg"];
	
	UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
	
	path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	self.settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	    
	if (([[self.settingsDictionary objectForKey:@"defaultBackground"] boolValue])||(!backgroundImage)) {
		backgroundImage = [UIImage imageNamed:@"default_bckgrnd.png"];
	}
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    warningView.text = NSLocalizedString(@"BACKUP_TEXT_MESSAGE", nil);
    
    warningView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    warningView.layer.borderWidth = 1.0f;
    warningView.layer.cornerRadius = 7.0f;
    warningView.editable = NO;
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
        
        CGRect frame = warningView.frame;
        frame.origin.y = forAndroidButton.frame.origin.y + forAndroidButton.frame.size.height + 40;
        frame.size.height = 140;
        warningView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)forAndroidButtonAction:(id)sender
{
    UIButton *button=(id)sender;
    if (button.selected)
    {
        button.selected=NO;
    }
    else
    {
        button.selected=YES;
    }
}

-(IBAction)makeBackup:(id)sender
{
    [self doBackUp];
}

-(void)doBackUp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [ dateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
    NSString *cDate = [dateFormatter stringFromDate:[[NSDate alloc] init]];
    
    NSString *attachmentName = [NSString stringWithFormat:@"MyOvertime_%@_%@",NSLocalizedString(@"BACKUP_FILENAME", nil),cDate];
    NSString *messageBody = NSLocalizedString(@"EXPORT_EMAIL_BODY", @"");
    
    if(!forAndroidButton.selected)
    {
        ScaryBugDoc *bugDoc = [[ScaryBugDoc alloc]initWithTitle:@"MyOvertimeBackup"];
        bugDoc.data.title = NSLocalizedString(@"BACKUP_FILENAME", nil);
        //NSLog(@"bugDoc title : %@",bugDoc.data.title);
        //[bugDoc saveData];
        NSData *bugData = [bugDoc testEmail];
        //  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (bugData != nil)
        {
            MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
            [picker setSubject:[attachmentName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
            [picker addAttachmentData:bugData mimeType:@"application/myovertime" fileName:[NSString stringWithFormat:@"%@.motd",attachmentName]];
            [picker setToRecipients:[NSArray arrayWithObjects:email, nil]];
            [picker setMessageBody:messageBody isHTML:NO];
            [picker setMailComposeDelegate:self];
            [self presentModalViewController:picker animated:YES];
        }
    }
    else
    {
        ExportImportHandler *handler = [ExportImportHandler getInstance];
        [handler showLoadingView:YES];
        [handler prepareDataToExport];
        NSData *backUpData = [handler exportDataBase];
        
        if (backUpData != nil)
        {
            [handler showLoadingView:NO];
            
            MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init] autorelease];
            [picker setSubject:[attachmentName stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
            [picker addAttachmentData:backUpData mimeType:@"application/myovertime" fileName:[NSString stringWithFormat:@"%@.motad",attachmentName]];
            [picker setToRecipients:[NSArray arrayWithObjects:email, nil]];
            [picker setMessageBody:messageBody isHTML:NO];
            [picker setMailComposeDelegate:self];
            [self presentModalViewController:picker animated:YES];
        }
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
