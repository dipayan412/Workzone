//
//  ExportImportHandler.m
//  MyOvertime
//
//  Created by Ashif on 6/10/13.
//
//

#import "ExportImportHandler.h"
#import "GlobalFunctions.h"
#import "MyOvertimeAppDelegate.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "Schedule.h"
#import "Settings.h"
#import "SettingsDayTemplate.h"
#import "MyTemplate.h"

@implementation ExportImportHandler

static ExportImportHandler *instance;

@synthesize settingsJsonArray;
@synthesize activitiesJsonArray;
@synthesize schedulesJsonArray;
@synthesize timeSheetsJsonArray;
@synthesize settingsDaytemplatesJsonArray;
@synthesize myTemplatesJsonArray;

@synthesize settingsDB;
@synthesize activitiesDB;
@synthesize settingsDaytemplatesDB;
@synthesize schedulesDB;
@synthesize timeSheetsDB;
@synthesize myTemplatesDB;

+(ExportImportHandler*)getInstance
{
    if (instance == nil)
    {
        instance = [[ExportImportHandler alloc] init];
    }
    
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        loadingView = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    }
    return  self;
}

-(void)prepareDataToExport
{
//    [loadingView show];
    
    [self prepareDataForEntityName:kActivity];
    [self prepareDataForEntityName:kSchedule];
    [self prepareDataForEntityName:kSettings];
    [self prepareDataForEntityName:kSettingsDayTemplate];
    [self prepareDataForEntityName:kMyTemplate];
    [self prepareDataForEntityName:kTimeSheet];
}

-(NSData*)exportDataBase
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    [mutableArray addObject:[self backupDataForEntityName:kActivity]];
    
    NSArray *schedulesArray = [self backupDataForEntityName:kSchedule];
    for(NSDictionary *item in schedulesArray)
    {
        NSDate *date = [item objectForKey:@"scheduleDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *dateStr = [formatter stringFromDate:date];
        [item setValue:dateStr forKey:@"scheduleDate"];
    }
    [mutableArray addObject:schedulesArray];
    
    [mutableArray addObject:[self backupDataForEntityName:kSettings]];
    [mutableArray addObject:[self backupDataForEntityName:kSettingsDayTemplate]];
    [mutableArray addObject:[self backupDataForEntityName:kMyTemplate]];
    [mutableArray addObject:[self backupDataForEntityName:kTimeSheet]];
    
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    [datas setObject:[mutableArray objectAtIndex:0] forKey:kActivity];
    [datas setObject:[mutableArray objectAtIndex:1] forKey:kSchedule];
    [datas setObject:[mutableArray objectAtIndex:2] forKey:kSettings];
    [datas setObject:[mutableArray objectAtIndex:3] forKey:kSettingsDayTemplate];
    [datas setObject:[mutableArray objectAtIndex:4] forKey:kMyTemplate];
    [datas setObject:[mutableArray objectAtIndex:5] forKey:kTimeSheet];
    
//    NSLog(@"datas %@", datas);
    
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithDictionary:datas];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    //Just for error tracing
    jsonWriter.humanReadable = YES;
    NSString *jsonString = [jsonWriter stringWithObject:jsonDictionary];
    
//    NSLog(@"json string %@", jsonString);
    
    if (!jsonString)
    {
        NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter error]);
    }
    [jsonWriter release];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
//    [loadingView dismissWithClickedButtonIndex:-1 animated:YES];

    return data;
}

-(void)importFromBackupFileDemo
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Ashish_Backup_06-12-2013" ofType:@"motad"];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyOvertime_Backup_11-06-2013" ofType:@"motad"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Dan" ofType:@"motad"];    
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self importData:data];
}

-(void)importFromBackup:(NSURL*)_url
{
    NSData *zippedData = [NSData dataWithContentsOfURL:_url];
    [self importData:zippedData];   
}

-(void)importData:(NSData *)_data
{
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *jsonObject = [parser objectWithData:_data];
    
    self.settingsJsonArray = [jsonObject objectForKey:kSettings];
    self.schedulesJsonArray = [jsonObject objectForKey:kSchedule];
    self.activitiesJsonArray = [jsonObject objectForKey:kActivity];
    self.myTemplatesJsonArray = [jsonObject objectForKey:kMyTemplate];
    self.settingsDaytemplatesJsonArray = [jsonObject objectForKey:kSettingsDayTemplate];
    self.timeSheetsJsonArray = [jsonObject objectForKey:kTimeSheet];
    
    /*
    NSLog(@"settings: %@", settingsJsonArray);
    NSLog(@"activities: %@", activitiesJsonArray);
    NSLog(@"schedules: %@", schedulesJsonArray);
    NSLog(@"dayTemplate: %@", settingsDaytemplatesJsonArray);
    NSLog(@"myTemplate: %@", myTemplatesJsonArray);
    NSLog(@"timeSheets: %@", timeSheetsJsonArray);
    */
    
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate resetCoreData];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSMutableArray *actArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<activitiesJsonArray.count; i++)
    {
        NSDictionary *item = [activitiesJsonArray objectAtIndex:i];

        Activity *activity = (Activity *)[NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:managedObjectContext];
		
		activity.activityTitle = [item objectForKey:@"activityTitle"];
        BOOL flatMode = [[item objectForKey:@"flatMode"] boolValue];
		activity.flatMode = [NSNumber numberWithBool:flatMode];
        BOOL overtimeReduce = [[item objectForKey:@"overtimeReduce"] boolValue];
        activity.overtimeReduce = [NSNumber numberWithBool:overtimeReduce];
        BOOL isEnabled = [[item objectForKey:@"isEnabled"] boolValue];
		activity.isEnabled = [NSNumber numberWithBool:isEnabled];
        BOOL estimateMode = [[item objectForKey:@"estimateMode"] boolValue];
		activity.estimateMode = [NSNumber numberWithBool:estimateMode];
		activity.subSequence = [NSNumber numberWithInt:[[item objectForKey:@"subSequence"] intValue]];
        BOOL useDefault = [[item objectForKey:@"useDefault"] boolValue];
        activity.useDefault = [NSNumber numberWithBool:useDefault];
        int offsetValue = [[item objectForKey:@"offsetValue"] intValue];
        activity.offsetValue = [NSNumber numberWithInt:offsetValue];
        BOOL showAmount = [[item objectForKey:@"showAmount"] boolValue];
        activity.showAmount = [NSNumber numberWithBool:showAmount];
        CGFloat amount = [[item objectForKey:@"amount"] floatValue];
        activity.amount = [NSNumber numberWithFloat:amount];
        activity.allowance = [NSNumber numberWithFloat:[[item objectForKey:@"allowance"] floatValue]];
        activity.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
        
        [actArray addObject:activity];
    }
    
    NSLog(@"actArray count %d", actArray.count);
    self.activitiesDB = actArray;
    [actArray release];
    
    NSMutableArray *settArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<settingsJsonArray.count; i++)
    {
        NSDictionary *item = [settingsJsonArray objectAtIndex:i];
        
        Settings *settings = (Settings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
        
//        settings.identifier = [item objectForKey:@"identifier"];
        settings.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
        settings.name = [item objectForKey:@"name"];
    
        [settArray addObject:settings];
    }
    
    self.settingsDB = settArray;
    [settArray release];
    
    NSMutableArray *schArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<schedulesJsonArray.count; i++)
    {
        NSDictionary *item = [schedulesJsonArray objectAtIndex:i];
        
        Schedule *schedule = (Schedule *)[NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:managedObjectContext];
        
//        schedule.identifier = [item objectForKey:@"identifier"];
        schedule.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
        schedule.offset = [NSNumber numberWithInt:[[item objectForKey:@"offset"] intValue]];
        
        NSString *dateStr = [item objectForKey:@"scheduleDate"];
        if(!dateStr || dateStr.length < 1)
        {
            dateStr = @"01/01/2001";
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        NSDate *ccDate = [dateFormatter dateFromString:dateStr];
        
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:ccDate];
        [dateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
    
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                  fromDate:ccDate];
        [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-1000"]];
        NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MM/dd/yyyy"];
//        schedule.scheduleDate = [formatter dateFromString:dateStr];
        schedule.scheduleDate = beginningOfDay;
        
//        NSLog(@"dateStr %@, NSDate %@", dateStr, schedule.scheduleDate);
        
        [schArray addObject:schedule];
    }
    
    self.schedulesDB = schArray;
    [schArray release];
    
    NSMutableArray *setTemplateArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<settingsDaytemplatesJsonArray.count; i++)
    {
        NSDictionary *item = [settingsDaytemplatesJsonArray objectAtIndex:i];
        
        SettingsDayTemplate *settingsTemplate = (SettingsDayTemplate *)[NSEntityDescription insertNewObjectForEntityForName:@"SettingsDayTemplate" inManagedObjectContext:managedObjectContext];
        
//        settingsTemplate.identifier = [item objectForKey:@"identifier"];
        settingsTemplate.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
        settingsTemplate.day = [NSNumber numberWithInt:[[item objectForKey:@"day"] intValue]];
//        settingsTemplate.scheduleId = [item objectForKey:@"scheduleId"];
        settingsTemplate.scheduleId = [NSString stringWithFormat:@"%@", [item objectForKey:@"scheduleId"]];
        BOOL enabled = [[item objectForKey:@"templateEnabled"] boolValue];
        settingsTemplate.templateEnabled = [NSNumber numberWithBool:enabled];
        
        [setTemplateArray addObject:settingsTemplate];
    }
    
    self.settingsDaytemplatesDB = setTemplateArray;
    [setTemplateArray release];
    
    NSMutableArray *myTemplateArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<myTemplatesJsonArray.count; i++)
    {
        NSDictionary *item = [myTemplatesJsonArray objectAtIndex:i];
        
        MyTemplate *myTemplate = (MyTemplate *)[NSEntityDescription insertNewObjectForEntityForName:@"MyTemplate" inManagedObjectContext:managedObjectContext];
        
//        myTemplate.identifier = [item objectForKey:@"identifier"];
        myTemplate.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
        myTemplate.scheduleId = [NSString stringWithFormat:@"%@", [item objectForKey:@"scheduleId"]];
        myTemplate.subSequence = [NSNumber numberWithInt:[[item objectForKey:@"subSequence"] intValue]];
        myTemplate.templateName = [item objectForKey:@"templateName"];
        
        [myTemplateArray addObject:myTemplate];
    }
    
    self.myTemplatesDB = myTemplateArray;
    [myTemplateArray release];
    
    NSMutableArray *timeSheetArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<timeSheetsJsonArray.count; i++)
    {
        NSDictionary *item = [timeSheetsJsonArray objectAtIndex:i];
        
        TimeSheet *timeSheet = (TimeSheet *)[NSEntityDescription insertNewObjectForEntityForName:@"TimeSheet" inManagedObjectContext:managedObjectContext];
        
//        timeSheet.identifier = [item objectForKey:@"identifier"];
        timeSheet.identifier = [NSString stringWithFormat:@"%@", [item objectForKey:@"identifier"]];
//        timeSheet.activityId = [item objectForKey:@"activityId"];
        timeSheet.activityId = [NSString stringWithFormat:@"%@", [item objectForKey:@"activityId"]];
//        timeSheet.scheduleId = [item objectForKey:@"scheduleId"];
        timeSheet.scheduleId = [NSString stringWithFormat:@"%@", [item objectForKey:@"scheduleId"]];
        timeSheet.amount = [NSNumber numberWithFloat:[[item objectForKey:@"amount"] floatValue]];
        timeSheet.breakTime = [NSNumber numberWithInt:[[item objectForKey:@"breakTime"] intValue]];
        timeSheet.comments = [item objectForKey:@"comments"];
        timeSheet.endTime = [NSNumber numberWithInt:[[item objectForKey:@"endTime"] intValue]];
        timeSheet.flatTime = [NSNumber numberWithInt:[[item objectForKey:@"flatTime"] intValue]];
        timeSheet.startTime = [NSNumber numberWithInt:[[item objectForKey:@"startTime"] intValue]];
        timeSheet.subSequence = [NSNumber numberWithInt:[[item objectForKey:@"subSequence"] intValue]];
        [timeSheetArray addObject:timeSheet];
    }
    
    self.timeSheetsDB = timeSheetArray;
    [timeSheetArray release];
    
    for(int i=0; i<settingsDaytemplatesDB.count; i++)
    {
        Settings *settings = [settingsDB objectAtIndex:0];
        SettingsDayTemplate *template = [settingsDaytemplatesDB objectAtIndex:i];
        template.setting = settings;
        
        for(int j=0; j<schedulesDB.count; j++)
        {
            Schedule *schedule = [schedulesDB objectAtIndex:j];
            if([schedule.identifier isEqualToString:template.scheduleId])
            {
                template.schedule = schedule;
            }
        }
    }
    
    for(int i=0; i<myTemplatesDB.count; i++)
    {
        MyTemplate *template = [myTemplatesDB objectAtIndex:i];
        for(int j=0; j<schedulesDB.count; j++)
        {
            Schedule *schedule = [schedulesDB objectAtIndex:j];
            if([schedule.identifier isEqualToString:template.scheduleId])
            {
                template.schedule = schedule;
            }
        }
    }
    
    
    for(int i=0; i<timeSheetsDB.count; i++)
    {
        TimeSheet *timeSheet = [timeSheetsDB objectAtIndex:i];
        
        for(int k=0; k<activitiesDB.count; k++)
        {
            Activity *activity = [activitiesDB objectAtIndex:k];
            if([activity.identifier isEqualToString:timeSheet.activityId])
            {
                timeSheet.activity = activity;
//                [activity addTimeSheetsObject:timeSheet];
            }
        }
        
        for(int j=0; j<schedulesDB.count; j++)
        {
            Schedule *schedule = [schedulesDB objectAtIndex:j];
            if([schedule.identifier isEqualToString:timeSheet.scheduleId])
            {
//                timeSheet.schedule = schedule;
                [schedule addTimeSheetsObject:timeSheet];
            }
        }
    }
    
    NSError *error = nil;
    if ([managedObjectContext save:&error])
    {
        
    }
    else
    {
        NSLog(@"import failed");
    }
    
}

-(void)prepareDataForEntityName:(NSString *)entityName
{
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    if([entityName isEqualToString:kActivity])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        // Execute the fetch -- create a mutable copy of the result.
        NSError *activitiesError = nil;
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:&activitiesError];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(Activity *activity in activitiesResults)
            {
                if(activity.identifier == nil || activity.identifier.length < 1)
                {
                    activity.identifier = [GlobalFunctions GetUUID];
                    [self saveToManagedObjectContext];
                }
            }
        }
        
        [request release];
        
    }
    else if ([entityName isEqualToString:kSchedule])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:kSchedule inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:nil];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(Schedule *schedule in activitiesResults)
            {
                if(schedule.identifier == nil || schedule.identifier.length < 1)
                {
                    schedule.identifier = [GlobalFunctions GetUUID];
                    [self saveToManagedObjectContext];
                }
            }
        }
        
        [request release];
    }
    else if ([entityName isEqualToString:kTimeSheet])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:kTimeSheet inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:nil];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(TimeSheet *timeSheet in activitiesResults)
            {
                if(timeSheet.identifier == nil || timeSheet.identifier.length < 1)
                {
                    timeSheet.identifier = [GlobalFunctions GetUUID];
                }
                if(timeSheet.schedule)
                {
                    if(timeSheet.schedule.identifier != nil || timeSheet.schedule.identifier.length > 0)
                    {
                        timeSheet.scheduleId = timeSheet.schedule.identifier;
                    }
                    else
                    {
                        timeSheet.scheduleId = @"";
                    }
                }
                else
                {
                    timeSheet.scheduleId = @"";
                }
                if(timeSheet.activity)
                {
                    if(timeSheet.activity.identifier != nil || timeSheet.activity.identifier.length > 0)
                    {
                        timeSheet.activityId = timeSheet.activity.identifier;
                    }
                }
                else
                {
                    timeSheet.activityId = @"";
                }
                if(!timeSheet.comments)
                {
                    timeSheet.comments = @"";
                }
                
                [self saveToManagedObjectContext];
            }
        }
        
        [request release];
    }
    else if ([entityName isEqualToString:kSettings])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:kSettings inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:nil];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(Settings *settings in activitiesResults)
            {
                if(settings.identifier == nil || settings.identifier.length < 1)
                {
                    settings.identifier = [GlobalFunctions GetUUID];
                    [self saveToManagedObjectContext];
                }
            }
        }
        
        [request release];
    }
    else if ([entityName isEqualToString:kSettingsDayTemplate])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:kSettingsDayTemplate inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:nil];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(SettingsDayTemplate *settingsDayTemplate in activitiesResults)
            {
                if(settingsDayTemplate.identifier == nil || settingsDayTemplate.identifier.length < 1)
                {
                    settingsDayTemplate.identifier = [GlobalFunctions GetUUID];
                }
                
                if(settingsDayTemplate.schedule)
                {
                    if(settingsDayTemplate.schedule.identifier != nil || settingsDayTemplate.schedule.identifier.length > 0)
                    {
                        settingsDayTemplate.scheduleId = settingsDayTemplate.schedule.identifier;
                    }
                    else
                    {
                        settingsDayTemplate.scheduleId = @"";
                    }
                }
                else
                {
                    settingsDayTemplate.scheduleId = @"";
                }
                
                [self saveToManagedObjectContext];
            }
        }
        
        [request release];
    }
    else if ([entityName isEqualToString:kMyTemplate])
    {
        NSEntityDescription *activityEntity = [NSEntityDescription entityForName:kMyTemplate inManagedObjectContext:managedObjectContext];
        [request setEntity:activityEntity];
        
        NSArray *activitiesResults = [managedObjectContext executeFetchRequest:request error:nil];
        
        if (activitiesResults == nil)
        {
            // Handle the error.
        }
        else
        {
            for(MyTemplate *myTemplate in activitiesResults)
            {
                if(myTemplate.identifier == nil || myTemplate.identifier.length < 1)
                {
                    myTemplate.identifier = [GlobalFunctions GetUUID];
                }
                if(myTemplate.schedule)
                {
                    if(myTemplate.schedule.identifier != nil || myTemplate.schedule.identifier.length > 0)
                    {
                        myTemplate.scheduleId = myTemplate.schedule.identifier;
                    }
                    else
                    {
                        myTemplate.scheduleId = @"";
                    }
                }
                else
                {
                    myTemplate.scheduleId = @"";
                }
                
                [self saveToManagedObjectContext];
            }
        }
        
        [request release];
    }
    
}

-(NSArray*)backupDataForEntityName:(NSString *)entityName
{
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSArray *array = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSMutableArray *dataDictionary = [[NSMutableArray alloc] init];
    
    if([entityName isEqualToString:kActivity])
    {
        for (Activity *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            [dictionary setObject:item.activityTitle forKey:@"activityTitle"];
            [dictionary setObject:[NSNumber numberWithInt:item.offsetValue.intValue] forKey:@"offsetValue"];
            [dictionary setObject:[NSNumber numberWithFloat:item.amount.floatValue] forKey:@"amount"];
            [dictionary setObject:[NSNumber numberWithFloat:item.allowance.floatValue] forKey:@"allowance"];
            [dictionary setObject:[NSNumber numberWithBool:item.showAmount.boolValue] forKey:@"showAmount"];
            [dictionary setObject:[NSNumber numberWithBool:item.overtimeReduce.boolValue] forKey:@"overtimeReduce"];
            [dictionary setObject:[NSNumber numberWithBool:item.useDefault.boolValue] forKey:@"useDefault"];
            [dictionary setObject:[NSNumber numberWithBool:item.flatMode.boolValue] forKey:@"flatMode"];
            [dictionary setObject:[NSNumber numberWithInt:item.subSequence.intValue] forKey:@"subSequence"];
            [dictionary setObject:[NSNumber numberWithBool:item.isEnabled.boolValue] forKey:@"isEnabled"];
            [dictionary setObject:[NSNumber numberWithBool:item.estimateMode.boolValue] forKey:@"estimateMode"];
            
            
            [dataDictionary addObject:dictionary];
        }
    }
    else if ([entityName isEqualToString:kSchedule])
    {
        for (Schedule *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            if(item.scheduleDate)
            {
                [dictionary setObject:item.scheduleDate forKey:@"scheduleDate"];
            }
            else
            {
                NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:1];
                [dictionary setObject:date forKey:@"scheduleDate"];
            }
            
            [dictionary setObject:[NSNumber numberWithFloat:item.offset.intValue] forKey:@"offset"];
            
            [dataDictionary addObject:dictionary];
        }
    }
    else if ([entityName isEqualToString:kSettings])
    {
        for (Settings *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            [dictionary setObject:item.name forKey:@"name"];

            [dataDictionary addObject:dictionary];
        }
    }
    else if ([entityName isEqualToString:kSettingsDayTemplate])
    {
        for (SettingsDayTemplate *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            [dictionary setObject:item.scheduleId forKey:@"scheduleId"];
            [dictionary setObject:[NSNumber numberWithBool:item.templateEnabled.boolValue] forKey:@"templateEnabled"];
            [dictionary setObject:[NSNumber numberWithInt:item.day.intValue] forKey:@"day"];
            
            [dataDictionary addObject:dictionary];
        }
    }
    else if ([entityName isEqualToString:kMyTemplate])
    {
        for (MyTemplate *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            [dictionary setObject:item.scheduleId forKey:@"scheduleId"];
            [dictionary setObject:item.templateName forKey:@"templateName"];
            [dictionary setObject:[NSNumber numberWithInt:item.subSequence.intValue] forKey:@"subSequence"];
            
            [dataDictionary addObject:dictionary];
        }
    }
    else if ([entityName isEqualToString:kTimeSheet])
    {
        for (TimeSheet *item in array)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:item.identifier forKey:@"identifier"];
            [dictionary setObject:item.scheduleId forKey:@"scheduleId"];
            [dictionary setObject:item.activityId forKey:@"activityId"];
            [dictionary setObject:[NSNumber numberWithInt:item.subSequence.intValue] forKey:@"subSequence"];
            [dictionary setObject:[NSNumber numberWithInt:item.flatTime.intValue] forKey:@"flatTime"];
            [dictionary setObject:[NSNumber numberWithInt:item.startTime.intValue] forKey:@"startTime"];
            [dictionary setObject:[NSNumber numberWithInt:item.endTime.intValue] forKey:@"endTime"];
            [dictionary setObject:[NSNumber numberWithInt:item.breakTime.intValue] forKey:@"breakTime"];
            [dictionary setObject:[NSNumber numberWithFloat:item.amount.floatValue] forKey:@"amount"];
            [dictionary setObject:item.comments forKey:@"comments"];
            
            [dataDictionary addObject:dictionary];
        }
    }
    return dataDictionary;
}

/*
-(NSArray*)backupDataForEntityName:(NSString *)entityName
{
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSArray *array = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    NSMutableArray *dataDictionary = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *managedObject in array)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        for (NSPropertyDescription *property in entity)
        {
            if ([property isKindOfClass:[NSAttributeDescription class]])
            {
                if ([managedObject valueForKey:property.name])
                {
                    [dictionary setObject:[managedObject valueForKey:property.name] forKey:property.name];
                }
                else
                {
                    [dictionary setObject:@"" forKey:property.name];
                }
            }
        }
//        NSLog(@"Dictionary: %@", dictionary);
        [dataDictionary addObject:dictionary];
    }
    
    return dataDictionary;
}
*/

-(void)saveToManagedObjectContext
{
    MyOvertimeAppDelegate *appDelegate = (MyOvertimeAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSError *error;
	if (![managedObjectContext save:&error])
    {
		// Handle the error.
	}
}

-(void)showLoadingView:(BOOL)_show
{
    /*
    if(_show)
    {
        [loadingView show];
    }
    else
    {
        [loadingView dismissWithClickedButtonIndex:-1 animated:YES];
    }
     */
}

-(void)dealloc
{
    [self.activitiesJsonArray release];
    [self.schedulesJsonArray release];
    [self.settingsJsonArray release];
    [self.settingsDaytemplatesDB release];
    [self.myTemplatesJsonArray release];
    [self.timeSheetsJsonArray release];
    
    [self.activitiesDB release];
    [self.schedulesDB release];
    [self.settingsDB release];
    [self.settingsDaytemplatesDB release];
    [self.myTemplatesDB release];
    [self.timeSheetsDB release];
    
    [loadingView release];
    
    [super dealloc];
}


@end
