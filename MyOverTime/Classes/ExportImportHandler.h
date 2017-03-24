//
//  ExportImportHandler.h
//  MyOvertime
//
//  Created by Ashif on 6/10/13.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

#define kActivity @"Activity"
#define kSchedule @"Schedule"
#define kTimeSheet @"TimeSheet"
#define kSettings @"Settings"
#define kSettingsDayTemplate @"SettingsDayTemplate"
#define kMyTemplate @"MyTemplate"


@interface ExportImportHandler : NSObject
{
    UIAlertView *loadingView;
}

@property (nonatomic, retain) NSArray *settingsJsonArray;
@property (nonatomic, retain) NSArray *timeSheetsJsonArray;
@property (nonatomic, retain) NSArray *settingsDaytemplatesJsonArray;
@property (nonatomic, retain) NSArray *activitiesJsonArray;
@property (nonatomic, retain) NSArray *schedulesJsonArray;
@property (nonatomic, retain) NSArray *myTemplatesJsonArray;

@property (nonatomic, retain) NSArray *settingsDB;
@property (nonatomic, retain) NSArray *timeSheetsDB;
@property (nonatomic, retain) NSArray *settingsDaytemplatesDB;
@property (nonatomic, retain) NSArray *activitiesDB;
@property (nonatomic, retain) NSArray *schedulesDB;
@property (nonatomic, retain) NSArray *myTemplatesDB;

+(ExportImportHandler*)getInstance;
-(void)prepareDataToExport;
-(NSData*)exportDataBase;
-(void)importFromBackup:(NSURL*)_url;
-(void)importFromBackupFileDemo;

-(void)showLoadingView:(BOOL)_show;

@end
