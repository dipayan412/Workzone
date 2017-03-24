//
//  GlobalFunctions.m
//  LMKMaster
//
//  Created by Christopher Luu on 7/19/10.
//  Copyright 2010 Fuzz Productions. All rights reserved.
//

#import "GlobalFunctions.h"
//#import "FlurryAPI.h"

#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#include <sys/sysctl.h>
#import "Localizator.h" 

#define kAppVersion @"kAppVersion"

#define kHoursToDays @"kHoursToDays"

#define kShowButtonsOptins1 @"kShowButtonsOptins1"
#define kShowButtonsOptins2 @"kShowButtonsOptins2"
#define kShowButtonsOptins3 @"kShowButtonsOptins3"
#define kShowButtonsOptins4 @"kShowButtonsOptins4"

#define kTimeStyle @"kTimeStyle"

#define kDefaultEmail @"EMAIL_PREF" 

@implementation GlobalFunctions

static UIAlertView *_progressAlert;

+(int)hoursToDays
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kHoursToDays];
    if(storedPref)
    {
        return storedPref.intValue;
    }
    return 8;
}

+(void)setHoursToDays:(int)hour
{
    [[NSUserDefaults standardUserDefaults] setInteger:hour forKey:kHoursToDays];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getBundlePath:(NSString *)inPath
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:inPath];
}

+ (NSString *)getDocumentPath:(NSString *)inPath createDirectories:(BOOL)inCreateDirectories
{
	NSString *tmpString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:inPath];
	NSString *directoryPath = [tmpString stringByDeletingLastPathComponent];
	if (inCreateDirectories && ![[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
		[[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return tmpString;
}

+ (NSDate *)dateFromDateString:(NSString *)inDateString timeString:(NSString *)inTimeString
{
	NSDateFormatter *tmpDateFormatter = [[NSDateFormatter alloc] init];
	[tmpDateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    [ tmpDateFormatter setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: [ Localizator localeIdentifierForActiveLanguage ] ] ];
	NSDate *tmpDate = [tmpDateFormatter dateFromString:[inDateString stringByAppendingFormat:@" %@", inTimeString]];
	[tmpDateFormatter release];

	return tmpDate;
}

+ (NSString *)getMD5SumFromData:(NSData *)inData
{
	const char *cStr = [inData bytes];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, [inData length], result);
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

+ (NSArray *)getPropertiesForClass:(Class)inClass
{
	unsigned int outCount = 0;
	objc_property_t *properties = class_copyPropertyList(inClass, &outCount);
	if (outCount > 0)
	{
		NSMutableArray *tmpArray = [NSMutableArray array];
		for (int i = 0; i < outCount; i++)
			[tmpArray addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];

		return tmpArray;
	}
	return nil;
}

+ (NSString *)getPlatform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return platform;
}

+ (void)logFlurryEvent:(NSString *)inEventName withParameters:(NSDictionary *)inParameters
{
//#ifndef DEBUG
//	[FlurryAPI logEvent:inEventName withParameters:inParameters];
//#endif
}

+ (void)reportConnectionError:(NSError *)inError forURL:(NSURL *)inURL
{
	//NSLog(@"Error (%@) for URL: %@", [inError localizedDescription], inURL);
//#ifndef DEBUG
//	[FlurryAPI logEvent:@"ConnectionError" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[inURL absoluteString], @"URL", [inError localizedDescription], @"Error", nil]];
//#endif
}

+ (void)showProgressAlert:(NSString*)message {
	//	Purchasing Spinner.
	if (!_progressAlert) {
		_progressAlert = [[UIAlertView alloc] initWithTitle:message
												 message:nil
												delegate:self
									   cancelButtonTitle:nil
									   otherButtonTitles:nil];
		_progressAlert.tag = (NSUInteger)100;
		[_progressAlert show];
		
		UIActivityIndicatorView *connectingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		connectingIndicator.frame = CGRectMake(139.0f-18.0f,50.0f,37.0f,37.0f);
		[_progressAlert addSubview:connectingIndicator];
		[connectingIndicator startAnimating];
		[connectingIndicator release];
	}
}

+ (void)dismissProgressAlert {
	if (_progressAlert) {
		[_progressAlert dismissWithClickedButtonIndex:0 animated:YES];
		[_progressAlert release];
		_progressAlert = nil;
	}	
}

+ (void)showMessageAlert:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

//	$TING CODE
+ (float)allowanceHoursFromField:(float)hourToShow {
	int min = ((int)(hourToShow * 100)) % 100;
	int h = ((int)hourToShow * 100) / 100;
	return h + min/60.0f;
}
+ (float)allowanceHoursToField:(float)hourToSave {
	int hour = ((int)(hourToSave * 100)) / 100;
	int minpro = ((int)(hourToSave * 100)) % 100;
	int min = minpro * 0.6;
	return (hour + min)/100.0f;
}

+(int)launchCount
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:@"kMyOverTimeLaunchCount"];
    if (storedPref)
    {
        return storedPref.intValue;
    }
    
    return 0;
}

+(void)setLaunchCount:(int)count
{
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"kMyOverTimeLaunchCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setDropboxEnabled:(BOOL)_enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:_enabled forKey:@"kMyOverTimeDropboxSync"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isDropboxEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kMyOverTimeDropboxSync"];
}

+(CGFloat)getVersionNumber
{
    NSNumber *storedPref = [[NSUserDefaults standardUserDefaults] valueForKey:kAppVersion];
    if (storedPref)
    {
        return storedPref.floatValue;
    }
    
    return 2.1;
}

+(void)setVersionNumber:(CGFloat)_cVersion
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:_cVersion] forKey:kAppVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setShowButtonsOptions1:(BOOL)_options
{
    [[NSUserDefaults standardUserDefaults] setBool:_options forKey:kShowButtonsOptins1];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getShowButtonsOptions1
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:kShowButtonsOptins1];
    if (storedPref)
    {
        return storedPref.boolValue;
    }
    
    return YES;
}

+(void)setShowButtonsOptions2:(BOOL)_options
{
    [[NSUserDefaults standardUserDefaults] setBool:_options forKey:kShowButtonsOptins2];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getShowButtonsOptions2
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:kShowButtonsOptins2];
    if (storedPref)
    {
        return storedPref.boolValue;
    }
    
    return YES;
}

+(void)setShowButtonsOptions3:(BOOL)_options
{
    [[NSUserDefaults standardUserDefaults] setBool:_options forKey:kShowButtonsOptins3];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getShowButtonsOptions3
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:kShowButtonsOptins3];
    if (storedPref)
    {
        return storedPref.boolValue;
    }
    
    return YES;
}

+(void)setShowButtonsOptions4:(BOOL)_options
{
    [[NSUserDefaults standardUserDefaults] setBool:_options forKey:kShowButtonsOptins4];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getShowButtonsOptions4
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:kShowButtonsOptins4];
    if (storedPref)
    {
        return storedPref.boolValue;
    }
    
    return YES;
}

+(void)setdefaultEmail:(NSString*)_email
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:_email forKey:kDefaultEmail];
	[prefs synchronize];
}

+(NSString*)getDefaultEmail
{
    NSString *storedPref = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultEmail];
    if(storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setLastBackUpDate:(NSDate*)_date
{
    [[NSUserDefaults standardUserDefaults] setObject:_date forKey:@"kLastBackUpDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getLastBackUpDate
{
    NSDate *storedPref = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastBackUpDate"];
    if(storedPref)
    {
        return storedPref;
    }
    return nil;
}

+(void)setTimeStyle:(TimeStyle)_timeStyle
{
    [[NSUserDefaults standardUserDefaults] setInteger:_timeStyle forKey:kTimeStyle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(TimeStyle)getTimeStyle
{
    TimeStyle timeStyle = [[NSUserDefaults standardUserDefaults] integerForKey:kTimeStyle];
    return timeStyle;
}

+(NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

+(void) updatePaymentStatus:(NSInteger) identifier
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // int firstSelected= [prefs integerForKey:@"UpgradeProduct"];
    NSString *archiveKey=[NSString stringWithFormat:@"UpgradeProduct%d",identifier];
    [prefs setInteger:1 forKey:archiveKey];
    [prefs synchronize];
    
}

+(BOOL )getProductStatus:(NSInteger) identifier
{
    BOOL flag=NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *archiveKey=[NSString stringWithFormat:@"UpgradeProduct%d",identifier];
    NSInteger buyFlag= [prefs integerForKey:archiveKey];
    if (buyFlag==1)
    {
        flag= YES;
    }
    return  flag;
}

+(NSString*)getChangedFileName:(NSString*)attName
{
    NSString *attachmentName = attName;
    
    NSArray *nameArr = [attachmentName componentsSeparatedByString:@"_"];
    NSString *amPM = [nameArr lastObject];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    TimeStyle timeStyle = [GlobalFunctions getTimeStyle];
    if(timeStyle == StyleAmPm)
    {
        [timeFormatter setDateFormat:@"a"];
        NSString *timeStr = [timeFormatter stringFromDate:[NSDate date]];
        if([timeStr isEqualToString:@"AM"])
        {
            attachmentName = [attachmentName stringByReplacingOccurrencesOfString:amPM withString:NSLocalizedString(@"LOCAL_AM", nil)];
        }
        else
        {
            attachmentName = [attachmentName stringByReplacingOccurrencesOfString:amPM withString:NSLocalizedString(@"LOCAL_PM", nil)];
        }
    }
    return attachmentName;
}

+(BOOL ) checkLastDate:(NSDate *) newDate
{
    NSDate *lastbackupDate = [[NSUserDefaults standardUserDefaults] objectForKey:kAppLastBackupDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[Localizator dateFormatForActiveLanguage]];
    if(lastbackupDate)
    {
        NSString *lastbackupDateStr = [formatter stringFromDate:lastbackupDate];
        if([lastbackupDateStr isEqualToString:[formatter stringFromDate:newDate]])
        {
            return YES;
        }
    }
    return NO;
}

+(void)saveLastCheckUpDate
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kAppLastBackupDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
