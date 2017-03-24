//
//  GlobalFunctions.h
//  LMKMaster
//
//  Created by Christopher Luu on 7/19/10.
//  Copyright 2010 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBColor(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define USER_INTERFACE_IPHONE5() (([UIScreen mainScreen].applicationFrame.size.height > 480) ? YES : NO)

#define kDropboxFolderName @"Backup_iOS"
#define kDropboxKey @"5e6kcy5jwbv3yw6"
#define kDropboxSecret @"oz9b6atzvusd08h"
#define kDropboxKeyIAP @"8helmlbjzwiu0h8"
#define kDropboxSecretIAP @"p1sjlpz4w582teh"
#define kAppLastBackupDate @"kAppLastBackupDate"

typedef enum
{
    ProductTypeDaysLimit,
    ProductTypeExportData,
    ProductTypeDropbox
}ProductType;

typedef enum
{
    NoOffset,
    MonDayOffset,
    TueDayOffset,
    WedOffset,
    ThuOffset,
    FriOffset,
    SatOffset,
    SunDayOffset
}OffSetForDay;

typedef enum
{
    NoBreak,
    MonDayBreak,
    TueDayBreak,
    WedBreak,
    ThuBreak,
    FriBreak,
    SatBreak,
    SunBreak
}BreakForDay;

typedef enum
{
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday
}WeekDay;

#define kMultiSelectString @"...+"

typedef enum
{
    StyleAmPm,
    Style24Mode,
    StyleDecimal
}TimeStyle;

@interface GlobalFunctions : NSObject
{

}

+ (NSString *)getBundlePath:(NSString *)inPath;
+ (NSString *)getDocumentPath:(NSString *)inPath createDirectories:(BOOL)inCreateDirectories;
+ (NSDate *)dateFromDateString:(NSString *)inDateString timeString:(NSString *)inTimeString;
+ (NSString *)getMD5SumFromData:(NSData *)inData;
+ (NSArray *)getPropertiesForClass:(Class)inClass;
+ (NSString *)getPlatform;
+ (void)logFlurryEvent:(NSString *)inEventName withParameters:(NSDictionary *)inParameters;
+ (void)reportConnectionError:(NSError *)inError forURL:(NSURL *)inURL;
+ (void)showProgressAlert:(NSString*)message;
+ (void)dismissProgressAlert;
+ (void)showMessageAlert:(NSString*)message;
//	$TING CODE 
+ (float)allowanceHoursFromField:(float)hourToShow;
+ (float)allowanceHoursToField:(float)hourToSave;

+(int)launchCount;
+(void)setLaunchCount:(int)count;
+(CGFloat)getVersionNumber;
+(void)setVersionNumber:(CGFloat)_cVersion;
+(void)setDropboxEnabled:(BOOL)_enabled;
+(BOOL)isDropboxEnabled;

+(void)setShowButtonsOptions1:(BOOL)_options;
+(BOOL)getShowButtonsOptions1;

+(void)setShowButtonsOptions2:(BOOL)_options;
+(BOOL)getShowButtonsOptions2;

+(void)setShowButtonsOptions3:(BOOL)_options;
+(BOOL)getShowButtonsOptions3;

+(void)setShowButtonsOptions4:(BOOL)_options;
+(BOOL)getShowButtonsOptions4;

+(void)setdefaultEmail:(NSString*)_email;
+(NSString*)getDefaultEmail;

+(void)setLastBackUpDate:(NSDate*)_date;
+(NSDate*)getLastBackUpDate;

+(void)setTimeStyle:(TimeStyle)_timeStyle;
+(TimeStyle)getTimeStyle;

+(NSString *)GetUUID;

+(void) updatePaymentStatus:(NSInteger) identifier;
+(BOOL )getProductStatus:(NSInteger) identifier;

+(NSString*)getChangedFileName:(NSString*)attName;

+(BOOL ) checkLastDate:(NSDate *) newDate;
+(void)saveLastCheckUpDate;

+(int)hoursToDays;
+(void)setHoursToDays:(int)hour;

@end
