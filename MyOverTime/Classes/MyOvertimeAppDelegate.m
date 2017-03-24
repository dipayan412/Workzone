//
//  Project1AppDelegate.m
//  MyOvertime
//
//  Created by Eugene Ivanov on 6/22/11.
//  Copyright 2011 __AtmosphereStudio__. All rights reserved.
//

#import "MyOvertimeAppDelegate.h"
#import "RootViewController.h"
#import "GlobalFunctions.h"
#import "SettingsViewController.h"
#import "ReportListViewController.h"
#import "Settings.h"
#import "SettingsDayTemplate.h"
#import "MyTemplate.h"
#import "Schedule.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "NSData+CocoaDevUsersAdditions.h"
#import "StaticConstants.h"
#import "Macros.h"
#import "ExportImportHandler.h"
#import "SubscriptionProduct.h"

#define docPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation MyOvertimeAppDelegate

@synthesize window, tabBarController;
@synthesize scheduleViewController, settingsViewController, reportListViewController;
@synthesize isProduct1Purchased,isProduct2Purchased, isProduct3Purchased;
@synthesize canByPassLocalize;
@synthesize localizedArray;
@synthesize firstLoad;
@synthesize fromAlert;
@synthesize daysRminderAlert;

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (void)handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", url];
    
    if ([urlStr rangeOfString:@"motd"].location != NSNotFound)
    {   
        ScaryBugDoc *newDoc = [[[ScaryBugDoc alloc] init] autorelease];
        if ([newDoc importFromURL:url])
        {
            //NSLog(@"Successfully Imported");
        }
    }
    if ([urlStr rangeOfString:@"motad"].location != NSNotFound)
    {
        ExportImportHandler *handler = [ExportImportHandler getInstance];
        [handler importFromBackup:url];
    }
}


-(void) checkProductStatus
{
    SubscriptionProduct *product=[purchaseManager.productArray objectAtIndex:0];
    product.isPurchased = [GlobalFunctions getProductStatus:product.productId];
    if (product.isPurchased)
    {
        isProduct1Purchased=YES;
    }
    else
    {
        isProduct1Purchased=NO;
    }
    
    SubscriptionProduct *product2=[purchaseManager.productArray objectAtIndex:1];
    product2.isPurchased=[GlobalFunctions getProductStatus:product2.productId];
    if (product2.isPurchased)
    {
        isProduct2Purchased=YES;
    }
    else
    {
        isProduct2Purchased=NO;
    }
    
    SubscriptionProduct *product3=[purchaseManager.productArray objectAtIndex:2];
    product3.isPurchased=[GlobalFunctions getProductStatus:product3.productId];
    if (product3.isPurchased)
    {
        isProduct3Purchased=YES;
    }
    else
    {
        isProduct3Purchased=NO;
    }
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GlobalFunctions setLaunchCount:([GlobalFunctions launchCount] + 1)];
    
    [self checkDaysState];
    localizedArray=[[NSMutableArray alloc]initWithObjects:@"en_GB",@"", nil];
    
/*if ([localizedArray containsObject:string]) {
 NSString *string=[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];

    }*/
    //NSLog(@"strnggg %@",string);
    
#ifdef INAPP_VERSION	
    purchaseManager= [InAppPurchaseManager getInstance];
    [purchaseManager createInAppProducts];
    [self checkProductStatus];
#endif

    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    //NSLog(@"URL %@: %@",url,launchOptions);
    if (url != nil && [url isFileURL])
    {
        [self handleOpenURL:url];                
    } 
  
    [ tabBarController setDelegate: self ];
	
    NSManagedObjectContext *context = [self managedObjectContext];
	scheduleViewController.managedObjectContext = context;
	settingsViewController.managedObjectContext = context;
	reportListViewController.managedObjectContext = context;
		
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Properties.plist"];
	
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	if (!properties)
    {
		properties = [[NSMutableDictionary alloc] init];
        
		[properties setObject:[NSNumber numberWithInt:480] forKey:@"offset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"SunOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"MonOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"TueOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"WedOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"ThuOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"FriOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"SatOffset"];
        
		NSMutableArray *workingDays = [[NSMutableArray alloc] init];
		[workingDays addObject:[NSNumber numberWithInt:2]];
		[workingDays addObject:[NSNumber numberWithInt:3]];
		[workingDays addObject:[NSNumber numberWithInt:4]];
		[workingDays addObject:[NSNumber numberWithInt:5]];
		[workingDays addObject:[NSNumber numberWithInt:6]];
		[properties setObject:workingDays forKey:@"workingDays"];
		[workingDays release];
        if([NSLocalizedString(@"LOCAL_AM", nil) isEqualToString:@"am"])
        {
            [properties setObject:[NSNumber numberWithBool:NO] forKey:@"is24hoursMode"];
        }
        else
        {
            [properties setObject:[NSNumber numberWithBool:YES] forKey:@"is24hoursMode"];
        }
		[properties setObject:[NSNumber numberWithInt:1] forKey:@"timeDialInterval"];
		
		[properties setObject:@"" forKey:@"userName"];
		[properties setObject:@"" forKey:@"companyName"];
		
		[properties setObject:[NSNumber numberWithBool:YES] forKey:@"reminderMode"];
		[properties setObject:[NSNumber numberWithBool:YES] forKey:@"defaultBackground"];
		
		[properties setObject:[NSDate date] forKey:@"liteFirstDate"];
		[properties setObject:[NSNumber numberWithBool:NO] forKey:@"unlockCalendar"];
        
		[properties writeToFile:path atomically:YES];
		[properties release];
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if ([mutableFetchResults count] == 0)
    {
		Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_IN_OFFICE", @"");
		activity.flatMode = [NSNumber numberWithBool:NO];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:0];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];

		activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_WORK_FROM_HOME", @"");
		activity.flatMode = [NSNumber numberWithBool:NO];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:1];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_COMPANY_HOLIDAY", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:4];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
		activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TRAVEL", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:2];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_UNPAID_LEAVE", @"");
		activity.flatMode = [NSNumber numberWithBool:NO];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:NO];
		activity.subSequence = [NSNumber numberWithInt:10];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
				
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_COMPENSATION", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:NO];		
		activity.subSequence = [NSNumber numberWithInt:11];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];

        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_OVERTIME_PAID", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:10];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:YES];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];

        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_FLEXITIME_BURNED", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:NO];
		activity.subSequence = [NSNumber numberWithInt:5];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_1", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:3];
        activity.useDefault = [NSNumber numberWithBool:YES];
        activity.offsetValue = [NSNumber numberWithInt:1200];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
		// Commit the change.
		if (![managedObjectContext save:&error])
        {
			// Handle the error.
		}
		
		[tabBarController setSelectedIndex:2];
	}
    else
    {
        
    }
	
	// new default Activities for version 2.1
	properties = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSString *cVersion = [properties objectForKey:@"cVersion"];
    NSLog(@"version %@", cVersion);

//	if (![cVersion isEqual:@"2.1"])
    if (cVersion.floatValue < 2.2 && ![cVersion isEqual:@"2.1"])
    {
		int startIndex = 8;
		if ([mutableFetchResults count] == 0)
        {
			startIndex = 2;
		} else
        {
			startIndex = [mutableFetchResults count];
		}	
		
		Activity *activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_VACATION_2011", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];		
		activity.subSequence = [NSNumber numberWithInt:13];
		activity.allowance = [NSNumber numberWithInt:160];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		startIndex++;
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_VACATION_2012", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];		
		activity.subSequence = [NSNumber numberWithInt:14];
		activity.allowance = [NSNumber numberWithInt:160];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		startIndex++;
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_HOLIDAY_2011", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];		
		activity.subSequence = [NSNumber numberWithInt:15];
		activity.allowance = [NSNumber numberWithInt:160];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		startIndex++;
		
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_HOLIDAY_2012", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];		
		activity.subSequence = [NSNumber numberWithInt:16];
		activity.allowance = [NSNumber numberWithInt:160];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
	
		activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_OUT_SICK", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];		
		activity.subSequence = [NSNumber numberWithInt:12];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:NO];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
		
		if (![managedObjectContext save:&error])
        {
			// Handle the error.
		}
        
		[properties setObject:@"2.1" forKey:@"cVersion"];
//        [properties setObject:@"2.2" forKey:@"cVersion"];
		[properties writeToFile:path atomically:YES];
//        cVersion = [NSString stringWithFormat:@"%f", 2.1];
        cVersion = [NSString stringWithFormat:@"%0.2f", 2.10];
        NSLog(@"cver %@", cVersion);
	}
    
    CGFloat version = [GlobalFunctions getVersionNumber];
    NSLog(@"cVersion %f", version);
//    if (![cVersion isEqual:@"2.3"])
    if (version < 2.3 && [cVersion isEqualToString:@"2.10"])
    {
//		int startIndex = 8;
//		if ([mutableFetchResults count] == 0)
//        {
//			startIndex = 2;
//		} else
//        {
//			startIndex = [mutableFetchResults count];
//		}
		
		Activity *activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_2", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:6];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:YES];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_OVERTIME_PAID2X", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:8];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:YES];
        activity.amount = [NSNumber numberWithFloat:0.0f];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_OVERTIME_PAID1.5", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:NO];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:7];
        activity.useDefault = [NSNumber numberWithBool:NO];
        activity.offsetValue = [NSNumber numberWithInt:480];
        activity.showAmount = [NSNumber numberWithBool:YES];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
        activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_3", @"");
		activity.flatMode = [NSNumber numberWithBool:YES];
        activity.overtimeReduce = [NSNumber numberWithBool:YES];
		activity.isEnabled = [NSNumber numberWithBool:YES];
		activity.estimateMode = [NSNumber numberWithBool:YES];
		activity.subSequence = [NSNumber numberWithInt:9];
        activity.useDefault = [NSNumber numberWithBool:YES];
        activity.offsetValue = [NSNumber numberWithInt:2400];
        activity.showAmount = [NSNumber numberWithBool:YES];
        activity.amount = [NSNumber numberWithFloat:0.0f];
//        activity.identifier = [GlobalFunctions GetUUID];
        
		
		if (![managedObjectContext save:&error])
        {
			// Handle the error.
		}
		
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"offset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"SunOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"MonOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"TueOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"WedOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"ThuOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"FriOffset"];
        [properties setObject:[NSNumber numberWithInt:480] forKey:@"SatOffset"];
        
		[properties setObject:[NSNumber numberWithInt:60] forKey:@"break"];
        
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Sunbreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Monbreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Tuebreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Wedbreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Thubreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Fribreak"];
        [properties setObject:[NSNumber numberWithInt:60] forKey:@"Satbreak"];
        
        if([NSLocalizedString(@"LOCAL_AM", nil) isEqualToString:@"am"])
        {
            [properties setObject:[NSNumber numberWithBool:NO] forKey:@"is24hoursMode"];
        }
        else
        {
            [properties setObject:[NSNumber numberWithBool:YES] forKey:@"is24hoursMode"];
        }
        
		[properties setObject:@"2.2" forKey:@"cVersion"];
//        [properties setObject:@"2.3" forKey:@"cVersion"];
		[properties writeToFile:path atomically:YES];
//        cVersion = [NSString stringWithFormat:@"%f", 2.2];
        cVersion = [NSString stringWithFormat:@"%f", 2.2];
        
        [GlobalFunctions setVersionNumber:2.2];
	}
    
    if ([GlobalFunctions launchCount] == 1)
    {
        NSArray * langs = [ NSLocale preferredLanguages ];
        
        //    //NSLog( @"preferred locales = %@", langs );
        
        NSString * lang = [ langs count ] ? [ langs objectAtIndex: 0 ] : nil;
        
        if( [ lang isEqualToString: @"en" ] )               // English      (!)
        {
            [GlobalFunctions setTimeStyle:StyleAmPm];
            NSLog(@"english");
        }
        else
        {
            [GlobalFunctions setTimeStyle:Style24Mode];
            NSLog(@"other");
        }
        
        Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
        
        settings.name = @"MyOverTimeSettings";
        
        for(int i = 0; i < 7; i++)
        {
            SettingsDayTemplate *setTemp1 = (SettingsDayTemplate *)[NSEntityDescription insertNewObjectForEntityForName:@"SettingsDayTemplate" inManagedObjectContext:managedObjectContext];
            setTemp1.day = [NSNumber numberWithInt:i];
            setTemp1.templateEnabled = [NSNumber numberWithBool:YES];
    //                setTemp1.identifier = [GlobalFunctions GetUUID];
            
            
            Schedule *temp1Schedule = (Schedule *)[NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
            
    //                temp1Schedule.scheduleDate = [NSDate date];
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:-1];
    //                temp1Schedule.identifier = [GlobalFunctions GetUUID];
    //                setTemp1.scheduleId = temp1Schedule.identifier;
            
            TimeSheet * timeSheet = ( TimeSheet * ) [ NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:-1];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = nil;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            setTemp1.schedule = temp1Schedule;
            
            [settings addSettingsDayTemplatesObject:setTemp1];
        }
        
        [self createMyTemplate];
        
        [self createInitialTimesheet];
        
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Error - %@", error.description);
        }
        
        [properties setObject:@"2.3" forKey:@"cVersion"];
        [properties writeToFile:path atomically:YES];
        cVersion = [NSString stringWithFormat:@"%f", 2.3];
        [GlobalFunctions setVersionNumber:2.3];
    }
    
    properties = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSString *timezoneupdate = [properties objectForKey:@"timezoneupdate"];
	if (![timezoneupdate isEqual:@"1"])
    {
        //Meghan 
        NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
        [request1 setEntity:entity1];
        NSArray *schArray = [[NSArray alloc] init];
        // NSMutableArray *finalDateArray = [[NSMutableArray alloc] init];
        
        NSError *error1 = nil;
        NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:request1 error:&error1];
        if (mutableFetchResults1 == nil)
        {
            // Handle the error.
        } else
        {
            schArray = mutableFetchResults1;
        }
        
        for (Schedule *schedule in schArray)
        {
            // //NSLog(@"Date = %@",[NSDate dateWithTimeIntervalSinceReferenceDate:347756400]);
//            //NSLog(@"TimeInterval %f",[schedule.scheduleDate timeIntervalSinceReferenceDate]);
            NSTimeInterval timeinterval = [schedule.scheduleDate timeIntervalSinceReferenceDate];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeinterval+39600];
            schedule.scheduleDate = date;
            NSError *saveError=nil;
            [managedObjectContext save:&saveError];
            if (saveError)
            {
                //NSLog(@"Save Error : %@",[error localizedDescription]);
            }
//            //NSLog(@"Schedule project 99 : %@ \ndate : %@",schedule.scheduleDate,date);
        }
        
        //Meghan
        
        [properties setObject:@"1" forKey:@"timezoneupdate"];
		[properties writeToFile:path atomically:YES];
    }
    
//  [self.window addSubview:tabBarController.view];
    
    self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
    
    
    daysRminderAlert = [[UIAlertView alloc] initWithTitle:kAlertHeaderProduct2 message:NSLocalizedString(@"PRODUCT_INAPP_MESSAGE2", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"LATER", nil)  otherButtonTitles:NSLocalizedString(@"TAKE_ME_THERE", nil), nil];
    
    emailReportAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PRODUCT_INAPP_HEADER", nil) message:NSLocalizedString(@"PRODUCT_INAPP_MESSAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"LATER", nil) otherButtonTitles:NSLocalizedString(@"TAKE_ME_THERE", nil), nil];
    
    dropBoxAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PRODUCT_INAPP_HEADER3", nil) message:NSLocalizedString(@"PRODUCT_INAPP_MESSAGE3", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"LATER", nil) otherButtonTitles:NSLocalizedString(@"TAKE_ME_THERE", nil), nil];
    
    BOOL isInApp = NO;
    
#ifdef INAPP_VERSION
    
    isInApp = YES;
    
#endif
    
    if(isInApp)
    {
        DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:kDropboxKeyIAP secret:kDropboxSecretIAP];
        [DBAccountManager setSharedManager:accountMgr];
        DBAccount *account = accountMgr.linkedAccount;
        
        if (account)
        {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
            
            [[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:[DBPath root] block:^()
             {
                 dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     
                     //                 [self pullDataFromDropbox];
                     
                 });
             }];
        }
    }
    else
    {
        DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:kDropboxKey secret:kDropboxSecret];
        [DBAccountManager setSharedManager:accountMgr];
        DBAccount *account = accountMgr.linkedAccount;
        
        if (account)
        {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
            
            [[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:[DBPath root] block:^()
             {
                 dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     
                     //                 [self pullDataFromDropbox];
                     
                 });
             }];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", url];
    
    if ([urlStr rangeOfString:@"motd"].location != NSNotFound)
    {
        [self handleOpenURL:url];
        return YES;
    }
    if ([urlStr rangeOfString:@"motad"].location != NSNotFound)
    {
        [self handleOpenURL:url];
        return YES;
    }
    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        
        [GlobalFunctions setDropboxEnabled:YES];
        NSLog(@"App linked successfully!");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxDidLoginNotification object:self userInfo:nil];
        
        return YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxFailedLoginNotification object:self userInfo:nil];
    
    [GlobalFunctions setDropboxEnabled:NO];
    
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", url];
    
    if ([urlStr rangeOfString:@"motd"].location != NSNotFound)
    {
        [self handleOpenURL:url];
        return YES;
    }
    if ([urlStr rangeOfString:@"motad"].location != NSNotFound)
    {
        [self handleOpenURL:url];
        return YES;
    }
    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"App linked successfully!");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxDidLoginNotification object:self userInfo:nil];
        
        [GlobalFunctions setDropboxEnabled:YES];
        
        return YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxFailedLoginNotification object:self userInfo:nil];
    [GlobalFunctions setDropboxEnabled:NO];
    
    return NO;
}

-(void)checkIfDataExist
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSError *err = nil;
    NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults == nil || mutableFetchResults.count < 1)
    {
        [self createSettingsTemplate];
    }
    
    [self createMyTemplate];
    
}

-(void)createSettingsTemplate
{
    Activity *activity = nil;
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"subSequence = %@", [NSNumber numberWithInt:0]];
    
    [req setPredicate:pred];
    
    NSError *err = nil;
    NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
    {
        
    }
    else
    {
        activity = [mutableFetchResults1 objectAtIndex:0];
    }
    
    [req release];
    
    Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    
    settings.name = @"MyOverTimeSettings";
    
    for(int i = 0; i < 7; i++)
    {
        SettingsDayTemplate *setTemp1 = [NSEntityDescription insertNewObjectForEntityForName:@"SettingsDayTemplate" inManagedObjectContext:managedObjectContext];
        setTemp1.day = [NSNumber numberWithInt:i];
        setTemp1.templateEnabled = [NSNumber numberWithBool:YES];
        
        Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
        
        temp1Schedule.scheduleDate = nil;
        temp1Schedule.offset = [NSNumber numberWithInt:-1];
        
        TimeSheet * timeSheet = ( TimeSheet * ) [ NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];

        timeSheet.startTime = [NSNumber numberWithInt:-1];
        timeSheet.endTime = [NSNumber numberWithInt:-1];
        timeSheet.breakTime = [NSNumber numberWithInt:-1];
        timeSheet.flatTime = [NSNumber numberWithInt:-1];
        timeSheet.subSequence = [NSNumber numberWithInt:0];
        timeSheet.comments = nil;
        timeSheet.activity = nil;
        timeSheet.schedule = temp1Schedule;
        timeSheet.amount = [NSNumber numberWithFloat:0.0f];
        
        [temp1Schedule addTimeSheetsObject:timeSheet];
        
        setTemp1.schedule = temp1Schedule;
        
        [settings addSettingsDayTemplatesObject:setTemp1];
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        // Handle the error.
    }
}

-(void)createMyTemplate
{
    NSFetchRequest *templateReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyTemplate" inManagedObjectContext:managedObjectContext];
    [templateReq setEntity:entity];
    
    NSError *err = nil;
    NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:templateReq error:&err];
    int existingTemplate = 0;
    if (mutableFetchResults)
    {
        existingTemplate = mutableFetchResults.count;
    }
    
    Activity *activity = nil;
    
    for(int j = existingTemplate; j < 7; j++)
    {
        MyTemplate *myTemplate1 = [NSEntityDescription insertNewObjectForEntityForName:@"MyTemplate"
                                                                inManagedObjectContext:managedObjectContext];
        
        if(j == 0)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_1", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:0];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                                  inManagedObjectContext: managedObjectContext];
            NSFetchRequest *req = [[NSFetchRequest alloc] init];
            NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
            [req setEntity:ent];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_1", @"")];
            [req setPredicate:pred];
            
            NSError *err = nil;
            NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
            
            if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
            {
                activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
                activity.activityTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_1", @"")];
                
                activity.flatMode = [NSNumber numberWithBool:YES];
                activity.overtimeReduce = [NSNumber numberWithBool:NO];
                activity.isEnabled = [NSNumber numberWithBool:YES];
                activity.estimateMode = [NSNumber numberWithBool:YES];
                activity.subSequence = [NSNumber numberWithInt:3];
                activity.useDefault = [NSNumber numberWithBool:YES];
                activity.offsetValue = [NSNumber numberWithInt:1200];
                activity.showAmount = [NSNumber numberWithBool:NO];
                activity.amount = [NSNumber numberWithFloat:0.0f];
            }
            else
            {
                activity = [mutableFetchResults1 objectAtIndex:0];
            }
            
            [req release];
            
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:1200];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = activity;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 1)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_2", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:0];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                                  inManagedObjectContext: managedObjectContext];
            
            NSFetchRequest *req = [[NSFetchRequest alloc] init];
            NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
            [req setEntity:ent];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_2", @"")];
            
            [req setPredicate:pred];
            
            NSError *err = nil;
            NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
            if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
            {
                activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
                activity.activityTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_2", @"")];
                
                activity.flatMode = [NSNumber numberWithBool:YES];
                activity.overtimeReduce = [NSNumber numberWithBool:NO];
                activity.isEnabled = [NSNumber numberWithBool:YES];
                activity.estimateMode = [NSNumber numberWithBool:YES];
                activity.subSequence = [NSNumber numberWithInt:6];
                activity.useDefault = [NSNumber numberWithBool:NO];
                activity.offsetValue = [NSNumber numberWithInt:480];
                activity.showAmount = [NSNumber numberWithBool:YES];
                activity.amount = [NSNumber numberWithFloat:0.0f];
            }
            else
            {
                activity = [mutableFetchResults1 objectAtIndex:0];
            }
            
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:480];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = activity;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 2)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_3", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:0];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                                  inManagedObjectContext: managedObjectContext];
            
            NSFetchRequest *req = [[NSFetchRequest alloc] init];
            NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
            [req setEntity:ent];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_3", @"")];
            [req setPredicate:pred];
            
            NSError *err = nil;
            NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
            if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
            {
                activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
                activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_3", @"");
                
                activity.flatMode = [NSNumber numberWithBool:YES];
                activity.overtimeReduce = [NSNumber numberWithBool:YES];
                activity.isEnabled = [NSNumber numberWithBool:YES];
                activity.estimateMode = [NSNumber numberWithBool:YES];
                activity.subSequence = [NSNumber numberWithInt:9];
                activity.useDefault = [NSNumber numberWithBool:YES];
                activity.offsetValue = [NSNumber numberWithInt:2400];
                activity.showAmount = [NSNumber numberWithBool:YES];
                activity.amount = [NSNumber numberWithFloat:0.0f];
            }
            else
            {
                activity = nil;
                activity = [mutableFetchResults1 objectAtIndex:0];
            }
            
            [req release];
            
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:2400];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = activity;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 3)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_4", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:480];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                                  inManagedObjectContext: managedObjectContext];
            
            NSFetchRequest *req = [[NSFetchRequest alloc] init];
            NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
            [req setEntity:ent];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_4", @"")];
            [req setPredicate:pred];
            
            NSError *err = nil;
            NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
            if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
            {
                activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
                activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_4", @"");
                
                activity.flatMode = [NSNumber numberWithBool:NO];
                activity.overtimeReduce = [NSNumber numberWithBool:NO];
                activity.isEnabled = [NSNumber numberWithBool:YES];
                activity.estimateMode = [NSNumber numberWithBool:YES];
                activity.subSequence = [NSNumber numberWithInt:0];
                activity.useDefault = [NSNumber numberWithBool:NO];
                activity.offsetValue = [NSNumber numberWithInt:480];
                activity.showAmount = [NSNumber numberWithBool:NO];
                activity.amount = [NSNumber numberWithFloat:0.0f];
            }
            else
            {
                activity = [mutableFetchResults1 objectAtIndex:0];
            }
            
            [req release];
            
            timeSheet.startTime = [NSNumber numberWithInt:480];
            timeSheet.endTime = [NSNumber numberWithInt:1020];
            timeSheet.breakTime = [NSNumber numberWithInt:60];
            timeSheet.flatTime = [NSNumber numberWithInt:-1];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = activity;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 4)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_5", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:480];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                                  inManagedObjectContext: managedObjectContext];
            
            NSFetchRequest *req = [[NSFetchRequest alloc] init];
            NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
            [req setEntity:ent];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_5", @"")];
            [req setPredicate:pred];
            
            NSError *err = nil;
            NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
            if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
            {
                activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
                activity.activityTitle = NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_5", @"");
                
                activity.flatMode = [NSNumber numberWithBool:NO];
                activity.overtimeReduce = [NSNumber numberWithBool:NO];
                activity.isEnabled = [NSNumber numberWithBool:YES];
                activity.estimateMode = [NSNumber numberWithBool:YES];
                activity.subSequence = [NSNumber numberWithInt:0];
                activity.useDefault = [NSNumber numberWithBool:NO];
                activity.offsetValue = [NSNumber numberWithInt:480];
                activity.showAmount = [NSNumber numberWithBool:NO];
                activity.amount = [NSNumber numberWithFloat:0.0f];
            }
            else
            {
                activity = [mutableFetchResults1 objectAtIndex:0];
            }
            
            [req release];
            
            timeSheet.startTime = [NSNumber numberWithInt:840];
            timeSheet.endTime = [NSNumber numberWithInt:1380];
            timeSheet.breakTime = [NSNumber numberWithInt:60];
            timeSheet.flatTime = [NSNumber numberWithInt:-1];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = activity;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 5)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_6", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:0];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
            
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:-1];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = nil;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
        else if (j == 6)
        {
            myTemplate1.templateName = [NSString stringWithFormat:@"%@", NSLocalizedString(@"DEFAULT_TEMPLATE_NAME_7", nil)];
            
            myTemplate1.subSequence = [NSNumber numberWithInt:j];
            
            Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                    inManagedObjectContext:managedObjectContext];
            
            temp1Schedule.scheduleDate = nil;
            temp1Schedule.offset = [NSNumber numberWithInt:0];
            
            TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet" inManagedObjectContext: managedObjectContext];
            
            timeSheet.startTime = [NSNumber numberWithInt:-1];
            timeSheet.endTime = [NSNumber numberWithInt:-1];
            timeSheet.breakTime = [NSNumber numberWithInt:-1];
            timeSheet.flatTime = [NSNumber numberWithInt:-1];
            timeSheet.subSequence = [NSNumber numberWithInt:0];
            timeSheet.comments = nil;
            timeSheet.activity = nil;
            timeSheet.schedule = temp1Schedule;
            timeSheet.amount = [NSNumber numberWithFloat:0.0f];
            
            [temp1Schedule addTimeSheetsObject:timeSheet];
            
            myTemplate1.schedule = temp1Schedule;
        }
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        // Handle the error.
    }
}

-(void)createInitialTimesheet
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
    [req setEntity:ent];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"activityTitle = %@", NSLocalizedString(@"DEFAULT_ACTIVITY_TEMPLATE_1", @"")];
    [req setPredicate:pred];
    
    NSError *err = nil;
    NSArray *mutableFetchResults1 = [managedObjectContext executeFetchRequest:req error:&err];
    if (mutableFetchResults1 == nil || mutableFetchResults1.count < 1)
    {
    }
    else
    {
        Activity *act = [mutableFetchResults1 objectAtIndex:0];
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                  fromDate:[NSDate date]];
        [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
        NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        Schedule *temp1Schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule"
                                                                inManagedObjectContext:managedObjectContext];
        
        temp1Schedule.scheduleDate = beginningOfDay;
        temp1Schedule.offset = [NSNumber numberWithInt:0];
        
        TimeSheet * timeSheet = [NSEntityDescription insertNewObjectForEntityForName: @"TimeSheet"
                                                              inManagedObjectContext: managedObjectContext];
        
        timeSheet.startTime = [NSNumber numberWithInt:-1];
        timeSheet.endTime = [NSNumber numberWithInt:-1];
        timeSheet.breakTime = [NSNumber numberWithInt:-1];
        timeSheet.flatTime = [NSNumber numberWithInt:1200];
        timeSheet.subSequence = [NSNumber numberWithInt:0];
        timeSheet.comments = nil;
        timeSheet.activity = act;
        timeSheet.schedule = temp1Schedule;
        timeSheet.amount = [NSNumber numberWithFloat:0.0f];
        
        [temp1Schedule addTimeSheetsObject:timeSheet];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    
    [self saveContext];
}

#pragma mark -
#pragma mark Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *moContext = self.managedObjectContext;
    if (moContext != nil)
    {
        if ([moContext hasChanges] && ![moContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *) managedObjectContext
{	
    if (managedObjectContext != nil) {
        
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Schedules7" ofType:@"mom" inDirectory:@"Schedules.momd"];
	NSURL *momURL = [NSURL fileURLWithPath:path];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Schedules.sqlite"]];
    
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
        //NSLog(@"Error : %@",[error localizedDescription]);
    }
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)resetApp
{
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
    
    scheduleViewController.managedObjectContext = nil;
	settingsViewController.managedObjectContext = nil;
	reportListViewController.managedObjectContext = nil;
    
    NSManagedObjectContext *context = [self managedObjectContext];
	scheduleViewController.managedObjectContext = context;
	settingsViewController.managedObjectContext = context;
	reportListViewController.managedObjectContext = context;
}

- (void)resetCoreData
{
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Schedules.sqlite"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    [fileManager removeItemAtURL:storeUrl error:NULL];
    
    NSError* error = nil;
    
    if([fileManager fileExistsAtPath:[NSString stringWithContentsOfURL:storeUrl encoding:NSASCIIStringEncoding error:&error]])
    {
        [fileManager removeItemAtURL:storeUrl error:nil];
    }
    
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
}

#pragma mark -
#pragma mark Navigation Controlling
- (void)tabBarController:(UITabBarController *)controller
 didSelectViewController:(UIViewController *)viewController
{
    if( [ controller selectedIndex ] == 1 )
    {
         [ reportListViewController.navigationController popToRootViewControllerAnimated: YES ];
    }
       
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
-(void)checkDaysState
{
    NSInteger monday=[self getValueForDay:2];
    NSInteger tuesday=[self getValueForDay:3];
    NSInteger wednesday=[self getValueForDay:4];
    NSInteger thursday=[self getValueForDay:5];
    NSInteger friday=[self getValueForDay:6];
    NSInteger saturday=[self getValueForDay:7];
    NSInteger sunday=[self getValueForDay:1];
    
//    NSLog(@"mon %d, tue %d, wed %d, thu %d, fri %d, sat %d, sun %d", monday, tuesday, wednesday, thursday, friday, saturday, sunday);
    
    firstLoad=NO;
    
    if (monday==0)
    {
        firstLoad=YES;
        [self saveValue:2 forState:2];
    }
    if (tuesday==0)
    {
        [self saveValue:3 forState:1];
    }
    if (wednesday==0)
    {
        [self saveValue:4 forState:2];
    }
    if (thursday==0)
    {
        [self saveValue:5 forState:2];
    }
    if (friday==0)
    {
        [self saveValue:6 forState:1];
    }
    if (saturday==0)
    {
        [self saveValue:7 forState:2];
    }
    if (sunday==0)
    {
        [self saveValue:1 forState:2];
    }
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

- (void)dealloc
{
//	[settingsViewController release];
//	[scheduleViewController release];
//	[tabBarController release];
//    [window release];
    [super dealloc];
}

-(void)showEmailAlert
{
    [emailReportAlert show];
}

-(void)showDaysLimitAlert
{
    [daysRminderAlert show];
}

-(void)showDropBoxAlert
{
    [dropBoxAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index %d", buttonIndex);
    
    if(alertView == daysRminderAlert ||
       alertView == emailReportAlert||
       alertView == dropBoxAlert)
    {
        if(buttonIndex == 1)
        {
            self.fromAlert = YES;
            [tabBarController setSelectedIndex:3];
        }
    }
}


@end
